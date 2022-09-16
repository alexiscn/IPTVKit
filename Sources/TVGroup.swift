import Foundation

/// The groupped PlaylistItem.
public struct TVGroup: Hashable, Codable {
    
    /// The title of the group. read from `group-title`.
    public let title: String
    
    /// The playlist items in the group.
    public var items: [TVPlayItem] = []
    
    public var isFavorites = false
    
    public init(title: String) {
        self.title = title
    }
}
