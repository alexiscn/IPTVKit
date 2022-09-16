import Foundation

/// The channel of epg. 
public struct Channel: Hashable, Codable {
    
    /// The id of channel
    public let id: String
    
    /// The name of channel
    public let name: String
}
