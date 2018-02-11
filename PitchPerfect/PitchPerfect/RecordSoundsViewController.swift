//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Thomas Muehlegger on 06.02.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: Disable the stop recording button when finished loading
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        
        recordButton.contentMode = .center
        recordButton.imageView?.contentMode = .scaleAspectFit
        stopRecordingButton.contentMode = .center
        stopRecordingButton.imageView?.contentMode = .scaleAspectFit
    }

    // MARK: Action to record some audio
    @IBAction func recordAudio(_ sender: Any) {
        setButtonsAndLabels(showRecording: false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: Action to stop recording the audio
    @IBAction func stopRecording(_ sender: Any) {
        setButtonsAndLabels(showRecording: true)
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    // MARK: - Set Buttons and Labels
    func setButtonsAndLabels(showRecording flag: Bool) {
        recordButton.isEnabled = flag
        stopRecordingButton.isEnabled = !flag
        recordingLabel.text = flag ? "Tap to record" : "Recording in progress"
    }
    
    // MARK: Audio recorder delegate when recording finished
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording the audio was not successful")
        }
    }
    
    // MARK: Prepare the UI
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

