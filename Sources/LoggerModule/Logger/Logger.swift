
import Foundation

public final class Logger {
    
    public var level: LogLevel
    private let destination: LogDestination
    private let formatter: LogFormatter
    
    public init(level: LogLevel, category: String) {
        self.level = level
        self.formatter = DefaultLogFormatter()
        self.destination = {
            if #available(iOS 15, *) {
                return OSLogger(category: category)
            } else {
                return DepracatedLogger()
            }
         }()
    }
    
    public func export(completion: @escaping (Result<Data, Error>) -> Void) {
        destination.export(completion: completion)
    }
    
    public func exportLogsAsString(completion: @escaping (Result<String, Error>) -> Void) {
        destination.export { result in
            switch result {
            case .success(let data):
                
                guard let string = String(data: data, encoding: .unicode) else {
                    completion(.failure(LogDestinationError.logConversionToStringFailed))
                    return
                }
                completion(.success(string))
                
            case .failure(let error):
                
                completion(.failure(error))
                
            }
        }
    }
    
    public func debug(
        _ message: String = "",
        functionName: String = #function,
        line: Int = #line,
        file: String = #file
    ) {
        log(level: .debug, message: message, functionName: functionName, line: line, file: file)
    }
    
    public func notice(
        _ message: String = "",
        functionName: String = #function,
        line: Int = #line,
        file: String = #file
    ) {
        log(level: .notice, message: message, functionName: functionName, line: line, file: file)
    }
    
    public func warning(
        _ message: String,
        functionName: String = #function,
        line: Int = #line,
        file: String = #file
    ) {
        log(level: .warning, message: message, functionName: functionName, line: line, file: file)
    }
    
    public func error(
        _ message: String,
        functionName: String = #function,
        line: Int = #line,
        file: String = #file
    ) {
        log(level: .error, message: message, functionName: functionName, line: line, file: file)
    }
    
    private func log(level: LogLevel, message: String, functionName: String, line: Int, file: String) {
        guard level >= self.level else {
            return
        }
        
        let formatedMessage = formatter.format(level: level, message: message, functionName: functionName, line: line, file: file)
        destination.log(level, message: formatedMessage)
    }
}
