//
//  Tab2Coordinator.swift
//  Model
//
//  Coordinator protocol for Tab2 (Search) navigation
//

import Foundation

@MainActor
public protocol Tab2Coordinator: AnyObject {
    func showDetail(for item: FeaturedItem)
    func switchToTab(_ index: Int)
}
