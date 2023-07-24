
import Foundation

public protocol LogFormatter {
    func format(level: LogLevel, message: String, functionName: String, line: Int, file: String) -> String
}
