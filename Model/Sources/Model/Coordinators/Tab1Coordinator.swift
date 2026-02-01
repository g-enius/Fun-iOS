//
//  Tab1Coordinator.swift
//  Model
//
//  Coordinator protocol for Tab1 (Home) navigation
//

import Foundation

@MainActor
public protocol Tab1Coordinator: AnyObject {
    func showDetail(for item: String)
    func showProfile()
    func showSettings()
}
