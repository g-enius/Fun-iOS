//
//  SettingsViewModel.swift
//  ViewModel
//
//  ViewModel for Settings screen (modal)
//

import Foundation
import Combine
import FunModel
import FunToolbox

@MainActor
public class SettingsViewModel: ObservableObject {

    // MARK: - Coordinator

    private weak var coordinator: SettingsCoordinator?

    // MARK: - Services

    @Service(.logger) private var logger: LoggerService

    // MARK: - Published State

    @Published public var notificationsEnabled: Bool = true
    @Published public var privacyModeEnabled: Bool = false

    // MARK: - Initialization

    public init(coordinator: SettingsCoordinator?) {
        self.coordinator = coordinator
    }

    // MARK: - Actions

    public func didTapDismiss() {
        coordinator?.dismiss()
    }

    public func didTapAbout() {
        logger.log("About tapped")
    }
}
