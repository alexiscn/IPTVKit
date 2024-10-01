
public struct TVProgramme: Hashable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case start
        case stop
        case channel
        case title
        case desc
    }
    
    /// The start time of the programme. eg: 20220916223450 +0800.
    public let start: String
    
    /// The stop time of the programme. eg: 20220917001715 +0800.
    public let stop: String
    
    /// The channel id of the programme. eg: 1.
    public let channel: String
    
    /// The channel name of the programme, read from channels of epg.
    public var channelName: String?
    
    /// The title of the programme.
    public let title: String
    
    /// The desc of the programme.
    public let desc: String?
}
