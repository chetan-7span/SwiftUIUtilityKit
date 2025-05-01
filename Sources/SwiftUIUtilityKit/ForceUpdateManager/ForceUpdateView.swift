//
//  ForceUpdateView.swift
//  SwiftUIUtilityKit
//
//  Created by Chetan Hedamba on 04/04/25.
//

import SwiftUI

public struct ForceUpdateView: View {
    let config: ForceUpdateConfig
    let onSkip: (() -> Void)?

    public init(config: ForceUpdateConfig, onSkip: (() -> Void)? = nil) {
        self.config = config
        self.onSkip = onSkip
    }

    public var body: some View {
        ZStack {
            config.backgroundColor.opacity(0.85).edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text(config.title)
                    .font(config.titleFont)
                    .foregroundColor(config.titleColor)

                Text(config.message)
                    .font(config.messageFont)
                    .foregroundColor(config.messageColor)
                    .multilineTextAlignment(.center)

                Button(action: {
                    UIApplication.shared.open(config.appStoreURL)
                }) {
                    Text(config.updateButtonTitle)
                        .font(config.updateButtonFont)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(config.buttonColor)
                        .cornerRadius(10)
                }

                if config.isSkippable, let skipTitle = config.skipButtonTitle {
                    Button(action: {
                        onSkip?()
                    }) {
                        Text(skipTitle)
                            .font(config.skipButtonFont)
                            .foregroundColor(config.buttonColor)
                            .padding(.top, 8)
                    }
                }
            }
            .padding()
            .background(config.backgroundColor)
            .cornerRadius(config.cornerRadius)
            .padding(.horizontal, 32)
            .applyShadow()
        }
    }
}


#Preview {
    ForceUpdateView(
        config: ForceUpdateConfig(
            title: "🚀 Update Available",
            message: "We've improved performance and squashed some bugs. Please update for the best experience.",
            updateButtonTitle: "Update Now",
            skipButtonTitle: "Later",
            isSkippable: true,
            appStoreURL: URL(string: "https://apps.apple.com/app/id123456789")!,
            titleColor: .indigo,
            messageColor: .gray,
            backgroundColor: Color(.systemBackground),
            buttonColor: .orange,
            cornerRadius: 24,
            titleFont: .custom("AvenirNext-Bold", size: 24),
            messageFont: .custom("AvenirNext-Regular", size: 16),
            updateButtonFont: .custom("AvenirNext-Medium", size: 18),
            skipButtonFont: .custom("AvenirNext-Regular", size: 14)
        ),
        onSkip: {
            print("User chose to skip update")
        }
    )

}
