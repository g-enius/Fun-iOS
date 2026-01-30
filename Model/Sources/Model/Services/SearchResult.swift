//
//  SearchResult.swift
//  Model
//
//  Search result data model
//

import Foundation

public struct SearchResult: Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let category: String

    public init(id: String, title: String, subtitle: String, category: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.category = category
    }
}
