//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Majed Sh on 23/02/1440 AH.
//  Copyright © 1440 Majed Sh. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var RecordingButton: UIButton!
    @IBOutlet weak var StopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        StopRecordingButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear called")
    }
    
    func rocordingState( labelText : String, stopButtonStatus : Bool, recordingButtonStatus: Bool ){
        recordingLabel.text = labelText
        StopRecordingButton.isEnabled = stopButtonStatus
        RecordingButton.isEnabled = recordingButtonStatus
        
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        rocordingState(labelText: "Recording in Progress", stopButtonStatus: true, recordingButtonStatus: false)
   // recordingLabel.text = "Recording in Progress"
     //   StopRecordingButton.isEnabled = true
       // RecordingButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    @IBAction func stopRecording(_ sender: Any) {
        
        rocordingState(labelText: "Tap to Record", stopButtonStatus: false, recordingButtonStatus: true)
        
        //RecordingButton.isEnabled = true
        //StopRecordingButton.isEnabled = false
        //recordingLabel.text = "Tap to Record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording wasn't successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioUrl = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioUrl
        }
    }
    
}

