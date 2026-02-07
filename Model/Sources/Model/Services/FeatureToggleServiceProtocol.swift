//
//  FeatureToggleServiceProtocol.swift
//  Model
//
//  Protocol for feature toggle service
//

import Foundation
import Combine

@MainActor
public protocol FeatureToggleServiceProtocol: AnyObject {
    var featuredCarousel: Bool { get set }
    var simulateErrors: Bool { get set }
    var darkModeEnabled: Bool { get set }

    var featuredCarouselPublisher: AnyPublisher<Bool, Never> { get }
    var simulateErrorsPublisher: AnyPublisher<Bool, Never> { get }
    var darkModePublisher: AnyPublisher<Bool, Never> { get }
}
