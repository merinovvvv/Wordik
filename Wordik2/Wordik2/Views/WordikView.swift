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
        static let fontSize: CGFloat = 35
    }
    
    struct HintButton {
        static let maxFontSize: CGFloat = 80
        static let minFontSize: CGFloat = 8
        static let minimumScaleFactor: CGFloat = minFontSize / maxFontSize
    }
    
    struct RestartButton {
        static let fontSize: CGFloat = 35
    }
    
    // MARK: Data Owned by Me
    @State private var game = Wordik(wordLength: [3, 4, 5, 6].randomElement() ?? 4)
    @State private var selection = 0
    // MARK: Data In
    @Environment(\.words) var words
    
    // MARK: - Body
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.mint, .orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack {
                restartButton
                WordView(word: game.masterWord)
                ScrollView {
                    WordView(word: game.guess, selection: $selection) {
                        hintButton
                    }
                    ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        WordView(word: game.attempts[index])
                    }
                }
                .scrollIndicators(.hidden)
                LetterChooser(choices: game.letterChoices) { letter in
                    game.changeGuessLetter(letter, at: selection)
                    selection = (selection + 1) % game.wordLength
                }
                guessButton
            }
            .padding()
        }
    }
    
    var guessButton: some View {
        Button("Guess") {
            game.attemptGuess()
        }
        .font(.system(size: GuessButton.fontSize))
        .foregroundStyle(.green)
        .disabled(!game.isActive)
    }
    
    var hintButton: some View {
        Button("Hint") {
            game.useHint()
        }
        .font(.system(size: HintButton.maxFontSize))
        .minimumScaleFactor(HintButton.minimumScaleFactor)
        .foregroundStyle(.white)
    }
    
    var restartButton: some View {
        Button("Restart") {
            game.restart()
        }
        .font(.system(size: RestartButton.fontSize))
        .foregroundStyle(.red)
    }
}

#Preview {
    WordikView()
}
