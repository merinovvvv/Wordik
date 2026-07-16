//
//  UIExtensions.swift
//  Wordik2
//
//  Created by Yaraslau Merynau on 16.07.2026.
//

import SwiftUI

extension Animation {
    static let wordik = Animation.easeInOut(duration: 0.3)
    static let selection = wordik
    static let guess = wordik
    static let restart = wordik
}

extension AnyTransition {
    static let letterChooser = AnyTransition.offset(x: 0, y: 300)
    static func attempts(_ isGameOver: Bool) -> AnyTransition {
        .asymmetric(
            insertion: isGameOver ? .identity : .move(edge: .top),
            removal: .offset(x: 400, y: 0)
        )
    }
}
