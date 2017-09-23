//
//  ViewController.swift
//  Watson Speaks
//
//  Created by Orlando Gordillo on 9/23/17.
//  Copyright © 2017 HackRice2017. All rights reserved.
//

import UIKit
import Photos
import TextToSpeechV1
import AVFoundation
import MediaPlayer

import VisualRecognitionV3


class ViewController: UIViewController {
    
    
    @IBOutlet fileprivate var captureButton: UIButton!
    @IBOutlet fileprivate var capturePreviewView: UIView!
    
    ///Allows the user to put the camera in photo mode.
    @IBOutlet fileprivate var photoModeButton: UIButton!
    @IBOutlet fileprivate var toggleCameraButton: UIButton!
    @IBOutlet fileprivate var toggleFlashButton: UIButton!
    
    ///Allows the user to put the camera in video mode.
    @IBOutlet fileprivate var videoModeButton: UIButton!
    
    let cameraController = CameraController()
    
    override var prefersStatusBarHidden: Bool { return true }
    
    
    var audioPlayer: AVAudioPlayer!
    
    //let session = AVAudioSession.sharedInstance()

    func volumeChanged(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
                if volumeChangeType == "ExplicitVolumeChange" {
                    
                    cameraController.captureImage {(image, error) in
                        guard let image = image else {
                            print(error ?? "Image capture error")
                            return
                        }
                        
                    }
                    
                    
                }
            }
        }
    }
   
}



extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let volumeView = MPVolumeView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(volumeView)
        //      volumeView.backgroundColor = UIColor.red
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(notification:)),
                                               name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
                                               object: nil)

        let username = "372e741c-01af-4589-96d6-8eee21b13bfc"
        let password = "4OQ6HfuLLdSw"
        let textToSpeech = TextToSpeech(username: username, password: password)
        
        let text = "Howdy"
        let failure = { (error: Error) in print(error) }
        textToSpeech.synthesize(text, failure: failure) { data in
            self.audioPlayer = try! AVAudioPlayer(data: data)
            self.audioPlayer.play()
        }
        // Do any additional setup after loading the view, typically from a nib.
        
    
        func configureCameraController() {
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.capturePreviewView)
            }
        }
        
        func styleCaptureButton() {
            captureButton.layer.borderColor = UIColor.black.cgColor
            captureButton.layer.borderWidth = 2
            
            captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
        }
        
        
        
        styleCaptureButton()
        configureCameraController()
        
        try? AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension ViewController {
    @IBAction func toggleFlash(_ sender: UIButton) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        }
            
        else {
            cameraController.flashMode = .on
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        }
    }
    
    @IBAction func switchCameras(_ sender: UIButton) {
        do {
            try cameraController.switchCameras()
        }
            
        catch {
            print(error)
        }
        
        switch cameraController.currentCameraPosition {
        case .some(.front):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
            
        case .some(.rear):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
            
        case .none:
            return
        }
    }
    
    @IBAction func captureImage(_ sender: UIButton) {
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
         
            let apiKey = "3c1f946df3534dfa14524a54ddf4d067d1cfd4e4"
            let version = "2017-09-23" // use today's date for the most recent version
            let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
            
            let url = "https://static.pexels.com/photos/126407/pexels-photo-126407.jpeg"
            let failure = { (error: Error) in print(error) }
            visualRecognition.classify(image: url, failure: failure) { classifiedImages in
                print(classifiedImages)
                
            }
            
            //print("First value: " + classifiedImages)
            

        }
        
    }
    
    
    
}



