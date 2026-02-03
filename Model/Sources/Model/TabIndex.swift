//
//  TabIndex.swift
//  Model
//
//  Centralized tab index constants for type-safe tab navigation
//

import Foundation

/// Tab indices for the main tab bar
public enum TabIndex: Int, CaseIterable {
    case home = 0
    case items = 1
    case settings = 2
}
