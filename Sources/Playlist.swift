import Foundation

public class Playlist: Hashable, Codable {

    public let identifier: String
    
    public var name: String
    
    public var items: [PlaylistItem] = []
    
    public var groups: [Group] = []
    
    public var current: PlaylistItem? = nil
    
    public var url: URL
    
    public var epgUrls: String? = nil
    
    public var egp: EPG? = nil
    
    public init(name: String, url: URL) {
        self.identifier = UUID().uuidString
        self.name = name
        self.url = url
    }
    
    public static func == (lhs: Playlist, rhs: Playlist) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public func parseGroups() {
        var result: [Group] = []
        for item in items {
            if var group = result.first(where: { $0.title == item.group }) {
                group.items.append(item)
            } else {
                var group = Group(title: item.group)
                group.items.append(item)
                result.append(group)
            }
        }
        groups = result
    }
}
