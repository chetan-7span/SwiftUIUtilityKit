//
//  FontManager.swift
//  SwiftUIUtilityKit
//
//  Created by Chetan Hedamba on 27/03/25.
//

import SwiftUI
import Foundation

public struct FontManager {

    public static func registerFont(fontName: String, fontExtension: String) {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("[SevenSpanFontKit] Failed to load font: \(fontName).\(fontExtension)")
            return
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("[SevenSpanFontKit] Error registering font: \(String(describing: error?.takeRetainedValue()))")
        } else {
            print("[SevenSpanFontKit] Successfully registered: \(fontName)")
        }
    }

    public static func customFont(name: String, size: CGFloat) -> Font {
        if UIFont(name: name, size: size) != nil {
            return Font.custom(name, size: size)
        } else {
            print("[SevenSpanFontKit] Warning: Font \(name) not found. Falling back to system font.")
            return .system(size: size)
        }
    }
}


// Usage Example
// FontManager.registerFont(fontName: "CustomFont-Regular", fontExtension: "ttf")
// Text("Hello").font(FontManager.customFont(name: "CustomFont-Regular", size: 18))
