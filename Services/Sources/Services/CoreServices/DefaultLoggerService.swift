//
//  DefaultLoggerService.swift
//  Services
//
//  Default implementation of LoggerService
//

import Foundation
import FunModel

@MainActor
public final class DefaultLoggerService: LoggerService {

    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()

    public init() {}

    public func log(_ message: String) {
        print("[LOG] \(message)")
    }

    public func log(_ message: String, level: LogLevel) {
        let timestamp = Self.dateFormatter.string(from: Date())
        print("[\(level.rawValue.uppercased())] [\(timestamp)] \(message)")
    }
}
