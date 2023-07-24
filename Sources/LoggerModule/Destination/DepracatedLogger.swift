
import Foundation

// Logger used for logging on iOS versions less then 14
final class DepracatedLogger: LogDestination {
    
    func export(completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.main.async {
            completion(.failure(LogDestinationError.notImplemented))
        }
    }
    
    func log(_ level: LogLevel, message: String) {
        print(message)
    }
    
}
