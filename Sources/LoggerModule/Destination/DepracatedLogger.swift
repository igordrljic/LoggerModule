
import Foundation

// Logger used for logging on iOS versions less then 14
final class DepracatedLogger: LogDestination {
        
    func log(_ level: LogLevel, message: String) {
        print(message)
    }
    
}
