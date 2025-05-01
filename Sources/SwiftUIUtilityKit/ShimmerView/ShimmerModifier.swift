//
//  ShimmerModifier.swift
//  SwiftUIUtilityKit
//
//  Created by Chetan Hedamba on 07/04/25.
//

import SwiftUI


public struct Shimmer: ViewModifier {
    
    @State private var isAnimating: Bool = false
    var isLoading: Bool

    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    public func body(content: Content) -> some View {
        content
            .redacted(reason: isLoading ? .placeholder : [])
            .mask {
                if isLoading {
                    LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.4), .black, .black.opacity(0.4)]),
                        startPoint: isAnimating ? .init(x: -0.3, y: -0.3) : .init(x: 1.3, y: 1.3),
                        endPoint: isAnimating ? .init(x: 0, y: 0) : .init(x: 1, y: 1)
                    )
                    .animation(
                        .linear(duration: 1.5)
                        .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
                    .onAppear {
                        isAnimating = true
                    }
                    .onDisappear {
                        isAnimating = false
                    }
                } else {
                    Rectangle()
                }
            }
    }
}

public extension View {
    func shimmer(isLoading: Bool) -> some View {
        self.modifier(Shimmer(isLoading: isLoading))
    }
}
