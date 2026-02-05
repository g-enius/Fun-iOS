//
//  LoginViewController.swift
//  UI
//
//  View controller for Login screen
//

import UIKit
import SwiftUI
import FunViewModel
import FunCore

public final class LoginViewController: UIViewController {

    private let viewModel: LoginViewModel

    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        embedSwiftUIView(LoginView(viewModel: viewModel))
    }
}
