//
//  MockLoggerService.swift
//  Model
//
//  Mock implementation of LoggerService for testing
//

import Foundation

@MainActor
public final class MockLoggerService: LoggerService {
    public var loggedMessages: [(message: String, level: LogLevel, category: String)] = []

    public init() {}

    public func log(_ message: String) {
        loggedMessages.append((message, .info, "general"))
    }

    public func log(_ message: String, level: LogLevel) {
        loggedMessages.append((message, level, "general"))
    }

    public func log(_ message: String, level: LogLevel, category: String) {
        loggedMessages.append((message, level, category))
    }
}
