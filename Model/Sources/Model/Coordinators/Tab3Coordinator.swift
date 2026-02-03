//
//  Tab3Coordinator.swift
//  Model
//
//  Coordinator protocol for Tab3 (Items) navigation
//

import Foundation

@MainActor
public protocol Tab3Coordinator: AnyObject {
    func showDetail(for item: FeaturedItem)
}
