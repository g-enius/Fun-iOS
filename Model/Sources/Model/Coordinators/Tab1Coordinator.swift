//
//  Tab1Coordinator.swift
//  Model
//
//  Coordinator protocol for Tab1 (Home) navigation
//

import Foundation

@MainActor
public protocol Tab1Coordinator: AnyObject {
    func showDetail(for item: FeaturedItem)
    func showProfile()
    func showSettings()
}
