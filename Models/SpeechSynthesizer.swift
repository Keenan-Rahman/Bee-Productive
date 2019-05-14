//
//  SpeechSynthesizer.swift
//  HCI Project
//
//  Created by Muhammad Shahzaib Vohra on 13/11/2017.
//  Copyright © 2017 Muhammad Shahzaib Vohra. All rights reserved.
//

import Foundation
import AVFoundation
class Speaking : NSObject,AVSpeechSynthesizerDelegate {
    
    let speechSynthesizerObject = AVSpeechSynthesizer()
    let voice = AVSpeechSynthesisVoice(language: "en-au")
    
    override init() {
        super.init()
        speechSynthesizerObject.delegate = self
    }
    
    func speak(string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.rate = 0.4
        utterance.voice = self.voice
        speechSynthesizerObject.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("all done")
        
    }
    
    
}

