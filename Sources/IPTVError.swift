import Foundation

public enum IPTVError: LocalizedError {
    case invalidFormat
    case remoteURLAccessFailure
    
    public var errorDescription: String? {
        switch self {
        case .invalidFormat: return "Invalid format"
        case .remoteURLAccessFailure: return "Can not access resource"
        }
    }
}
