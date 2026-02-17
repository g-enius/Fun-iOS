//
//  PressEffect.swift
//  UI
//
//  Reusable press effect system for buttons — enum, modifier, and button style.
//

import SwiftUI

// MARK: - Press Effect

enum PressEffect {
    case none
    case scale(CGFloat)
    case fade(Double)
}

// MARK: - Press Effect Modifier

private struct PressEffectModifier: ViewModifier {
    let effect: PressEffect
    let isPressed: Bool

    func body(content: Content) -> some View {
        switch effect {
        case .none:
            content
        case .scale(let value):
            content
                .scaleEffect(isPressed ? value : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        case .fade(let opacity):
            content
                .opacity(isPressed ? opacity : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
    }
}

extension View {
    func pressEffect(_ effect: PressEffect, isPressed: Bool) -> some View {
        modifier(PressEffectModifier(effect: effect, isPressed: isPressed))
    }
}

// MARK: - Pressable Button Style

struct PressableButtonStyle: ButtonStyle {
    let effect: PressEffect

    init(_ effect: PressEffect = .scale(0.97)) {
        self.effect = effect
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .pressEffect(effect, isPressed: configuration.isPressed)
    }
}
