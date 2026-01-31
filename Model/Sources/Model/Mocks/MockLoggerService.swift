//
//  MockLoggerService.swift
//  Model
//
//  Mock implementation of LoggerService for testing
//

import Foundation

@MainActor
public final class MockLoggerService: LoggerService {
    public var loggedMessages: [String] = []

    public init() {}

    public func log(_ message: String) {
        loggedMessages.append(message)
    }

    public func log(_ message: String, level: LogLevel) {
        loggedMessages.append("[\(level.rawValue)] \(message)")
    }
}
