//
//  SpeechRecognizer.swift
//  Words
//
//  Created by jake on 2024/3/8.
//

import Foundation
import AVFoundation
import Speech

class SpeechRecognitionManager {
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")) 
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()

    func startSpeechRecognition(completion: @escaping (_ transContent: String)->()) {
        
        guard let recognizer = speechRecognizer else {
            print("Speech recognition not available for the current locale.")
            return
        }
        
        if !recognizer.isAvailable {
            print("Speech recognition is not currently available.")
            return
        }

        do {
#if os(iOS)
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
#endif
            

            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            let inputNode = audioEngine.inputNode
            
            recognitionTask = recognizer.recognitionTask(with: recognitionRequest!) { result, error in
                var isFinal = false
                
                if let result = result {
                    // Process the speech recognition result
                    isFinal = result.isFinal
                    completion(result.bestTranscription.formattedString)
                    if let bestString = result.transcriptions.last?.formattedString {
                        completion(bestString.lowercased())
                    }
                }

                if error != nil || isFinal {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
                
                if error != nil {
                    print("recognize error : \(error!.localizedDescription)")
                }
             }

            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }

    func stopSpeechRecognition() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.finish()
    }
}
