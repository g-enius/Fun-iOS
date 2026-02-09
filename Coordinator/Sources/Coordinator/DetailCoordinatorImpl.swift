//
//  DetailCoordinatorImpl.swift
//  Coordinator
//
//  Coordinator implementation for Detail screen
//

import UIKit

import FunModel

public final class DetailCoordinatorImpl: BaseCoordinator {

    /// Callback to notify parent coordinator when detail is dismissed
    public var onDismiss: (() -> Void)?

    private var isDismissed = false
}

// MARK: - DetailCoordinator

extension DetailCoordinatorImpl: DetailCoordinator {

    public func dismiss() {
        guard !isDismissed else { return }
        isDismissed = true
        safePop { [weak self] in
            self?.onDismiss?()
        }
    }

    public func handleSystemDismiss() {
        guard !isDismissed else { return }
        isDismissed = true
        onDismiss?()
    }

    // share(text:) is inherited from BaseCoordinator
}
