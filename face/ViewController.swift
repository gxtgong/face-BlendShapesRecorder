//
//  ViewController.swift
//  face
//
//  Created by GongXinting on 11/6/18.
//  Copyright © 2018 digital memory group. All rights reserved.
//
import ARKit
import UIKit
import SceneKit
import Foundation

class ViewController: UIViewController, ARSessionDelegate {
    @IBOutlet weak var label_time: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var btn_record: UIButton!
    @IBOutlet weak var btn_stop: UIButton!
    @IBOutlet weak var textField: UITextView!
    
    var captureData: [CaptureData]!
    var folderPath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btn_stop.isEnabled = false
        
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = false
        
    }
    
    // View actions and initialize tracking here
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        initTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCapture()
        session.pause()
    }
    
    //button functions
    @IBAction func recordTapped(_ sender: Any) {
        label_time.text = "Start the record"
        btn_record.isEnabled = false
        btn_stop.isEnabled = true
        startCapture()
    }
    @IBAction func stopTapped(_ sender: Any) {
        label_time.text = "Record stopped"
        btn_record.isEnabled = true
        btn_stop.isEnabled = false
        stopCapture()
    }
    
    func folderName() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMdd_HHmmss"
        let date = Date()
        let folderStr = dateFormatter.string(from: date)
        return folderStr
    }
    
    //AR session
    var session : ARSession {
        return sceneView.session
    }
    
    var isCapturing = false {
        didSet {
            btn_record.isEnabled = !isCapturing
            btn_stop.isEnabled = isCapturing
        }
    }
    
    func initTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = false
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func getFrameData() -> CaptureData? {
        let arFrame = session.currentFrame!
        guard let anchor = arFrame.anchors[0] as? ARFaceAnchor else {return nil}
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HHmmssSSSS"
        let dateString = formatter.string(from: now)
        let data = CaptureData(blendShapes: anchor.blendShapes, time: dateString)
        textField.text = data.str
        return data
    }
    
    func recordData(){
        guard let data = getFrameData() else {return}
        captureData.append(data)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        stopCapture()
        stopCapture()
        DispatchQueue.main.async {
            self.initTracking()
        }
    }
    func sessionWasInterrupted(_ session: ARSession) {
        return
    }
    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async {
            self.initTracking()
        }
    }
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if isCapturing {
            recordData()
        }
    }
    
    func startCapture() {
        //guard let data = getFrameData() else {return}
        //save/show data
        
        captureData = []
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        folderPath = documentPath.appendingPathComponent(folderName())
        try? FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
        isCapturing = true
        recordData()
    }
    
    func stopCapture() {
        isCapturing = false
        let fileName = folderPath.appendingPathComponent("faceData.json")
        let data = "{\n"+captureData.map{ $0.str }.joined(separator: ",\n")+"\n}\n"
        textField.text = "String length: "+String(data.count)
        print("String length: "+String(data.count))
        try? data.write(to: fileName, atomically: false, encoding: String.Encoding.utf8)
    }


}

