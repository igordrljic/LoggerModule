import XCTest
@testable import LoggerModule

final class LoggerTests: XCTestCase {
    
    func testLogger() throws {
        let logDestination = TestLoggerDestination()
        let logger = Logger(
            level: .debug,
            category: "Logger Test",
            formatter: DefaultLogFormatter(),
            destinations: [logDestination],
            exporter: DeprecatedLogExporter()
        )
        logger.debug("debug log")
        XCTAssertEqual("🛠 🌕 LoggerTests ✳️ testLogger() #️⃣_15: debug log", logDestination.lastLogMessage)
        XCTAssertEqual(LogLevel.debug, logDestination.lastLogMessageLevel)
        
        logger.notice("notice log")
        XCTAssertEqual("🧤 🌕 LoggerTests ✳️ testLogger() #️⃣_19: notice log", logDestination.lastLogMessage)
        XCTAssertEqual(LogLevel.notice, logDestination.lastLogMessageLevel)
        
        logger.warning("warning log")
        XCTAssertEqual("⚠️ 🌕 LoggerTests ✳️ testLogger() #️⃣_23: warning log", logDestination.lastLogMessage)
        XCTAssertEqual(LogLevel.warning, logDestination.lastLogMessageLevel)
        
        logger.error("error log")
        XCTAssertEqual("🔥 🌕 LoggerTests ✳️ testLogger() #️⃣_27: error log", logDestination.lastLogMessage)
        XCTAssertEqual(LogLevel.error, logDestination.lastLogMessageLevel)
    }
    
}

private final class TestLoggerDestination: LogDestination {
    
    private (set) var lastLogMessage: String = ""
    private (set) var lastLogMessageLevel: LogLevel!
    
    func log(_ level: LoggerModule.LogLevel, message: String) {
        lastLogMessage = message
        lastLogMessageLevel = level
    }
}
