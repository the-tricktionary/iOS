//
//  SpeachUtil.swift
//  Tricktionary
//
//  Created by Marek  Šťovíček on 23/01/2019.
//  Copyright © 2019 Marek Šťovíček. All rights reserved.
//

import Foundation
import AVFoundation

class SpeachUtil {
    
    var delegate: AVSpeechSynthesizerDelegate!
    
    func speek(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synth = AVSpeechSynthesizer()
        synth.delegate = delegate
        synth.speak(utterance)
    }
}
