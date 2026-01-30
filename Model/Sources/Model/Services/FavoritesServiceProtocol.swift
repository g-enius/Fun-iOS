//
//  FavoritesServiceProtocol.swift
//  Model
//
//  Protocol for favorites service
//

import Foundation

@MainActor
public protocol FavoritesServiceProtocol {
    var favorites: Set<String> { get }
    func isFavorited(_ itemId: String) -> Bool
    func toggleFavorite(forKey itemId: String)
    func addFavorite(_ itemId: String)
    func removeFavorite(_ itemId: String)
}
