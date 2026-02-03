//
//  Tab4ViewModel.swift
//  ViewModel
//
//  ViewModel for Tab4 screen
//

import Foundation
import Combine
import FunModel
import FunCore

@MainActor
public class Tab4ViewModel: ObservableObject {

    // MARK: - Coordinator

    private weak var coordinator: Tab4Coordinator?

    // MARK: - Services

    @Service(.logger) private var logger: LoggerService

    // MARK: - Published State

    @Published public var title: String = "Tab 4"

    // MARK: - Initialization

    public init(coordinator: Tab4Coordinator?) {
        self.coordinator = coordinator
    }

    // MARK: - Actions

    public func didTapDismiss() {
        coordinator?.dismiss()
    }
}
