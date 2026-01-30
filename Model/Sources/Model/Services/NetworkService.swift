//
//  NetworkService.swift
//  Model
//
//  Protocol for network service
//

import Foundation

@MainActor
public protocol NetworkService {
    func fetch<T: Decodable>(from url: URL) async throws -> T
    func fetchData(from url: URL) async throws -> Data
}
