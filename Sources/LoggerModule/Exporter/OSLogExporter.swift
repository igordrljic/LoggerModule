
import OSLog

@available(iOS 15.0, *)
final class OSLogExporter: LogExporter {
    
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
                    completion(.failure(error))
                }
            }
        }
    }
    
}
