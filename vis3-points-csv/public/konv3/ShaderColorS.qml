Shader {
  id: shader1
  
  property var os: "x"
  property var titl: "X"
  
  // scopeName задается чтобы эта штука засадила таки параметры в нормальное место
  property var scopeName: "shader_color_serie_"+os
  // заприщаем дубликаты потому что иначе происходит скачок при смене списка шейдеров
  property var enableScopeDuplicated: true
  
  property var input_0: cliprange // опирается получается на кого-то сверху, ибо у нас биндинги недоделанные в Loader
  
  // работаем только на рост.. иначе получается что если диапазон уменьшается, то слайдеры съезжают на уменьшение, что неприемлемо
  onInput_0Changed: {
    //console.log("inpuit_0 changed to",input_0);
    if (pcoef < input_0) {
      pcoef = input_0;
    }
  }
  
  property var output: shader1
  
  property var pcoef: 10
  property alias p1: pp1
  property alias p2: pp2
  property alias p3: pp3
  
  property var tag: "right"
  
  GroupBox {
  
    title: "Подкраска сечений "+titl
    property var tag: "right"
    
    Column {
    
  Param {
    id: pp1
    min: 0
    max: pcoef
    step: 10
    value: pcoef/10
    text: "Шаг"
    enableSliding: true
    property var enableScopeDuplicated: true

  }
  
  
  Param {
    id: pp2
    min: 0
    max: 1
    step: 0.0001
    value: 0.5
    text: "Доля"
    enableSliding: true    
    property var enableScopeDuplicated: true
  }
  
    } // col
  
  } //grp

//      property real time: scen.sceneTime
//      property real custom1: pCustom1.value


  property var vertex_t: "
          // your things
          uniform float sceneTime;
          uniform float p1;
          uniform float p2;
          varying float q3positionOZ;
          
          void main()
          {
            q3positionOZ = position.OZ;
          }
           "
  vertex: vertex_t.replace(/OZ/g,os);           
                        
  fragmentOver: true // режим смешения с базовым цветом

  property var fragmenttempl: "
      uniform float sceneTime;
      varying float q3positionOZ;
      uniform float p1;
      uniform float p2;      
      void main()
      {
        if (mod( q3positionOZ,p1) / p1 < p2) gl_FragColor.r=1.0;
      }
     "
  fragment: fragmenttempl.replace(/OZ/g,os);
                        
}
