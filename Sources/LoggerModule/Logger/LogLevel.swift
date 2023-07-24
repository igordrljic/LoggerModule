
public enum LogLevel: Int {
    case debug
    case notice
    case warning
    case error
}

extension LogLevel: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }
}
