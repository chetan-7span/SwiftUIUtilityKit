//
//  Bundle+Extensions.swift
//  SwiftUIUtilityKit
//
//  Created by Chetan Hedamba on 09/04/25.
//

import Foundation
import UIKit

public extension Bundle {
    
    /// App Version (e.g., 1.2.0)
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    /// App Build Number (e.g., 120)
    var appBuild: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    /// App Display Name
    var displayName: String {
        return infoDictionary?["CFBundleDisplayName"] as? String
            ?? infoDictionary?["CFBundleName"] as? String
            ?? "Unknown"
    }
    
    /// App Bundle Identifier
    var bundleIdentifierString: String {
        return bundleIdentifier ?? "Unknown"
    }
    
    /// Load Decodable JSON File from Bundle
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            print("Failed to locate \(file) in bundle.")
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("Failed to load \(file) from bundle.")
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Failed to decode \(file): \(error)")
            return nil
        }
    }
    
    /// Check if running via TestFlight
    var isTestFlight: Bool {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else { return false }
        return appStoreReceiptURL.lastPathComponent == "sandboxReceipt"
    }
    
    /// Check if running Unit Tests
    var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    /// Current App Icon Name (if using alternate icons)
    var appIconName: String? {
        guard let iconsDictionary = infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let lastIcon = iconFiles.last else {
                  return nil
              }
        return lastIcon
    }
}

