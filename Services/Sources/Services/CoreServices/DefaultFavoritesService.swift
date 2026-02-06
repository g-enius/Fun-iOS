//
//  DefaultFavoritesService.swift
//  Services
//
//  Default implementation of FavoritesServiceProtocol
//

import Foundation
import Combine
import FunModel

@MainActor
public final class DefaultFavoritesService: FavoritesServiceProtocol {

    public private(set) var favorites: Set<String> {
        didSet {
            saveFavorites()
            favoritesSubject.send(favorites)
        }
    }

    private let favoritesSubject = PassthroughSubject<Set<String>, Never>()

    public var favoritesDidChange: AnyPublisher<Set<String>, Never> {
        favoritesSubject.eraseToAnyPublisher()
    }

    public init() {
        if let data = UserDefaults.standard.data(forKey: .favorites),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            self.favorites = decoded
        } else {
            self.favorites = ["item1"]
        }
    }

    public func isFavorited(_ itemId: String) -> Bool {
        favorites.contains(itemId)
    }

    public func toggleFavorite(forKey itemId: String) {
        if favorites.contains(itemId) {
            favorites.remove(itemId)
        } else {
            favorites.insert(itemId)
        }
    }

    public func addFavorite(_ itemId: String) {
        favorites.insert(itemId)
    }

    public func removeFavorite(_ itemId: String) {
        favorites.remove(itemId)
    }

    public func resetFavorites() {
        UserDefaults.standard.removeObject(forKey: .favorites)
        favorites = ["item1"]
    }

    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: .favorites)
        }
    }
}
