import os
import OSLog

@available(iOS 15, *)
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
    
    func export(completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let store = try OSLogStore(scope: .currentProcessIdentifier)
//                let position = store.position(timeIntervalSinceLatestBoot: .zero)
                let date = Date.now.addingTimeInterval(-24 * 3600)
                let position = store.position(date: date)
                let data = try store
                    .getEntries(at: position)
                    .compactMap { $0 as? OSLogEntryLog }
                    .filter { $0.subsystem == Bundle.main.bundleIdentifier! }
                    .map { "[\($0.date.ISO8601Format())] [\($0.category)] \($0.composedMessage)" }
                    .reduce("", { partialResult, entry in
                        "\(partialResult)\n\(entry)"
                    })
                    .data(using: .unicode)

                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(LogDestinationError.noLogsExtracted))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(.success(data))
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.log(.error, message: error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
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
