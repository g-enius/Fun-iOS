//
//  DetailCoordinatorImpl.swift
//  Coordinator
//
//  Coordinator implementation for Detail screen
//

import UIKit
import FunModel

public final class DetailCoordinatorImpl: BaseCoordinator, DetailCoordinator {

    // MARK: - DetailCoordinator

    public func dismiss() {
        safePop()
    }

    // share(text:) is inherited from BaseCoordinator
}
