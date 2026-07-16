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
    
    var isActive: Bool {
        !attempts.contains(guess) &&
        guess.letters.allSatisfy({$0 != Letter.missing}) &&
        Words.shared.contains(String(guess.letters))
    }
    
    var isOver: Bool {
        attempts.last?.letters == masterWord.letters
    }
    
    init(wordLength: Int, words: Words = .shared) {
        self.wordLength = wordLength
        let randomWord = words.random(length: wordLength) ?? "AWAIT"
        masterWord = Word(kind: .masterWord(isHidden: true), letters: Array(randomWord))
        guess = Word(kind: .guess, letters: Array(repeating: Letter.missing, count: wordLength))
    }
    
    mutating func attemptGuess(_ words: Words = .shared) {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterWord))
        attempts.append(attempt)
        guess.reset()
        if isOver {
            masterWord.kind = .masterWord(isHidden: false)
        }
    }
    
    mutating func useHint() -> Int? {
        let wrongIndices = guess.letters.indices.filter { guess.letters[$0] != masterWord.letters[$0] }
        guard let randomIndex = wrongIndices.randomElement() else { return nil }
        guess.letters[randomIndex] = masterWord.letters[randomIndex]
        return randomIndex
    }
    
    mutating func changeGuessLetter(_ letter: Letter, at index: Int) {
        guard index < wordLength else { return }
        guess.letters[index] = letter
    }
    
    mutating func restart() {
        let newWordLength = [3, 4, 5, 6].randomElement() ?? 4
        self = Wordik(wordLength: newWordLength)
    }
}
