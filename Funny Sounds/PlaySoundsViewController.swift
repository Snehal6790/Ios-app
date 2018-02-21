//
//  PlaySoundsViewController.swift
//  Funny Sounds
//
//  Created by snehal on 15/02/18.
//  Copyright © 2018 snehal.io. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class PlaySoundsViewController: UIViewController, CLLocationManagerDelegate {

    var receivedAudio : RecordedAudio!
    var audioPlayer : AVAudioPlayer!
    let locationManager = CLLocationManager()
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        if let filePath =  Bundle.main.path(forResource: "olp", ofType: "mp3") {
        
//            let filePathURL = URL.init(fileURLWithPath: filePath)
//              //NSURL.fileURL(withPath: filePath)
//
//        }else{
//
//            print("The file path for playslowAudio is not being found")
//        }
       // loginButton.layer.cornerRadius = loginButton.frame.height/2
       // loginButton.clipsToBounds = true
        
    
    do{
        audioPlayer = try AVAudioPlayer(contentsOf: receivedAudio.filePathURL as URL)
        audioEngine = AVAudioEngine()
        
        
        do {
            audioFile = try AVAudioFile(forReading: receivedAudio.filePathURL as URL)
            
        } catch {
            print("Unable to receive audio from recording")
        }
        audioPlayer.prepareToPlay()
    let audioSession = AVAudioSession.sharedInstance()
            do {
            //10 - Set our session category to playback music
                    try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            //11 -
                    } catch let sessionError {
                        print(sessionError)
                            }
                        }
                            catch{
                                print("FilPath is missing")
                            }
                                audioPlayer.enableRate = true
    }
    
    func initialise() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var stoppingaudiobutton: UILabel!
    
    
    @IBAction func snailAction(_ sender: Any) {
        print("playingsounds in slow mode")
     
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
          audioPlayer.rate = 0.5
        audioPlayer.play()
        stoppingaudiobutton.isHidden=true
    }
    
    @IBAction func rabbitAction(_ sender: Any) {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
         audioPlayer.rate = 1.5
        audioPlayer.play()
        stoppingaudiobutton.isHidden=true
    }
    
    @IBAction func chipmunks(_ sender: Any) {
        playAudioWithVariablePitch(pitch: 1000)
        stoppingaudiobutton.isHidden=true
        
    }
    
    func playAudioWithVariablePitch(pitch : Float)  {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        audioPlayerNode.play()
        
    }
    @IBAction func stopaudio(_ sender: Any) {
       
        audioPlayer.stop();
        stoppingaudiobutton.isHidden=false
        print("stopping recording audio ")
        
    }
}
