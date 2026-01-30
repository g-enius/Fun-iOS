//
//  ToastServiceProtocol.swift
//  Model
//
//  Protocol for toast notification service
//

import Foundation

public enum ToastType {
    case success
    case error
    case info
}

@MainActor
public protocol ToastServiceProtocol {
    func showToast(message: String, type: ToastType)
}
