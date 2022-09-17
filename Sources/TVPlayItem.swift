import Foundation
import UIKit

public class TVPlayItem: Hashable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case tvg
        case group
        case url
        case raw
    }
    
    public var identifier: String = UUID().uuidString
    
    public var name: String = ""
    
    /// The tvg info of the item.
    public var tvg: TVG? = nil
    
    /// The group of the item belonged to.
    public var group: String = ""
    
    /// The playing url
    public var url: String = ""
    
    public var raw: String = ""
    
    public var favorited = false
    
    /// The epg info.
    public var epg: EPG? = nil
    
    public var programs: [TVProgramme] = []
    
    public init(name: String, tvg: TVG?, group: String, url: String, raw: String) {
        self.name = name
        self.tvg = tvg
        self.group = group
        self.url = url
        self.raw = raw
    }
    
    public static func == (lhs: TVPlayItem, rhs: TVPlayItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

public extension TVPlayItem {
    
    var logoURL: URL? {
        if let string = tvg?.logo {
            return URL(string: string)
        }
        return nil
    }
    
    var hasValidTVG: Bool {
        if let tvg = tvg, let name = tvg.name, !name.isEmpty, !tvg.id.isEmpty {
            return true
        }
        return false
    }
}
