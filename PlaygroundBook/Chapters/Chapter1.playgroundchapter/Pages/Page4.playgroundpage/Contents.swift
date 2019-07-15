//#-hidden-code
//
//  Contents.swift
//
//  Made by: Keiran Lovett
//  Shadow Factory
//
//#-end-hidden-code
/*:
# 4. Adding Your Drawing 🖼
 
 * callout(Task):
 Goal: Combining it all together.
 
 Now you have an understanding of how ARKit works, it's time to use this understanding to place your drawing in the scene!
 
 We've set up the code below with everything you have learnt from the previous pages and added two new functions **(E)** `addNodeToSceneViewPlane()` and **(F)** `addTapGestureToSceneView()`.
 
 These two new functions help us stick our postcard to the planes it detects.
 
 * callout(Tip):
 Imagine when you tap the iPad a line is drawn from your finger through to the real world! Where ever that line ends, if its on a plane we place our drawing!
 
 * callout(Task):
 ✏️ You will need to add your **drawing** to your **postcard** by writing a simple line of code in **(E)** `addToSceneViewPlane()`.
 
 - - -
 **Try add your **drawing** like this:**
 
* callout(Tip):
 
`let postcard = create2DPlane(width: 0.5, height: 0.3, image: 🖼)`
 
 *A width of `0.5` to a height of `0.3` gives us a similar aspect ratio to television!*
 
 Add your ProCreate **drawing** to the **postcard** by inserting images from iPad.
 
 ![Exporting from ProCreate](insertImage_tutorial.mov)

 
 When you've successfully got a **postcard**, lets **record a message!**.
 */

//#-hidden-code
import PlaygroundSupport
import SceneKit
import ARKit
import UIKit

class MainViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

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
    addTapGestureToSceneView()

}
    
// B) Configure our AR capabilities
func setUpSceneView() {
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .horizontal
    
    sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    
    self.view = sceneView
    //#-editable-code
    sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    //#-end-editable-code
}

// C) Configure our scene lighting variables
func configureLighting() {
    sceneView.autoenablesDefaultLighting = true
    sceneView.automaticallyUpdatesLighting = true
}

// D) Create a flat plane that will rotate with the camera.
func create2DPlane(width: CGFloat = 0.1, height: CGFloat = 0.1, image: UIImage) -> SCNNode {
    let plane = SCNPlane(width: width, height: height)
    plane.firstMaterial!.diffuse.contents = image
    let planeNode = SCNNode(geometry: plane)
    planeNode.constraints = [SCNBillboardConstraint()]
    
    return planeNode
}

// E)
@objc func addToSceneViewPlane(withGestureRecognizer recognizer: UIGestureRecognizer) {
    // 1
    let tapLocation = recognizer.location(in: sceneView)
    let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
    
    // 2
    guard let hitTestResult = hitTestResults.first else { return }
    let translation = hitTestResult.worldTransform.translation
    let x = translation.x
    let y = translation.y
    let z = translation.z
    
    // 3
    //#-editable-code
    // create2DPlane(width: 0.5, height: 0.3, image: 🖼)
    let postcard = 
    postcard.position = SCNVector3(x, y, z)
    //#-end-editable-code

    // 4
    sceneView.scene.rootNode.addChildNode(postcard)
}

// F
func addTapGestureToSceneView() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainViewController.addToSceneViewPlane(withGestureRecognizer:)))
    
    sceneView.addGestureRecognizer(tapGestureRecognizer)
}

    
//#-hidden-code
//
/*func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    // 1
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    
    // 2
    let width = CGFloat(planeAnchor.extent.x)
    let height = CGFloat(planeAnchor.extent.z)
    let plane = SCNPlane(width: width, height: height)
    
    // 3
    plane.materials.first?.diffuse.contents = UIColor.transparentLightBlue
    
    // 4
    let planeNode = SCNNode(geometry: plane)
    
    // 5
    let x = CGFloat(planeAnchor.center.x)
    let y = CGFloat(planeAnchor.center.y)
    let z = CGFloat(planeAnchor.center.z)
    planeNode.position = SCNVector3(x,y,z)
    planeNode.eulerAngles.x = -.pi / 2
    
    // 6
    node.addChildNode(planeNode)
}

func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    // 1
    guard let planeAnchor = anchor as?  ARPlaneAnchor,
        let planeNode = node.childNodes.first,
        let plane = planeNode.geometry as? SCNPlane
        else { return }
    
    // 2
    let width = CGFloat(planeAnchor.extent.x)
    let height = CGFloat(planeAnchor.extent.z)
    plane.width = width
    plane.height = height
    
    // 3
    let x = CGFloat(planeAnchor.center.x)
    let y = CGFloat(planeAnchor.center.y)
    let z = CGFloat(planeAnchor.center.z)
    planeNode.position = SCNVector3(x, y, z)
}*/

    
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

extension UIColor {
    open class var transparentLightBlue: UIColor {
        return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
    }
}


// MARK: - Playgrounds setup
let viewController = MainViewController()

PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true
//
//#-end-hidden-code
