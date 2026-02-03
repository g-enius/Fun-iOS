//
//  FavoritesServiceProtocol.swift
//  Model
//
//  Protocol for favorites service
//

import Foundation
import Combine

@MainActor
public protocol FavoritesServiceProtocol {
    var favorites: Set<String> { get }

    /// Publisher that emits when favorites change
    var favoritesDidChange: AnyPublisher<Set<String>, Never> { get }

    func isFavorited(_ itemId: String) -> Bool
    func toggleFavorite(forKey itemId: String)
    func addFavorite(_ itemId: String)
    func removeFavorite(_ itemId: String)
}
