//
//  AppError.swift
//  Model
//
//  App-wide error types
//

import Foundation

public enum AppError: LocalizedError, Equatable {
    case networkError
    case serverError
    case unknown

    public var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection failed"
        case .serverError:
            return "Server error occurred"
        case .unknown:
            return "An unknown error occurred"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "Please check your internet connection and try again."
        case .serverError:
            return "Please try again later."
        case .unknown:
            return "Please try again."
        }
    }
}
