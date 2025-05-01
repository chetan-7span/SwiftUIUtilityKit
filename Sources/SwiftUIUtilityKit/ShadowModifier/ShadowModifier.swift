//
//  ShadowModifier.swift
//  SwiftUIUtilityKit
//
//  Created by Chetan Hedamba on 03/04/25.
//

import SwiftUI

public struct ShadowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    public init(color: Color = .black.opacity(0.2), radius: CGFloat = 5, x: CGFloat = 0, y: CGFloat = 4) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }

    public func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: radius, x: x, y: y)
    }
}

// Extension for easy usage
public extension View {
    func applyShadow(color: Color = .black.opacity(0.2), radius: CGFloat = 5, x: CGFloat = 0, y: CGFloat = 4) -> some View {
        self.modifier(ShadowModifier(color: color, radius: radius, x: x, y: y))
    }
}

