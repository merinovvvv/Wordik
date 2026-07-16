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
        static let maxFontSize: CGFloat = 40
        static let minFontSize: CGFloat = 4
        static let minimumScaleFactor: CGFloat = minFontSize / maxFontSize
    }
    
    struct RestartButton {
        static let fontSize: CGFloat = 35
    }
    
    // MARK: Data Owned by Me
    @State private var game: Wordik?
    @State private var selection = 0
    @State private var guessing: Bool = false
    @State private var restarting: Bool = false
    @State private var finishing: Bool = false
    
    // MARK: Data In
    @Environment(\.words) var words
    
    // MARK: - Body
    var body: some View {
        Group {
            if let game {
                gameContent(for: game)
            } else {
                ProgressView("Loading words...")
                    .font(.title2)
            }
        }
        .task {
            await waitForWordsAndStartGame()
        }
    }
    
    // MARK: - Functions
    
    func waitForWordsAndStartGame() async {
        while words.count == 0 {
            try? await Task.sleep(for: .milliseconds(100))
        }
        
        withAnimation {
            game = Wordik(wordLength: [3, 4, 5, 6].randomElement() ?? 4)
        }
    }
    
    @ViewBuilder
    func gameContent(for game: Wordik) -> some View {
        ZStack {
            VStack {
                restartButton
                WordView(word: game.masterWord)
                    .transaction { transaction in
                        transaction.animation = .none
                    }
                ScrollView {
                    if !game.isOver || restarting {
                        WordView(word: game.guess, selection: $selection) {
                            hintButton
                        }
                        .opacity(guessing ? 0 : 1)
                        .opacity(restarting ? 0 : 1)
                        .animation(nil, value: game.attempts.count)
                    }
                    ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        WordView(word: game.attempts[index])
                            .transition(.attempts(game.isOver))
                    }
                }
                .scrollIndicators(.hidden)
                if !game.isOver {
                    Group {
                        LetterChooser(choices: game.letterChoices, onChoose: changeLetter)
                        guessButton
                    }
                    .transition(.letterChooser)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
    
    func changeLetter(_ letter: Letter) {
        self.game?.changeGuessLetter(letter, at: selection)
        selection = (selection + 1) % (game?.wordLength ?? 0)
    }
    
    // MARK: - Computed properties UI
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation(.guess) {
                guessing = true
                self.game?.attemptGuess()
                if game?.isOver == true {
                    finishing = true
                }
            } completion: {
                withAnimation {
                    guessing = false
                    finishing = false
                }
            }
        }
        .font(.system(size: GuessButton.fontSize))
        .foregroundStyle(.green)
        .disabled(!(self.game?.isActive ?? false))
    }
    
    var hintButton: some View {
        Button("Hint", systemImage: "eyes") {
            withAnimation(.selection) {
                if let hintedIndex = game?.useHint() {
                    selection = hintedIndex
                }
            }
        }
        .labelStyle(.iconOnly)
        .font(.system(size: HintButton.maxFontSize))
        .minimumScaleFactor(HintButton.minimumScaleFactor)
        .foregroundStyle(.primary)
    }
    
    var restartButton: some View {
        Button("Restart") {
            withAnimation(.restart) {
                restarting = true
                game?.attempts.removeAll()
            } completion: {
                var noAnimation = Transaction()
                noAnimation.disablesAnimations = true
                withTransaction(noAnimation) {
                    game?.restart()
                    selection = 0
                }
                withAnimation(.restart) {
                    restarting = false
                }
            }
        }
        .font(.system(size: RestartButton.fontSize))
        .foregroundStyle(.red)
    }
}

#Preview {
    WordikView()
}
