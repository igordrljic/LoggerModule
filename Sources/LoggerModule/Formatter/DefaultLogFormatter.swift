
import Foundation

final class DefaultLogFormatter: LogFormatter {
    
    private var thread: String {
        return Thread.isMainThread ? "🌕" : "🌘"
    }
        
    func format(level: LogLevel, message: String, functionName: String, line: Int, file: String) -> String {
        switch level {
        case .debug:
            return "🛠 \(format(message: message, functionName: functionName, line: line, file: file))"
        case .notice:
            return "🧤 \(format(message: message, functionName: functionName, line: line, file: file))"
        case .warning:
            return "⚠️ \(format(message: message, functionName: functionName, line: line, file: file))"
        case .error:
            return "🔥 \(format(message: message, functionName: functionName, line: line, file: file))"
        }
    }
    
    private func format(message: String, functionName: String, line: Int, file: String) -> String {
        return "\(thread) \(className(from: file)) ✳️ \(functionName) #️⃣_\(line): \(message)"
    }
    
    private func className(from file: String) -> String {
        return (file as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
    }
}
