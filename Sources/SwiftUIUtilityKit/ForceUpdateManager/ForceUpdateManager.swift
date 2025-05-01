//
//  ForceUpdateManager.swift
//  SwiftUIUtilityKit
//
//  Created by Chetan Hedamba on 04/04/25.
//

public struct ForceUpdateManager {
    public static func shouldForceUpdate(minimumVersion: String, currentVersion: String) -> Bool {
        return currentVersion.compare(minimumVersion, options: .numeric) == .orderedAscending
    }
}

