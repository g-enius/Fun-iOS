//
//  Tab5Coordinator.swift
//  Model
//
//  Coordinator protocol for Tab5 (Settings) navigation
//

import Foundation

@MainActor
public protocol Tab5Coordinator: AnyObject {
    func dismiss()
}
