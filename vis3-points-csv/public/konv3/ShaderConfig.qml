GroupBox {
  id: sc
  
  property var cliprange: 5000
  property var timevalue: 0
  
  //onTimevalueChanged: console.log("shaderconfig tv changed",timevalue );
  
  property var tag: "right"
  title: "Фильтры"
  
  
//  Embed {
//    html: "<style> fieldset legend { color: #fff; } /*checkbox:*/ .ShaderConfig { color: #ddd; } /*params text*/  .ShaderConfig .Text span { color: #777 !important; }</style>"
//  }
  

  property var ztitle: "Z"
  
  property var types: [ 
    ["Отсечение "+ztitle,"ShaderClip?z", { os: "z", titl: ztitle }],
    ["Отсечение X","ShaderClip?x", { os: "x", titl: "X" }],
    ["Отсечение Y","ShaderClip?y", { os: "y", titl: "Y" }],
    ["Масштабы<br/><br/>","ShaderScale"],
    ["Серия "+ztitle,"ShaderClipS?z", { os: "z", titl: ztitle }],
    ["Серия X","ShaderClipS?x", { os: "x", titl: "X" }],
    ["Серия Y","ShaderClipS?y", { os: "y", titl: "Y" }],
    ["Подкраска сечений "+ztitle,"ShaderColorS?z", { os: "z", titl: ztitle }],
    ["Подкраска сечений X","ShaderColorS?x", { os: "x", titl: "X" }],
    ["Подкраска сечений Y<br/><br/>","ShaderColorS?y", { os: "y", titl: "Y" }],    
    ["Убрать черный","ShaderBlack", { }],
    ["Накоплять фон","FeatureKeepBkg", { }],
    ["Автомасштаб","AutoScale", { }],
    ["Камера: взгляд","CameraLook", { }],
    ["Камера: поворот","CameraRotate", { }],
    ["Пользовательский","ShaderUser", { titl: "1" }]
  ]

  SimpleDialog {
    id: adddlg
    
    title: "Добавить"
    
    height: coco.height+40
    
    Row {
    Column {
      
      Text {
        text: "Всего знаю разных видов: "+types.length
      }
      id: coco
      Repeater {
        model: types.length
        
        CheckBoxParam {
          text: types[index][0]
          //guid: types[index][1]
          guid: "selectshader_"+index
          property var typeIndex: index
          tag: undefined
          //onClicked: addshader( types[index][1] )
          onValueChanged: rescan()
        }
      }
    }
    }
  }
  
  function rescan() {
    var acc = [];
    acc.length = types.length;
    for (var i=0; i<coco.children.length; i++)
       if (coco.children[i].guid && coco.children[i].value > 0) acc[ coco.children[i].typeIndex ] = 1;
    selectedshadermask = acc;
    console.log("rescan",acc);
    return acc;
  }
  
  // маска 1-0 по колву типов
  property var selectedshadermask: []  
  
  /*
   история такова что если делать список, то репитер потом совместно с loader-ом дурят
   и при смене списка начинают кого-то создавать, кого-то удалять, и бывает дублируются даже
   один и тот же шейдер, а от этого котовасия с гуидами параметров (но было обойдено через scopeName и enableDuplicated)
   но последней каплей оказалось что onConstruction/destruction я использовал для активации фичи,
   и при смене списка он сначала вызывал очередной constr а затем у старого destr
   ну и короче поэтому теперь все на масках и лоадеры все готовы загружать
  function rescan() {
    var acc = [];
    for (var i=0; i<coco.children.length; i++)
       if (coco.children[i].guid && coco.children[i].value > 0) acc.push( coco.children[i].typeIndex );
    selectedshaderlist = acc;
    console.log("rescan",acc);
    return acc;
  }  
 
  // набор номеров из types
  property var selectedshaderlist: []
  */


  
  //////////////////////// part 2
  
  Column {
    id: shadershere
    
     Button {
      text: "Настроить"
      onClicked: adddlg.open()
     }
    
  Repeater {
    id: rep1
    model: types.length
    //model: selectedshaderlist.length
    //onModelChanged: rescanitems(500);
    Loader {
      source: selectedshadermask[index] > 0 ? types[ index ][1] : undefined
      timeoutMode:false // иначе оно моргает - шейдеры старые (=сдвинувшиеся) удаляются репитером
      onItemChanged: {
        rescanitems(0)
        //scene.refineSelf();
        qmlEngine.rootObject.refineSelf()
      }
      onInit: {
        var opts = types[ index ][2] || {};
        for (k in opts) {
          //obj[k] = Qt.binding( function() { return opts[k]; } )
          obj[k] = opts[k];
        }
      }
    }
  }
  }
  
  function rescanitems(t) {
    //setTimeout( realrescanitems, t );
    realrescanitems(); // короче реальное моргание тут отрубается
  }
  
  function realrescanitems() {
    var acc = [];
    for (var i=0; i<shadershere.children.length; i++) 
      if (shadershere.children[i].item) acc.push(shadershere.children[i].item);
      
    console.log("realrescanitems: found shaders",acc);
    shaders=acc;
    return acc;
  }
  
  property var shaders: []
  
  // а вот это нам для двидиум надо
  property var output: shaders
}