//
//  Wordik.swift
//  Wordik
//
//  Created by Yaraslau Merynau on 13.07.2026.
//

import Foundation

struct Wordik {
    // MARK: Data In
    var wordLength: Int
    var masterWord: Word
    var guess: Word
    var attempts: [Word] = []
    
    var letterChoices: [Letter] = Array("QWERTYUIOPASDFGHJKLZXCVBNM")
    
    init(wordLength: Int, words: Words = .shared) {
        self.wordLength = wordLength
        let randomWord = words.random(length: wordLength) ?? "AWAIT"
        masterWord = Word(kind: .masterWord(isHidden: true), letters: Array(randomWord))
        guess = Word(kind: .guess, letters: Array(repeating: Character(" "), count: wordLength))
    }
    
    mutating func attemptGuess(_ words: Words = .shared) {
        guard words.contains(String(guess.letters)) else { return }
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterWord))
        attempts.append(attempt)
        guess.reset()
    }
    
    mutating func changeGuessLetter(_ letter: Letter, at index: Int) {
        guard index < wordLength else { return }
        guess.letters[index] = letter
    }
}
