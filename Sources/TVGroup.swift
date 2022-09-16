import Foundation

/// The groupped PlaylistItem.
public struct TVGroup: Hashable, Codable {
    
    /// The title of the group. read from `group-title`.
    public let title: String
    
    /// The playlist items in the group.
    public var items: [TVPlayItem]
    
    public init(title: String, items: [TVPlayItem]) {
        self.title = title
        self.items = items
    }
}
