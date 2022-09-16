import Foundation

public enum TVError: LocalizedError {
    case invalidFormat
    case remoteURLAccessFailure
    
    public var errorDescription: String? {
        switch self {
        case .invalidFormat: return "Invalid format"
        case .remoteURLAccessFailure: return "Can not access resource"
        }
    }
}
