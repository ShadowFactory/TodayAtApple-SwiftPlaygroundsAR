//#-hidden-code
//
//  Contents.swift
//
//  Made by: Keiran Lovett
//  Shadow Factory
//
//#-end-hidden-code
/*:
# 3. Understanding the Environment 🌏
 
 * callout(Task):
 Goal: Understanding our Environment with Planes
 
 In this step we’ll just look at how the iPad’s camera finds flat surfaces, which we call [planes](glossary://plane).
 
 Run the code and move your iPad around. See how as you move your camera around a blue square appears. This means the camera has found a plane that we can place objects on.
 
 * callout(Tip):
 The camera sometimes has trouble spotting planes in a room with shiny, reflective surfaces or low lighting. If you’re having trouble seeing planes, try pointing the iPad in a different direction.
 
 When you've successfully got a blue plane, you can go to the **[next page](@next)**.
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

    

func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
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
}

//#-hidden-code
//
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
