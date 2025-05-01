//
//  ForceUpdateConfig.swift
//  SwiftUIUtilityKit
//
//  Created by Chetan Hedamba on 04/04/25.
//

import SwiftUI

public struct ForceUpdateConfig {
    public var title: String
    public var message: String
    public var updateButtonTitle: String
    public var skipButtonTitle: String?
    public var isSkippable: Bool
    public var appStoreURL: URL

    public var titleColor: Color
    public var messageColor: Color
    public var backgroundColor: Color
    public var buttonColor: Color
    public var cornerRadius: CGFloat

    // 💡 New font customization
    public var titleFont: Font
    public var messageFont: Font
    public var updateButtonFont: Font
    public var skipButtonFont: Font

    public init(
        title: String = "Update Required",
        message: String = "Please update the app to continue.",
        updateButtonTitle: String = "Update Now",
        skipButtonTitle: String? = "Maybe Later",
        isSkippable: Bool = false,
        appStoreURL: URL,
        titleColor: Color = .primary,
        messageColor: Color = .secondary,
        backgroundColor: Color = .white,
        buttonColor: Color = .blue,
        cornerRadius: CGFloat = 16,
        titleFont: Font = .title2.bold(),
        messageFont: Font = .body,
        updateButtonFont: Font = .headline,
        skipButtonFont: Font = .subheadline
    ) {
        self.title = title
        self.message = message
        self.updateButtonTitle = updateButtonTitle
        self.skipButtonTitle = skipButtonTitle
        self.isSkippable = isSkippable
        self.appStoreURL = appStoreURL
        self.titleColor = titleColor
        self.messageColor = messageColor
        self.backgroundColor = backgroundColor
        self.buttonColor = buttonColor
        self.cornerRadius = cornerRadius
        self.titleFont = titleFont
        self.messageFont = messageFont
        self.updateButtonFont = updateButtonFont
        self.skipButtonFont = skipButtonFont
    }
}
