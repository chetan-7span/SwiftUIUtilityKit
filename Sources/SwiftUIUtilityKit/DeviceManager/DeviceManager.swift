

import UIKit
import LocalAuthentication
import CoreTelephony
import Network

@MainActor
public struct DeviceManager {

    public static let shared = DeviceManager()

    private init() {}

    public var deviceName: String {
        UIDevice.current.name
    }

    public var model: String {
        UIDevice.current.model
    }

    public var systemName: String {
        UIDevice.current.systemName
    }

    public var systemVersion: String {
        UIDevice.current.systemVersion
    }

    public var batteryLevel: Float {
        UIDevice.current.isBatteryMonitoringEnabled = true
        return UIDevice.current.batteryLevel
    }

    public var isCharging: Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true
        return UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full
    }

    public var screenResolution: String {
        let screen = UIScreen.main.bounds
        return "\(Int(screen.width)) x \(Int(screen.height))"
    }

    public var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    public var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }

    public var scale: CGFloat {
        UIScreen.main.scale
    }

    public var locale: String {
        Locale.current.identifier
    }

    public var timeZone: String {
        TimeZone.current.identifier
    }

    public var supportsFaceID: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) && context.biometryType == .faceID
    }

    public var supportsTouchID: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) && context.biometryType == .touchID
    }

    public var isLowPowerModeEnabled: Bool {
        ProcessInfo.processInfo.isLowPowerModeEnabled
    }

    public var availableStorage: Int64? {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
              let freeSize = systemAttributes[.systemFreeSize] as? Int64 else { return nil }
        return freeSize / (1024 * 1024 * 1024) // GB
    }

    public var totalStorage: Int64? {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
              let totalSize = systemAttributes[.systemSize] as? Int64 else { return nil }
        return totalSize / (1024 * 1024 * 1024) // GB
    }

    public var carrierName: String? {
        #if targetEnvironment(simulator)
        return "Simulator"
        #else
        let networkInfo = CTTelephonyNetworkInfo()
        return networkInfo.serviceSubscriberCellularProviders?.values.first?.carrierName
        #endif
    }

    public var isJailbroken: Bool {
        let paths = ["/Applications/Cydia.app", "/Library/MobileSubstrate/MobileSubstrate.dylib", "/bin/bash", "/usr/sbin/sshd"]
        return paths.contains { FileManager.default.fileExists(atPath: $0) }
    }

    public var networkConnectionType: String {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)

        if monitor.currentPath.usesInterfaceType(.wifi) {
            return "WiFi"
        } else if monitor.currentPath.usesInterfaceType(.cellular) {
            return "Cellular"
        } else {
            return "Unknown"
        }
    }

    public var uniqueDeviceIdentifier: String? {
        UIDevice.current.identifierForVendor?.uuidString
    }

    public func printAllDeviceInfo() {
        print("Device Name: \(deviceName)")
        print("Model: \(model)")
        print("System Name: \(systemName)")
        print("System Version: \(systemVersion)")
        print("Battery Level: \(batteryLevel * 100)%")
        print("Is Charging: \(isCharging)")
        print("Screen Resolution: \(screenResolution)")
        print("Screen Width: \(screenWidth)")
        print("Screen Height: \(screenHeight)")
        print("Scale: \(scale)")
        print("Locale: \(locale)")
        print("Time Zone: \(timeZone)")
        print("Supports Face ID: \(supportsFaceID)")
        print("Supports Touch ID: \(supportsTouchID)")
        print("Low Power Mode: \(isLowPowerModeEnabled)")
        print("Available Storage: \(availableStorage ?? 0) GB")
        print("Total Storage: \(totalStorage ?? 0) GB")
        print("Carrier Name: \(carrierName ?? "Unknown")")
        print("Is Jailbroken: \(isJailbroken)")
        print("Network Connection Type: \(networkConnectionType)")
        print("UDID: \(uniqueDeviceIdentifier ?? "Unknown")")
    }
}

// Usage Example:
// let deviceInfo = DeviceManager.shared
// deviceInfo.printAllDeviceInfo()
