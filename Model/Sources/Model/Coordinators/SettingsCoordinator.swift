//
//  SettingsCoordinator.swift
//  Model
//
//  Coordinator protocol for Settings screen navigation
//

import Foundation

@MainActor
public protocol SettingsCoordinator: AnyObject {
    func dismiss()
}
