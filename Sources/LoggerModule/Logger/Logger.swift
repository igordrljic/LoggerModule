
import Foundation

public class Logger {
    
    public var level: LogLevel
    private let formatter: LogFormatter
    private let destinations: [LogDestination]
    private let exporter: LogExporter
    
    public convenience init(
        level: LogLevel,
        category: String
    ) {
        self.init(
            level: level,
            category: category,
            formatter: nil,
            destinations: nil,
            exporter: nil
        )
    }
    
    public init(
        level: LogLevel,
        category: String,
        formatter: LogFormatter? = nil,
        destinations: [LogDestination]? = nil,
        exporter: LogExporter? = nil
    ) {
        self.level = level
        self.formatter = formatter ?? Self.createDefaultLogFormatter()
        self.destinations = destinations ?? Self.createDefaultLoggingDestinations(with: category)
        self.exporter = exporter ?? Self.createDefaultLogExporter()
    }
    
    public func export(completion: @escaping (Result<Data, Error>) -> Void) {
        exporter.export(completion: completion)
    }
    
    public func exportLogsAsString(completion: @escaping (Result<String, Error>) -> Void) {
        exporter.export { result in
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
    
    public func log(level: LogLevel, message: String, functionName: String, line: Int, file: String) {
        guard level >= self.level else {
            return
        }
        
        let formatedMessage = formatter.format(
            level: level,
            message: message,
            functionName: functionName,
            line: line,
            file: file
        )
        for destination in destinations {
            destination.log(level, message: formatedMessage)
        }
    }
    
    public static func createDefaultLogFormatter() -> LogFormatter {
        return DefaultLogFormatter()
    }
    
    public static func createDefaultLogExporter() -> LogExporter {
        if #available(iOS 15, *) {
            return OSLogExporter()
        } else {
            return DeprecatedLogExporter()
        }
    }
    
    public static func createDefaultLoggingDestinations(with category: String) -> [LogDestination] {
        if #available(iOS 14, *) {
            return [OSLogger(category: category)]
        } else {
            return [DepracatedLogger()]
        }
    }
}
