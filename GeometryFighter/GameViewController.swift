
import UIKit
import SceneKit

class GameViewController: UIViewController {
  
  var scnView: SCNView!
  var scnScene: SCNScene!
  var cameraNode: SCNNode!
  var spawnTime:TimeInterval = 0
  var generation = 0
  var worldLine : Array<Bool>
  let worldWidth = 300
    
    required init(coder:NSCoder){
        self.worldLine=Array()
        
       
        for i in 0...self.worldWidth - 1 {
            
            //if i == self.worldWidth - 1{
//            if i == Int(Float(self.worldWidth) / 2.0){
//                self.worldLine.append(true)
//            }else{
//                self.worldLine.append(false)
//            }
            self.worldLine.append(arc4random_uniform(2) == 0)
            
        }
        super.init(coder:coder)!
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupScene()
    setupCamera()
  }
  
  override var shouldAutorotate : Bool {
    return true
  }
  
  override var prefersStatusBarHidden : Bool {
    return true
  }
  
  func setupView() {
    scnView = self.view as! SCNView
    
    scnView.showsStatistics = true
    scnView.allowsCameraControl = true
    scnView.autoenablesDefaultLighting = true

    scnView.delegate = self
    scnView.isPlaying = true
  }
  
  func setupScene() {
    scnScene = SCNScene()
    scnView.scene = scnScene
  }
  
  func setupCamera() {
    cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.camera?.zFar = 1000
    cameraNode.position = SCNVector3(x: Float(self.worldWidth) / 2.0 , y: Float(self.worldWidth * 1) , z: Float(self.worldWidth * 2))
    scnScene.rootNode.addChildNode(cameraNode)
  }
  
  func tick() {
 
    
    var trueGeometry:SCNGeometry
    trueGeometry = SCNSphere(radius: 0.5)
    trueGeometry.materials.first?.diffuse.contents = UIColor.green
    
//    var falseGeometry:SCNGeometry
//    falseGeometry = SCNSphere(radius: 0.5)
//    falseGeometry.materials.first?.diffuse.contents = UIColor.white
    
    var index = 0
    for state in self.worldLine {
        
        if state {
            let geometryNode = SCNNode(geometry: trueGeometry)
            geometryNode.position = SCNVector3(x: Float(index), y: Float(self.generation * -1), z: 0)
            scnScene.rootNode.addChildNode(geometryNode)
        }
        index = index + 1
    }
    self.cameraNode.position.y = self.cameraNode.position.y - 1
//    self.cameraNode.position.z = self.cameraNode.position.z + 3
//    self.cameraNode.camera?.zFar = (self.cameraNode.camera?.zFar)! + 3
    self.generation = self.generation + 1
    
    
    
    var newLine: Array<Bool> = Array()
    newLine.append(self.worldLine[0])
    
    
    for i in 1...self.worldWidth - 2 {
        if self.worldLine[i-1] && self.worldLine[i] && self.worldLine[i+1]{
            newLine.append(false)
        } else if self.worldLine[i-1] && self.worldLine[i] && !self.worldLine[i+1]{
            newLine.append(true)
        }else if self.worldLine[i-1] && !self.worldLine[i] && self.worldLine[i+1]{
            newLine.append(false)
        }else if self.worldLine[i-1] && !self.worldLine[i] && !self.worldLine[i+1]{
            newLine.append(true)
        }else if !self.worldLine[i-1] && self.worldLine[i] && self.worldLine[i+1]{
            newLine.append(true)
        }else if !self.worldLine[i-1] && self.worldLine[i] && !self.worldLine[i+1]{
            newLine.append(false)
        }else if !self.worldLine[i-1] && !self.worldLine[i] && self.worldLine[i+1]{
            newLine.append(true)
        }else if !self.worldLine[i-1] && !self.worldLine[i] && !self.worldLine[i+1]{
            newLine.append(false)
        }
    }
    newLine.append(self.worldLine[self.worldWidth-1])
    
    self.worldLine = newLine
  }
}

// 1
extension GameViewController: SCNSceneRendererDelegate {
  // 2
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time:
  TimeInterval) {
    // 1
    if time > spawnTime {
      tick()
      // 2
      spawnTime = time + 0.001
    }
    ()
  }

}
