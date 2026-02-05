//
//  AppFlowCoordinator.swift
//  Model
//
//  Protocol for coordinating app-level flow changes (logout, etc.)
//

import Foundation

@MainActor
public protocol AppFlowCoordinator: AnyObject {
    /// Called when user logs out, should transition to login flow
    func didLogout()
}
