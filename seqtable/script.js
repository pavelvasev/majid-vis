/* example data
var jjj = [
 [0,"Majid","ATGACATGACAGTCACCACACTGAGAGAGAGA"],
 [10,"Name 2","ATGACATGACAGTCACCACACTGAGAGAGAGA"],
 [9,"Name 3","ATGACATGACAGTCACCACACTGAGAGAGAGA"]
];
*/

// makes table according to specs
// input: element - root element whose inner html will be replaced with table
//        data - loaded data in json format
function seqtableMakeData(element,data){
  var s = "";
  s += "<table class='seq_table'>";
  
  s += "<thead><tr><th>№</th><th>Score</th><th>ID</th><th colspan=1000>Sequence</th></tr></thead>"

  //var data = jjj;
  for (var i=0; i<data.length; i++) {
    var line = data[i];
    s += "<tr>";
    s += "<td class='seq_n'>"+(i > 0 ? i : "") +"</td>";
    s += "<td class='seq_score'>" + (line[0] >= 0 ? line[0] : "") + "</td>"
    s += "<td class='seq_id'>"+line[1]+"</td>"
    var seq = line[2];
    for (var j=0; j<seq.length; j++) {
      s += "<td class='seq_val seq_val_" + seq[j] + "'>"+seq[j]+"</td>";
    }
    s += "</tr>";
  }
  
  s += "</table>";
  
  element.innerHTML = s;
  
  // should call coloring here - after constructing dom
  colorizeScores( element, data );
  
  return;
}

// adds colors to the cells with score value
// palette: max = red, min = blue
// input: element - root element to find score cells (lookup with class "seq_score")
//        data - data values for sequences
function colorizeScores(element, data)
{
  // calc score range
  var scores = [];
  for (var i=1; i<data.length; i++) scores.push( data[i][0] );
  var minscore = Math.min.apply(null,scores);
  var maxscore = Math.max.apply(null,scores);
  var diffscore = maxscore-minscore;
  
  if (diffscore <= 0.0001) return;
  
  function scorecolor(v) {
    var v = (v-minscore)/diffscore;
    
    var r = 255 * v;
    var b = 255 * (1-v);
    return "rgb( "+r+",0,"+b+")";
  }
  
  var cells = element.getElementsByClassName( "seq_score" );
  if (cells.length != data.length) return;
  
  for (var i=1; i<data.length; i++) {
    if (data[i][0] >= 0)
        cells[i].style.backgroundColor = scorecolor( data[i][0] );
  }
}

function seqmsg( element, msg )
{
  console.log( msg );
  element.innerHTML = "<span class='seq_msg seq_msg_info'>Sequence table: "+msg+"</span>";

}

function seqerr( element, msg )
{
  console.log( msg );
  element.innerHTML = "<span class='seq_msg seq_msg_err'>Sequence table ERROR. "+msg+"</span>";
}

// performs "seqtable" tag parsing and loads data
// input: element - the seqtable tag
function seqtableMake(element){
  var src = element.attributes.src.value;
  
  if (src) {
    seqmsg( element,"loading data from json file..<progress value2=33 max2=100></progress>" );
    
    function reqListener () {
       console.log("==== got data");
       //console.log(this.responseText);
       console.log("==== parsing");
       var j;
       try {
         j = JSON.parse( this.responseText );
       } catch(e) {
         console.log(e);
         seqerr( element, "failed to parse json file. "+e.message );
         return;
       }
       try {
         seqtableMakeData( element, j );
       } catch(e) {
         console.error(e);
         seqerr( element,"failed to generate table from parsed data"+e.message );
         return;
       }
    }
    
    function transferFailed(evt) {
     seqmsg(element,"error loading json file.");
    }

    var oReq = new XMLHttpRequest();
    
    oReq.addEventListener("load", reqListener, false);
    oReq.addEventListener("error", transferFailed, false);
    
    oReq.open("get", src, true);
    oReq.send();
    
  }
  else
  {
    element.innerText = "Sequence table: no json file specified. Will not render table.";
  }
}

// https://code.tutsplus.com/tutorials/extending-the-html-by-creating-custom-tags--cms-28622

//find all the tags occurrences (instances) in the document
function customTag(tagName,fn){
  
  var tagInstances = document.getElementsByTagName(tagName);
        //for each occurrence run the associated function
        for ( var i = 0; i < tagInstances.length; i++) {
            fn(tagInstances[i]);
        }
}


// scans html page for "seqtable" tags and calls `seqtableMake` method on them
document.addEventListener("DOMContentLoaded", function(){
    customTag("seqtable",seqtableMake);
});
 
