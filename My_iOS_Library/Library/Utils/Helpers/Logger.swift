//
//  Logger.swift
//  My iOS library
//
//  Comprehensive logging utility for debugging and monitoring
//

import Foundation
import os.log

/// Log levels for categorizing log messages
enum LogLevel: String {
    case verbose = "VERBOSE"
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    case critical = "CRITICAL"

    var icon: String {
        switch self {
        case .verbose:
            return "🔍"
        case .debug:
            return "🐛"
        case .info:
            return "ℹ️"
        case .warning:
            return "⚠️"
        case .error:
            return "❌"
        case .critical:
            return "🔥"
        }
    }

    var osLogType: OSLogType {
        switch self {
        case .verbose, .debug:
            return .debug
        case .info:
            return .info
        case .warning:
            return .default
        case .error:
            return .error
        case .critical:
            return .fault
        }
    }
}

/// Main logging utility
enum Logger {

    // MARK: - Configuration

    /// Configuration for the logger
    struct Configuration {
        /// Minimum log level to display
        var minimumLevel: LogLevel = .debug

        /// Whether to include file and line info
        var includeSourceLocation = true

        /// Whether to include timestamp
        var includeTimestamp = true

        /// Whether to include function name
        var includeFunctionName = true

        /// Whether to use os_log
        var useOSLog = true

        /// Whether to save logs to file
        var saveToFile = false

        /// Maximum log file size in MB
        var maxLogFileSize: Double = 10

        /// Custom log format
        var dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

        /// Shared configuration instance
        static var shared = Configuration()
    }

    // MARK: - Private Properties

    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.app"
    private static let loggers: [String: OSLog] = [:]
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Configuration.shared.dateFormat
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // MARK: - Logging Methods

    /// Logs a verbose message
    static func verbose(
        _ message: String,
        category: String = "App",
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .verbose, category: category, file: file, function: function, line: line)
    }

    /// Logs a debug message
    static func debug(
        _ message: String,
        category: String = "App",
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .debug, category: category, file: file, function: function, line: line)
    }

    /// Logs an info message
    static func info(
        _ message: String,
        category: String = "App",
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .info, category: category, file: file, function: function, line: line)
    }

    /// Logs a warning message
    static func warning(
        _ message: String,
        category: String = "App",
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .warning, category: category, file: file, function: function, line: line)
    }

    /// Logs an error message
    static func error(
        _ message: String,
        error: Error? = nil,
        category: String = "App",
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        var fullMessage = message
        if let error = error {
            fullMessage += "\nError: \(error.localizedDescription)"
        }
        log(fullMessage, level: .error, category: category, file: file, function: function, line: line)
    }

    /// Logs a critical message
    static func critical(
        _ message: String,
        error: Error? = nil,
        category: String = "App",
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        var fullMessage = message
        if let error = error {
            fullMessage += "\nError: \(error.localizedDescription)"
        }
        log(fullMessage, level: .critical, category: category, file: file, function: function, line: line)
    }

    // MARK: - Core Logging

    private static func log(
        _ message: String,
        level: LogLevel,
        category: String,
        file: String,
        function: String,
        line: Int
    ) {
        // Check if we should log this level
        guard shouldLog(level: level) else { return }

        // Format the message
        let formattedMessage = formatMessage(
            message,
            level: level,
            category: category,
            file: file,
            function: function,
            line: line
        )

        // Log to console
        if Configuration.shared.useOSLog {
            osLog(formattedMessage, level: level, category: category)
        } else {
            print(formattedMessage)
        }

        // Save to file if enabled
        if Configuration.shared.saveToFile {
            saveToFile(formattedMessage)
        }
    }

    // MARK: - Helper Methods

    private static func shouldLog(level: LogLevel) -> Bool {
        let levels: [LogLevel] = [.verbose, .debug, .info, .warning, .error, .critical]
        guard let currentIndex = levels.firstIndex(of: level),
              let minimumIndex = levels.firstIndex(of: Configuration.shared.minimumLevel) else {
            return true
        }
        return currentIndex >= minimumIndex
    }

    private static func formatMessage(
        _ message: String,
        level: LogLevel,
        category: String,
        file: String,
        function: String,
        line: Int
    ) -> String {
        var components: [String] = []

        // Add timestamp
        if Configuration.shared.includeTimestamp {
            let timestamp = dateFormatter.string(from: Date())
            components.append("[\(timestamp)]")
        }

        // Add level with icon
        components.append("\(level.icon) \(level.rawValue)")

        // Add category
        components.append("[\(category)]")

        // Add source location
        if Configuration.shared.includeSourceLocation {
            let fileName = (file as NSString).lastPathComponent
            components.append("[\(fileName):\(line)]")
        }

        // Add function name
        if Configuration.shared.includeFunctionName {
            components.append("[\(function)]")
        }

        // Add message
        components.append(message)

        return components.joined(separator: " ")
    }

    private static func osLog(
        _ message: String,
        level: LogLevel,
        category: String
    ) {
        let log = OSLog(subsystem: subsystem, category: category)
        os_log("%{public}@", log: log, type: level.osLogType, message)
    }

    private static func saveToFile(_ message: String) {
        DispatchQueue.global(qos: .background).async {
            guard let documentsDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else { return }

            let logFileURL = documentsDirectory.appendingPathComponent("app_logs.txt")

            do {
                // Check file size
                if FileManager.default.fileExists(atPath: logFileURL.path) {
                    let attributes = try FileManager.default.attributesOfItem(atPath: logFileURL.path)
                    let fileSize = attributes[.size] as? Double ?? 0
                    let maxSize = Configuration.shared.maxLogFileSize * 1024 * 1024 // Convert MB to bytes

                    if fileSize > maxSize {
                        // Rotate log file
                        let backupURL = documentsDirectory.appendingPathComponent("app_logs_backup.txt")
                        try? FileManager.default.removeItem(at: backupURL)
                        try FileManager.default.moveItem(at: logFileURL, to: backupURL)
                    }
                }

                // Append to file
                let data = (message + "\n").data(using: .utf8) ?? Data()
                if FileManager.default.fileExists(atPath: logFileURL.path) {
                    let fileHandle = try FileHandle(forWritingTo: logFileURL)
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                } else {
                    try data.write(to: logFileURL)
                }
            } catch {
                print("Failed to write log to file: \(error)")
            }
        }
    }

    // MARK: - Utility Methods

    /// Configures the logger
    static func configure(_ config: (inout Configuration) -> Void) {
        config(&Configuration.shared)
    }

    /// Measures and logs execution time
    static func measureTime<T>(
        _ title: String,
        category: String = "Performance",
        operation: () throws -> T
    ) rethrows -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        defer {
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            info("\(title) took \(String(format: "%.3f", timeElapsed)) seconds", category: category)
        }
        return try operation()
    }

    /// Logs memory usage
    static func logMemoryUsage(category: String = "Memory") {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4

        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }

        if result == KERN_SUCCESS {
            let memoryUsage = Double(info.resident_size) / 1024.0 / 1024.0
            debug(String(format: "Memory usage: %.2f MB", memoryUsage), category: category)
        }
    }

    /// Gets all log entries from file
    static func getLogEntries() -> [String]? {
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { return nil }

        let logFileURL = documentsDirectory.appendingPathComponent("app_logs.txt")

        do {
            let logContent = try String(contentsOf: logFileURL, encoding: .utf8)
            return logContent.components(separatedBy: .newlines).filter { !$0.isEmpty }
        } catch {
            return nil
        }
    }

    /// Clears log file
    static func clearLogs() {
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { return }

        let logFileURL = documentsDirectory.appendingPathComponent("app_logs.txt")
        try? FileManager.default.removeItem(at: logFileURL)
    }
}

// MARK: - Convenience Extensions

extension Logger {
    /// Logs entry to a function
    static func functionEntry(
        parameters: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        var message = "→ Entering \(function)"
        if let params = parameters {
            let paramsString = params.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
            message += " with [\(paramsString)]"
        }
        debug(message, category: "Flow", file: file, function: function, line: line)
    }

    /// Logs exit from a function
    static func functionExit(
        result: Any? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        var message = "← Exiting \(function)"
        if let result = result {
            message += " with result: \(result)"
        }
        debug(message, category: "Flow", file: file, function: function, line: line)
    }

    /// Logs network request
    static func networkRequest(
        _ request: URLRequest,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? "Unknown URL"
        info("🌐 \(method) \(url)", category: "Network", file: file, function: function, line: line)
    }

    /// Logs network response
    static func networkResponse(
        _ response: URLResponse?,
        error: Error? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        if let httpResponse = response as? HTTPURLResponse {
            let statusCode = httpResponse.statusCode
            let url = httpResponse.url?.absoluteString ?? "Unknown URL"
            let level: LogLevel = statusCode < 400 ? .info : .error
            log("📡 Response: \(statusCode) from \(url)", level: level, category: "Network", file: file, function: function, line: line)
        }

        if let error = error {
            self.error("Network error", error: error, category: "Network", file: file, function: function, line: line)
        }
    }
}