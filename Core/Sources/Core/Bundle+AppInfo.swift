//
//  Bundle+AppInfo.swift
//  Core
//
//  Extension for accessing app version and build information
//

import Foundation

extension Bundle {
    /// App marketing version (e.g., "1.0.0")
    public var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    /// App build number (e.g., "42")
    public var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}
