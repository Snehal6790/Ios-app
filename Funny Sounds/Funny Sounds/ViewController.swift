//
//  ViewController.swift
//  Funny Sounds
//
//  Created by snehal on 14/02/18.
//  Copyright © 2018 snehal.io. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {


    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopbuttonicon: UIButton!
    @IBOutlet weak var stoppingbutton: UILabel!
    @IBOutlet weak var recordingInProgress: UILabel!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        stopbuttonicon.isHidden = true
    }
    
    
    @IBAction func recordAudio(_ sender: Any) {
        recordingInProgress.isHidden=false
        stoppingbutton.isHidden = true
        stopbuttonicon.isHidden = false
        print("recording in progress...")
        //Record the user's voice
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.string(from:currentDateTime as Date)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath as Any)
        
        //Setup audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch{
            print("The AVAudioSeeion canot be created")
        }
        
        //Intialise and play the recorder
        do {
            try audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        }catch{
            print("The filePath is not been found in the device memory")
        }
        
        audioRecorder.isMeteringEnabled = true;
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        audioRecorder.delegate = self
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            //Save the recorded Audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathURL = recorder.url as NSURL
            recordedAudio.title = recorder.url.lastPathComponent
            
            //Move to the next page ask perform segue
            self.performSegue(withIdentifier: "recordingbutton", sender: recordedAudio)
        }else{
            print("Recording was not successfull ")
            recordButton.isEnabled = true
            stopbuttonicon.isHidden = true
            
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="recordingbutton"){
            let playSoundsVC: PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            
          playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopbutton(_ sender: Any) {
        stoppingbutton.isHidden = false
        recordingInProgress.isHidden = true
        print("stopping recording audio ")
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance();
            do {
                try audioSession.setActive(false)
            } catch{
                print("The Audio Seeion is not been terminated session")
            }
    }
}

