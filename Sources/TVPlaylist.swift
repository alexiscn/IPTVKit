import Foundation

public class TVPlaylist: Hashable, Codable {

    public let identifier: String
    
    public var name: String
    
    public var items: [TVPlayItem] = []
    
    public var groups: [TVGroup] = []
    
    public var current: TVPlayItem? = nil
    
    public var url: URL
    
    public var epgUrls: String? = nil
    
    public var egp: EPG? = nil
    
    public init(name: String, url: URL) {
        self.identifier = UUID().uuidString
        self.name = name
        self.url = url
    }
    
    public static func == (lhs: TVPlaylist, rhs: TVPlaylist) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public func parseGroups() {
        var result: [TVGroup] = []
        for item in items {
            if var group = result.first(where: { $0.title == item.group }) {
                group.items.append(item)
            } else {
                let group = TVGroup(title: item.group, items: [item])
                result.append(group)
            }
        }
        groups = result
    }
}
