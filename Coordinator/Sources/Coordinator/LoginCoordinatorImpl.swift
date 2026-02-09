//
//  LoginCoordinatorImpl.swift
//  Coordinator
//
//  Coordinator implementation for Login flow
//

import UIKit

import FunModel
import FunUI
import FunViewModel

public final class LoginCoordinatorImpl: BaseCoordinator {

    // MARK: - Properties

    /// Callback to notify parent coordinator of successful login
    public var onLoginSuccess: (() -> Void)?

    override public func start() {
        let viewModel = LoginViewModel(coordinator: self)
        let viewController = LoginViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }

}

extension LoginCoordinatorImpl: LoginCoordinator {

    // MARK: - LoginCoordinator

    public func didLogin() {
        onLoginSuccess?()
    }
}
