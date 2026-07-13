//
//  WordView.swift
//  Wordik
//
//  Created by Yaraslau Merynau on 12.07.2026.
//

import SwiftUI

typealias Letter = Character


struct LetterView: View {
    // MARK: Constants
    struct Font {
        static let maximumSize: CGFloat = 200
        static let minimumSize: CGFloat = 5
        static let minumumScaleFactor = minimumSize / maximumSize
    }
    
    // MARK: Data In
    let letter: Letter
    let areaShape: Text
    
    init(letter: Letter) {
        self.letter = letter
        self.areaShape = Text(String(letter))
    }
    
    // MARK: - Body
    var body: some View {
        areaShape
            .foregroundStyle(.black)
            .font(.system(size: Font.maximumSize))
            .minimumScaleFactor(Font.minumumScaleFactor)
            .lineLimit(1)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                Circle()
                    .strokeBorder(.black)
            )
            .contentShape(Circle())
    }
}

#Preview {
    LetterView(letter: "A")
        .padding()
}
