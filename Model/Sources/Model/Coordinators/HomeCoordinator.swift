//
//  HomeCoordinator.swift
//  Model
//
//  Coordinator protocol for Home tab navigation
//

import Foundation

@MainActor
public protocol HomeCoordinator: AnyObject {
    func showDetail(for item: FeaturedItem)
    func showProfile()
}
