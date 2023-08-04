
import Foundation

final class DeprecatedLogExporter: LogExporter {
    
    func export(completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.failure(LogDestinationError.notImplemented))
    }
    
}
