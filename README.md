# IPTVKit

A simple IPTV toolkit.

## Features

- support `M3U`, `TXT` format playlist
- support EPG
- support TVG
- support iOS 14+, tvOS 14+, macOS 12+

## Models

```swift

/// The channel of epg. 
public struct TVChannel: Hashable, Codable {
    
    /// The id of channel
    public let id: String
    
    /// The name of channel
    public let name: String
}

/// The programme of epg.
public struct TVProgramme: Hashable, Codable {
    
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
    public let desc: String
}

```
