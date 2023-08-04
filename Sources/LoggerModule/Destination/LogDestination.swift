
import Foundation

enum LogDestinationError: LocalizedError {
    case notImplemented
    case noLogsExtracted
    case logConversionToStringFailed
    
    var errorDescription: String? {
        switch self {
        case .notImplemented:
            return "Log export not implemented"
        case .noLogsExtracted:
            return "No logs were extracted from the store."
        case .logConversionToStringFailed:
            return "Log conversion to string failed."
        }
    }
}

public protocol LogDestination {
    func log(_ level: LogLevel, message: String)
}
