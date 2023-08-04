import os
import OSLog

@available(iOS 14, *)
final class OSLogger: LogDestination {
    
    private let category: String
    private let subsystem: String
    private let logger: os.Logger
    
    init(category: String) {
        let subsystem = Bundle.main.bundleIdentifier!
        self.subsystem = subsystem
        self.category = category
        self.logger = os.Logger(subsystem: subsystem, category: category)
    }
    
    func log(_ level: LogLevel, message: String) {
        switch level {
        case .debug:
            logger.debug("\(message, privacy: .public)")
        case .notice:
            logger.notice("\(message, privacy: .public)")
        case .warning:
            logger.warning("\(message, privacy: .public)")
        case .error:
            logger.error("\(message, privacy: .public)")
        }
    }
}
