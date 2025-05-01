//
//  SkeletonView.swift
//  SwiftUIUtilityKit
//
//  Created by Chetan Hedamba on 07/04/25.
//

//import SwiftUI
//
//public struct ShimmerView<Content: View>: View {
//    private let isLoading: Bool
//    private let backgroundColor: Color
//    private let highlightColor: Color
//    private let speed: Double
//    private let content: () -> Content
//
//    public init(
//        isLoading: Bool,
//        backgroundColor: Color = .gray.opacity(0.3),
//        highlightColor: Color = .white.opacity(0.6),
//        speed: Double = 1.5,
//        @ViewBuilder content: @escaping () -> Content
//    ) {
//        self.isLoading = isLoading
//        self.backgroundColor = backgroundColor
//        self.highlightColor = highlightColor
//        self.speed = speed
//        self.content = content
//    }
//
//    public var body: some View {
//        if isLoading {
//            content()
//                .redacted(reason: .placeholder)
//                .shimmer(backgroundColor: backgroundColor, highlightColor: highlightColor, speed: speed)
//        } else {
//            content()
//        }
//    }
//}
