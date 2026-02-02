//
//  ToastServiceProtocol.swift
//  Model
//
//  Protocol for toast notification service
//

import Foundation
import Combine

public enum ToastType: Sendable {
    case success
    case error
    case info
}

public struct ToastEvent: Sendable {
    public let message: String
    public let type: ToastType

    public init(message: String, type: ToastType) {
        self.message = message
        self.type = type
    }
}

@MainActor
public protocol ToastServiceProtocol {
    func showToast(message: String, type: ToastType)

    /// Publisher for toast events
    var toastPublisher: AnyPublisher<ToastEvent, Never> { get }
}
