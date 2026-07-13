//
//  Word.swift
//  Wordik
//
//  Created by Yaraslau Merynau on 13.07.2026.
//

import Foundation

struct Word: Equatable {
    enum Kind: Equatable {
        case masterWord(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    var kind: Kind
    var letters: [Letter]
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
    init(kind: Kind, letters: [Letter]) {
        self.kind = kind
        self.letters = letters
    }
    
    mutating func reset() {
        letters = Array(repeating: Letter.missing, count: letters.count)
    }
    
    func match(against otherWord: Word) -> [Match] {
        var result: [Match] = Array(repeating: .nomatch, count: letters.count)
        var lettersToMatch = otherWord.letters
        
        for index in lettersToMatch.indices.reversed() {
            if index < lettersToMatch.count, letters[index] == lettersToMatch[index] {
                result[index] = .exact
                lettersToMatch.remove(at: index)
            }
        }
        
        for index in lettersToMatch.indices {
            if result[index] != .exact {
                if let matchIndex = lettersToMatch.firstIndex(of: letters[index]) {
                    result[index] = .inexact
                    lettersToMatch.remove(at: matchIndex)
                }
            }
        }
        
        return result
    }
}
