//#-hidden-code
//
//  Contents.swift
//  Made by: Keiran Lovett
//  Shadow Factory
//
//#-end-hidden-code
/*:
 # 2. Code Basics ✏️
 
 * callout(Task):
 Goal: Learn how to write code.
 
 
 To start, we're going to turn on the iPad camera, and create our **postcard** placeholder.
 
 Eventually, our goal is to for the iPad to see and learn the [scene](glossary://scene) around it, and decide on a [point](glossary://point) for you to place your **drawing**.
 
  * callout(Tip):
 If you get stuck don’t worry, just call out for some assistance and we’ll get you back on track.
 
 First, we'll turn on the camera with **(B)** `setUpSceneView()`, and create a floating postcard with **(E)** `create2DPlane()`. We've already written these [functions](glossary://function) to help you.
 
* callout(Task):
✏️ You will need to add your **postcard** by writing a simple line of code in **(D)** `configureScene()` next to **(B)** `setUpSceneView()`.
 
 - - -
 **Try add your **postcard** like this:**
 
  * callout(Tip):
 `let postcard = create2DPlane(width:0.2, height:0.1)`
 
 When you've successfully got a **postcard**, you can go to the **[next page](@next)**.
*/
//#-code-completion(everything, hide)
//#-hidden-code
//

import PlaygroundSupport
import SceneKit
import ARKit
import UIKit

class MainViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
//
//#-end-hidden-code

var sceneView: ARSCNView!
let session = ARSession()

// A) Initialization, scene setup and other logic
override func loadView() {
    super.loadView()
    
    // Setup SceneKit and ARKit
    sceneView = ARSCNView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
    
    sceneView.delegate = self
    sceneView.session = session
    sceneView.session.delegate = self
    
    let scene = SCNScene()
    sceneView.scene = scene
    
    //Use our functions here
    setUpSceneView()
    configureLighting()
    configureScene()
    
}

// B) Configure our AR capabilities
func setUpSceneView() {
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .horizontal
    
    sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    
    self.view = sceneView
    sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
}

// C) Configure our scene lighting variables
func configureLighting() {
    sceneView.autoenablesDefaultLighting = true
    sceneView.automaticallyUpdatesLighting = true
}
    
// D) Configure our scene with objects.
func configureScene() {
    //#-editable-code
    //Add your code here
    //let postcard = create2DPlane(width:0.2, height:0.1)
    let postcard =
    postcard.position = SCNVector3(0, 0, 0)
    //#-end-editable-code
    sceneView.scene.rootNode.addChildNode(postcard)
}

// E) Create a flat plane that will rotate with the camera.
func create2DPlane(width: CGFloat = 0.1, height: CGFloat = 0.1) -> SCNNode {
    let plane = SCNPlane(width: width, height: height)
    let planeNode = SCNNode(geometry: plane)
    planeNode.constraints = [SCNBillboardConstraint()]
    
    return planeNode
}


//#-hidden-code
//
    
}


// MARK: - Playgrounds setup
let viewController = MainViewController()

PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true

//
//#-end-hidden-code
