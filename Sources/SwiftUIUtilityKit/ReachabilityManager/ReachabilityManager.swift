//
//  ReachabilityManager.swift
//  SwiftUIUtilityKit
//
//  Created by Chetan Hedamba on 01/04/25.
//

import SystemConfiguration
import Foundation

public class Reachability {

    public enum Connection: CustomStringConvertible {
        case wifi
        case cellular
        case unavailable

        public var description: String {
            switch self {
            case .wifi: return "WiFi"
            case .cellular: return "Cellular"
            case .unavailable: return "No Connection"
            }
        }
    }

    private var reachability: SCNetworkReachability?
    public private(set) var connection: Connection = .unavailable

    public init?(hostName: String) {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, hostName) else {
            return nil
        }
        self.reachability = reachability
    }

    public func checkConnection() -> Connection {
        guard let reachability = reachability else { return .unavailable }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            return .unavailable
        }

        if !flags.contains(.reachable) {
            return .unavailable
        } else if flags.contains(.isWWAN) {
            return .cellular
        } else {
            return .wifi
        }
    }
}
