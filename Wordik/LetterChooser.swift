//
//  LetterChooser.swift
//  Wordik
//
//  Created by Yaraslau Merynau on 13.07.2026.
//

import SwiftUI

struct LetterChooser: View {
    private var rows: [[Letter]] {
        [
            Array(choices[0..<9]),
            Array(choices[9..<16]),
            Array(choices[16..<26])
        ]
    }
    
    // MARK: Data In
    let choices: [Letter]
    
    
    // MARK: Data Out
    var onChoose: (Letter) -> Void
    
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack {
                    ForEach(rows[rowIndex], id: \.self) { letter in
                        LetterView(letter: letter)
                            .onTapGesture {
                                onChoose(letter)
                            }
                    }
                }
            }
        }
    }
}

//#Preview {
//    LetterChooser()
//}
