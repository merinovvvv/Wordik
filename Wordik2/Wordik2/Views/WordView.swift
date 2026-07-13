//
//  WordView.swift
//  Wordik
//
//  Created by Yaraslau Merynau on 13.07.2026.
//

import SwiftUI

enum Match {
    case exact
    case inexact
    case nomatch
}

struct WordView<HelperView>: View where HelperView: View {
    // MARK: Data In
    let word: Word
    @ViewBuilder let helperView: () -> HelperView
    
    // MARK: Data Shared
    @Binding var selection: Int
    
    init(
        word: Word,
        selection: Binding<Int> = .constant(-1),
        @ViewBuilder helperView: @escaping () -> HelperView = { EmptyView() }
    ) {
        self.word = word
        self._selection = selection
        self.helperView = helperView
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            ForEach(word.letters.indices, id: \.self) { index in
                LetterView(letter: word.letters[index])
                    .background {
                        if index == selection, word.kind == .guess {
                            Circle().foregroundStyle(.black.opacity(0.3))
                        } else if let match = word.matches?[index] {
                            switch match {
                            case .exact:   Circle().foregroundColor(.green)
                            case .inexact: Circle().foregroundColor(.orange)
                            case .nomatch: Circle().foregroundColor(.clear)
                            }
                        } else {
                            Circle().foregroundColor(.clear)
                        }
                    }
                    .overlay {
                        if word.kind == .masterWord(isHidden: true) {
                            Circle().foregroundStyle(.black)
                        }
                    }
                    .onTapGesture {
                        if word.kind == .guess {
                            selection = index
                        }
                    }
            }
            Circle()
                .foregroundStyle(.clear)
                .overlay {
                    helperView()
                }
        }
    }
}


#Preview {
    WordView(word: Word(kind: .masterWord(isHidden: true), letters: ["A", "W", "A", "I", "T"]))
}
