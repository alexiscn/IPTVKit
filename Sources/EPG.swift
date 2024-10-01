import Foundation
import Kanna

/// Electronic Program Guide
public struct EPG: Hashable, Codable {
    
    public lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss Z"
        return formatter
    }()
    
    public lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale.current
        return formatter
    }()
    
    public let channels: [TVChannel]
    
    public let programs: [TVProgramme]
    
    public var updateDate = Date.distantPast
    
    public var isValid: Bool {
        Date().timeIntervalSince1970 - updateDate.timeIntervalSince1970 < 12 * 60 * 60
    }
    
    public init(channels: [TVChannel], programs: [TVProgramme]) {
        self.channels = channels
        self.programs = programs
    }
    
    public init?(data: Data) throws {
        var programs = [TVProgramme]()
        
        let doc = try Kanna.XML(xml: data, encoding: .utf8)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss Z"
        var hasSetTimeZone = false
        var today = ""
    
        var channels = [TVChannel]()
        let channelElements = doc.xpath("//channel", namespaces: nil)
        channelElements.forEach { element in
            if let id = element.at_xpath("@id")?.text,
               let name = element.at_xpath("//display-name")?.text {
                let channel = TVChannel(id: id, name: name)
                channels.append(channel)
            }
        }
        
        let programmeElements = doc.xpath("//programme", namespaces: nil)
        programmeElements.forEach { element in
            if let start = element.at_xpath("@start")?.text,
               let stop = element.at_xpath("@stop")?.text,
               let channelId = element.at_xpath("@channel")?.text,
               let title = element.at_xpath("//title")?.text {
                let desc = element.at_xpath("//desc")?.text
                if !hasSetTimeZone, start.count == 20 {
                    let op = String(start[start.index(start.startIndex, offsetBy: 15)..<start.index(start.startIndex, offsetBy: 16)])
                    let time = String(start[start.index(start.startIndex, offsetBy: 16)..<start.endIndex])
                    let hour = time[time.startIndex ..< time.index(time.startIndex, offsetBy: 2)]
                    let minute = time[time.index(time.startIndex, offsetBy: 2) ..< time.endIndex]
                    if let hours = Int(String(hour)), let minutes = Int(String(minute)) {
                        let seconds = hours * 3600 + minutes * 60
                        let secondsFromGMT = op == "+" ? seconds: -seconds
                        formatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
                    }
                    let nowDate = formatter.string(from: Date())
                    today = String(nowDate[nowDate.startIndex..<nowDate.index(nowDate.startIndex, offsetBy: 8)])
                    hasSetTimeZone = true
                }
                
                if start.hasPrefix(today) {
                    let channelName = channels.first(where: { $0.id == channelId })?.name
                    let program = TVProgramme(start: start, stop: stop, channel: channelId, channelName: channelName, title: title, desc: desc)
                    programs.append(program)
                }
            }
        }
        self.init(channels: channels, programs: programs)
        dateFormatter.timeZone = formatter.timeZone
    }
}
