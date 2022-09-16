import Foundation

public struct TVG: Hashable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case language
        case country
        case logo
        case url
    }
    
    /// The identifier of the tvg.
    public let identifier = UUID()
    
    /// The id of the tvg. The value extracted from `tvg-id`.
    public var id: String
    
    /// The name of the tvg. The value extracted from `tvg-name`.
    public var name: String?
    
    /// The language of the tvg. The value extracted from `tvg-language`.
    public var language: String?
    
    /// The country of the tvg. The value extracted from `tvg-country`.
    public var country: String?
    
    /// The logo of the tvg. The value extracted from `tvg-logo`.
    public var logo: String?
    
    /// The url of the tvg.  The value extracted from `tvg-url`.
    public var url: String?
    
    public init(id: String) {
        self.id = id
    }
}
