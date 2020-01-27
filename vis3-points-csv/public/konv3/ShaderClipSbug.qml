// copied from /home/contact/prg/dvidium-2020/23-objects-and-morfizms-b9/t-viewlang-mike2/6-resources/konv3/ShaderClipS.qml on 2020-01-04 16:53:43 +0500
Shader {
  id: shader1
  
  property var os: "x"
  property var titl: "X"
  
  // scopeName задается чтобы эта штука засадила таки параметры в нормальное место
  property var scopeName: "shader_clip_"+os
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
  
  property var pcoef: 10000
  property alias p1: pp1
  property alias p2: pp2
  property alias p3: pp3  
  
  property var tag: "right"
  
  GroupBox {
  
    title: "Серия "+titl
    property var tag: "right"
    
    Column {
    
  Param {
    id: pp1
    min: 0
    max: pcoef
    step: 10
    value: pcoef
    text: "Длина"
    enableSliding: true
    property var enableScopeDuplicated: true

  }
  
  
  Param {
    id: pp2
    min: 0
    max: 1
    step: 0.0001
    value: 1
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
          varying float qpositionOZ;
          
          void main()
          {
            qpositionOZ = mod( position.OZ, p1 ) / p1;
          }
           "
  vertex: vertex_t.replace(/OZ/g,os);           
                        
  fragmentOver: true // режим смешения с базовым цветом

  property var fragmenttempl: "
      uniform float sceneTime;
      varying float  qpositionOZ;
          uniform float p1;
          uniform float p2;      
                  void main()
                        {
                          if (qpositionOZ > p2) discard;
            }
           "
  fragment: fragmenttempl.replace(/OZ/g,os);
                        
}
