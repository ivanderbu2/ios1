//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Ivan Radunovic on 19/09/2019.
//  Copyright © 2019 Codingo. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {

    var isRecording: Bool = false
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var stop: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stop.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func recordAudio() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default)
            let filepath = getFilepath().appendingPathComponent("pitch.wav")
            try! audioRecorder = AVAudioRecorder(url: filepath, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            showAlert("Error while recording Audio", message: String(describing: error))
        }
    
        prepareRecordUI(label: "Tap to finish recording", recording: true)
    }
    
    @IBAction func stopRecording() {
        prepareRecordUI(label: "Tap to start recording", recording: false)
        audioRecorder.stop()
    }
    
    func prepareRecordUI(label: String, recording: Bool) {
        recordLabel.text = label
        isRecording = recording
        stop.isEnabled = recording // added this only to meet specifications from grading rubric
        stop.isHidden = !recording
        record.isEnabled = !recording // added this only to meet specifications from grading rubric
        record.isHidden = recording
        
        if recording {
            stop.puls()
        } else {
            stop.stopPuls()
        }
    }

    func getFilepath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            performSegue(withIdentifier: "playback", sender: audioRecorder.url)
        } else {
            showAlert("Recording was not successful", message: String(describing: "No file to playback"))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playback" {
            let playbackVC = segue.destination as! PlaybackViewController
            let audioURL = sender as! URL
            playbackVC.audioURL = audioURL
        }
    }
}

