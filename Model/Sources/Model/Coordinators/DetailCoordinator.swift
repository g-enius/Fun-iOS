//
//  DetailCoordinator.swift
//  Model
//
//  Coordinator protocol for Detail screen navigation
//

import Foundation

@MainActor
public protocol DetailCoordinator: AnyObject {
    func dismiss()
    func share(text: String)
}
