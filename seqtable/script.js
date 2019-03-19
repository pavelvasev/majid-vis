var jjj = [
 [0,"Majid","ATGACATGACAGTCACCACACTGAGAGAGAGA"],
 [10,"Name 2","ATGACATGACAGTCACCACACTGAGAGAGAGA"],
 [9,"Name 3","ATGACATGACAGTCACCACACTGAGAGAGAGA"]
];

// https://code.tutsplus.com/tutorials/extending-the-html-by-creating-custom-tags--cms-28622

function customTag(tagName,fn){
  //document.createElement(tagName);
  //find all the tags occurrences (instances) in the document
  var tagInstances = document.getElementsByTagName(tagName);
        //for each occurrence run the associated function
        for ( var i = 0; i < tagInstances.length; i++) {
            fn(tagInstances[i]);
        }
}
 
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
  return s;

/*
        //code for rendering the element goes here
        if (element.attributes.email){
            //get the email address from the element's email attribute
            var email = element.attributes.email.value;
            var gravatar = "http://www.gravatar.com/avatar/"+md5(email)+".png";
            element.innerHTML = "<img src='"+gravatar+"'>";
        }
*/
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


document.addEventListener("DOMContentLoaded", function(){
    customTag("seqtable",seqtableMake);
});
 
