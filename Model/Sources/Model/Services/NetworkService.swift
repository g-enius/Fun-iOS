//
//  NetworkService.swift
//  Model
//
//  Protocol for network service
//

import Foundation

public protocol NetworkService: Sendable {
    func fetchFeaturedItems() async throws -> [[FeaturedItem]]
    func fetchAllItems() async throws -> [FeaturedItem]
}
