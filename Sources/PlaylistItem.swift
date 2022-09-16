import Foundation
import UIKit

public class PlaylistItem: Hashable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case tvg
        case group
        case url
        case raw
    }
    
    public var identifier: String = UUID().uuidString
    
    public var name: String = ""
    
    public var tvg: TVG? = nil
    
    public var group: String = ""
    
    public var url: String = ""
    
    public var raw: String = ""
    
    public var favorited = false
    
    public var guide: EPG? = nil
    
    public var programs: [Programme] = []
    
    public init(name: String, tvg: TVG?, group: String, url: String, raw: String) {
        self.name = name
        self.tvg = tvg
        self.group = group
        self.url = url
        self.raw = raw
    }
    
    public static func == (lhs: PlaylistItem, rhs: PlaylistItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
