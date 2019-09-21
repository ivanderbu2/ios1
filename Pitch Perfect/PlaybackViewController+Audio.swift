//
//  PlaybackViewController+Audio.swift
//  Pitch Perfect
//
//  Created by Ivan Radunovic on 20/09/2019.
//  Copyright © 2019 Codingo. All rights reserved.
//

import UIKit
import AVFoundation

extension PlaybackViewController: AVAudioPlayerDelegate {
    
    func play(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        
        if let audioNode = audioNode {
            if audioNode.isPlaying {
                return
            }
        }
        
        stopButton.isEnabled = true
        clickedButton.isEnabled = false
        clickedButton.puls()
        
        audioEngine = AVAudioEngine()
        audioNode = AVAudioPlayerNode()
        audioEngine.attach(audioNode)
        
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        audioEngine.attach(changeRatePitchNode)
        
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho1)
        audioEngine.attach(echoNode)
        
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 80
        audioEngine.attach(reverbNode)
        
        if echo == true && reverb == true {
            connectNodes(audioNode, changeRatePitchNode, echoNode, reverbNode)
        } else if echo == true {
            connectNodes(audioNode, changeRatePitchNode, echoNode, audioEngine.outputNode)
        } else if reverb == true {
            connectNodes(audioNode, changeRatePitchNode, reverbNode, audioEngine.outputNode)
        } else {
            connectNodes(audioNode, changeRatePitchNode, audioEngine.outputNode)
        }
        
        audioNode.stop()
        audioNode.scheduleFile(audioFile, at: nil) {
            var delay: Double = 0
            
            if let lastTime = self.audioNode.lastRenderTime, let playerTime = self.audioNode.playerTime(forNodeTime: lastTime) {
                
                if let rate = rate {
                    delay = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delay = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            
            self.stopTimer = Timer(timeInterval: delay, target: self, selector: #selector(PlaybackViewController.stopAudio), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer!, forMode: RunLoop.Mode.default)
        }
        
        do {
            try audioEngine.start()
        } catch {
            showAlert("Error", message: String(describing: error))
        }
        
        audioNode.play()
    }
    
    @objc func stopAudio() {
        if let clickedButton = clickedButton {
            clickedButton.isEnabled = true
            clickedButton.stopPuls()
        }
        
        if let audioNode = audioNode {
            audioNode.stop()
        }
        
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
        
        if let stopButton = stopButton {
            stopButton.isEnabled = false
        }
    }
    
    func setupAudio() {
        do {
            let recordingSession = AVAudioSession()
             try recordingSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.spokenAudio)
            audioFile = try AVAudioFile(forReading: audioURL as URL)
        } catch {
            showAlert("Audio File Error", message: String(describing: error))
        }
    }
    
    func connectNodes(_ nodes: AVAudioNode...) {
        for i in 0..<nodes.count - 1 {
            audioEngine.connect(nodes[i], to: nodes[i+1], format: audioFile.processingFormat)
        }
    }
}
