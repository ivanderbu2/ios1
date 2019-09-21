//
//  PlaybackViewController.swift
//  Pitch Perfect
//
//  Created by Ivan Radunovic on 19/09/2019.
//  Copyright © 2019 Codingo. All rights reserved.
//

import UIKit
import AVFoundation

class PlaybackViewController: UIViewController {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    
    var audioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    var clickedButton: UIButton!
    
    enum EffectType: Int { case snail = 1, rabbit, chipmunk, vader, echo, reverb }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAudio()
        stopButton.isEnabled = false
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func applyEffect(_ sender: UIButton) {
        let effectType = EffectType(rawValue: sender.tag)!
        clickedButton = sender;
        
        switch (effectType) {
        case .snail:
            play(rate: 0.5)
        case .rabbit:
            play(rate: 1.5)
        case .chipmunk:
            play(pitch: 1000)
        case .vader:
            play(pitch: -1000)
        case .reverb:
            play(reverb: true)
        case .echo:
            play(echo: true)
        }
    }
    
    @IBAction func stopPlayback(_ sender: UIButton) {
        stopAudio()
    }
}
