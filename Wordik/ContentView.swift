//
//  ContentView.swift
//  Wordik
//
//  Created by Yaraslau Merynau on 12.07.2026.
//

import SwiftUI

struct WordikView: View {
    // MARK: Constants
    struct GuessButton {
        static let maxFontSize: CGFloat = 80
        static let minFontSize: CGFloat = 8
        static let minimumScaleFactor = minFontSize / maxFontSize
    }
    
    struct RestartButton {
        static let fontSize: CGFloat = 35
    }
    
    // MARK: Data Owned by Me
    @State private var game = Wordik(wordLength: 5)
    @State private var selection = 0
    // MARK: Data In
    @Environment(\.words) var words
    
    // MARK: - Body
    var body: some View {
        VStack {
            WordView(word: game.masterWord)
            ScrollView {
                WordView(word: game.guess, selection: $selection) {
                    guessButton
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    WordView(word: game.attempts[index])
                }
            }
            LetterChooser(choices: game.letterChoices) { letter in
                game.changeGuessLetter(letter, at: selection)
                selection = (selection + 1) % game.wordLength
            }
            restartButton
        }
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            game.attemptGuess()
        }
        .font(.system(size: GuessButton.maxFontSize))
        .minimumScaleFactor(GuessButton.minimumScaleFactor)
    }
    
    var restartButton: some View {
        Button("Restart") {
            print("Restart")
        }
        .font(.system(size: RestartButton.fontSize))
    }
}

#Preview {
    WordikView()
}
