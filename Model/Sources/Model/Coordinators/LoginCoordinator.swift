//
//  LoginCoordinator.swift
//  Model
//
//  Coordinator protocol for Login flow
//

import Foundation

@MainActor
public protocol LoginCoordinator: AnyObject {
    /// Called when user successfully logs in
    func didLogin()
}
