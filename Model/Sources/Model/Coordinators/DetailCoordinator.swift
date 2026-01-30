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
    func switchToTab(_ index: Int)
    func share(text: String)
}
