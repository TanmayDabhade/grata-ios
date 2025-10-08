//
//  ButtonStyles.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade
//

import SwiftUI

/// A button style that scales down when pressed for tactile feedback
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
