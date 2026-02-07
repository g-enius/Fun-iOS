//
//  DefaultToastService.swift
//  Services
//
//  Default implementation of ToastServiceProtocol
//

import Combine
import Foundation

import FunModel

@MainActor
public final class DefaultToastService: ToastServiceProtocol {

    // MARK: - Combine Publisher

    private let toastSubject = PassthroughSubject<ToastEvent, Never>()

    public var toastPublisher: AnyPublisher<ToastEvent, Never> {
        toastSubject.eraseToAnyPublisher()
    }

    // MARK: - Initialization

    public init() {}

    // MARK: - ToastServiceProtocol

    public func showToast(message: String, type: ToastType) {
        toastSubject.send(ToastEvent(message: message, type: type))
    }
}
