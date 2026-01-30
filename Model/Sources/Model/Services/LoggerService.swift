//
//  LoggerService.swift
//  Model
//
//  Protocol for logging service
//

import Foundation

@MainActor
public protocol LoggerService {
    func log(_ message: String)
    func log(_ message: String, level: LogLevel)
}

public enum LogLevel: String {
    case debug
    case info
    case warning
    case error
}
