//
//  ARViewController.swift
//  fitsmindARTest
//
//  Created by Andrew Simpson on 1/2/18.
//  Copyright © 2018 gravity LLC. All rights reserved.
//

import UIKit
import ARKit
import GoogleMaps

class ARViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet var conSwitch: UISwitch!
    var locationManager = CLLocationManager()
    var tapedLocation = CLLocationCoordinate2D()
    
    struct data {
        var x: Float
        var y: Float
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        sceneView.session.run(config)
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let newPos = geoToAR(coordinate: tapedLocation, currentCoordinate: (locationManager.location?.coordinate)!)
        addNodeAt(dataLoc: newPos)
        
    }
    
    func addNodeAt(dataLoc: data) {
        for node in sceneView.scene.rootNode.childNodes { node.removeFromParentNode() }
        let base = SCNBox(width: 1.1, height: 0.02, length: 1.1, chamferRadius: 0)
        let node = SCNNode(geometry: base)
        node.position = SCNVector3Make(dataLoc.x, -10, dataLoc.y)
        node.geometry?.materials[0].diffuse.contents = UIColor.clear
        let city = SCNScene(named: "cityTest5.dae")!
        let cityNode = city.rootNode.childNodes[0]
        cityNode.position = SCNVector3Make(-0.05, -1, 0.33)
        cityNode.scale = SCNVector3Make(1, 1, 1)
        cityNode.rotation = SCNVector4Make(1, 0, 0, -Float.pi / 2)
        node.addChildNode(cityNode)
        node.scale = SCNVector3Make(1, 1, 1)
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func updateNodePos(dataLoc: data) {
        sceneView.scene.rootNode.childNodes[0].position = SCNVector3Make(dataLoc.x, -1, -dataLoc.y)
    }
    
    func updateNodeScale(scale: Float) {
        sceneView.scene.rootNode.childNodes[0].scale = SCNVector3Make(scale, scale, scale)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = manager.location?.coordinate
        if ((manager.location?.horizontalAccuracy)! <= Double(10)) {}
        if (conSwitch.isOn) {
            let newPos = geoToAR(coordinate: tapedLocation, currentCoordinate: (location)!)
            updateNodePos(dataLoc: newPos)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func geoToAR(coordinate: CLLocationCoordinate2D, currentCoordinate: CLLocationCoordinate2D) -> data {
        
        let xDist = abs(coordinate.latitude - currentCoordinate.latitude)
        let yDist = abs(coordinate.longitude - currentCoordinate.longitude)
        let hDist = GMSGeometryDistance(coordinate, currentCoordinate)
        let angleR = atan(xDist / yDist)
        var yPos = hDist * sin(angleR)
        var xPos = hDist * cos(angleR)
        if (coordinate.latitude - currentCoordinate.latitude < 0) { yPos = yPos * -1}
        if (coordinate.longitude - currentCoordinate.longitude < 0) { xPos = xPos * -1}
        
        print("______________________")
        print(xPos)
        print(yPos)
        print("______________________")
        
        return data(x: Float(xPos), y: Float(yPos) )
    }
    
    @IBAction func sliderMove(_ sender: UISlider) {
        updateNodeScale(scale: sender.value)
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
