//
//  UserDefaultsManager.swift
//  SwiftUIUtilityKit
//
//  Created by Chetan Hedamba on 26/03/25.
//

import Foundation

@propertyWrapper
public struct UserDefault<T> {
    private let key: String
    private let defaultValue: T

    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

public final class UserDefaultsManager {

    @MainActor public static let shared = UserDefaultsManager()
    private init() {}

    // Example stored properties
    @UserDefault(key: "isLoggedIn", defaultValue: false)
    public var isLoggedIn: Bool

    @UserDefault(key: "username", defaultValue: "")
    public var username: String

    @UserDefault(key: "themeMode", defaultValue: "light")
    public var themeMode: String

    // Dynamic property registration
    private var dynamicProperties: [String: Any] = [:]

    public func register<T>(key: String, defaultValue: T) {
        dynamicProperties[key] = defaultValue
    }

    public func set<T>(_ value: T, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    public func get<T>(forKey key: String) -> T? {
        UserDefaults.standard.object(forKey: key) as? T
    }

    public func get<T>(forKey key: String, defaultValue: T) -> T {
        return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }

    // Clear all user defaults
    public func reset() {
        UserDefaults.standard.dictionaryRepresentation().keys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    // Sync changes
    public func synchronize() {
        UserDefaults.standard.synchronize()
    }
}
