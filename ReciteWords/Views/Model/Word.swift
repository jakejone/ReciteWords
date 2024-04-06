//
//  Word.swift
//  Words
//
//  Created by jake on 2024/3/4.
//

import Foundation

enum WordMemory {
    case Gotcha
    case RingABell
    case NoIdea
}

class Word :Identifiable,ObservableObject{
    
    public let id:UUID
    
    public let date:Date
    
    @Published public var content:String?
    
    @Published public var voiceAddr:String?
    
    public var score = 0
    
    @Published public var wordSentenceList:Array<WordSentence>
    
    init(id: UUID = UUID(), date: Date = Date(), content: String, voiceAddr: String, wordSentenceList: Array<WordSentence>) {
        self.id = id
        self.date = date
        self.content = content
        self.voiceAddr = voiceAddr
        self.wordSentenceList = wordSentenceList
    }
    
    init(id: UUID = UUID(), date: Date = Date(), content: String, voiceAddr: String, score:Int) {
        self.id = id
        self.date = date
        self.content = content
        self.voiceAddr = voiceAddr
        self.score = score
        self.wordSentenceList = Array()
    }
    
    init(id: UUID = UUID(), date: Date = Date()) {
        self.id = id
        self.date = date
        self.wordSentenceList = Array()
    }
    
    func getAllVoiceList()  -> Array<String> {
        var voiceList = Array<String>()
        if let voice = voiceAddr {
            voiceList.append(voice)
        }
        
        for wordSentence in self.wordSentenceList {
            voiceList.append(wordSentence.wordDescVoiceAddr!)
            
            for sentence in wordSentence.sentencelist {
                voiceList.append(sentence.voiceAddr!)
            }
        }
        return voiceList
    }
    
    func markWordMemory(memory:WordMemory) {
        switch memory {
        case .Gotcha:
            self.score += 6
        case .RingABell:
            self.score += 3
        case .NoIdea:
            self.score += 1
        }
    }
}
