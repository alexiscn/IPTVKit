import Foundation

public struct TVParser {
 
    public static func parse(text: String, name: String, url: URL) -> TVPlaylist? {
        var items: [TVPlayItem] = []
        var current: TVPlayItem?
        var epgUrl: String?
        var group: String?
        text.enumerateLines { line, stop in
            if line == "\r\n" {
                print(line)
            } else if line.hasPrefix("#EXTM3U") {
                let info = line.replacingOccurrences(of: "#EXTINF:", with: "")
                epgUrl = info.getAttribute("url-tvg")
            } else if line.hasPrefix("#EXTINF:") {
                let info = line.replacingOccurrences(of: "#EXTINF:", with: "")
                let name = info.components(separatedBy: ",").last ?? ""
                let group = info.getAttribute("group-title") ?? ""
                let id = info.getAttribute("tvg-id") ?? ""
                
                var tvg = TVG(id: id)
                tvg.name = info.getAttribute("tvg-name")
                tvg.language = info.getAttribute("tvg-language")
                tvg.country = info.getAttribute("tvg-country")
                tvg.logo = info.getAttribute("tvg-logo")?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                tvg.url = info.getAttribute("tvg-url")

                let item = TVPlayItem(name: name, tvg: tvg, group: group, url: "", raw: info)

                current = item
            } else if let url = URL(string: line.replacingOccurrences(of: " ", with: "")) {
                current?.url = url.absoluteString
                if let item = current {
                    items.append(item)
                    current = nil
                }
            } else if line.contains(",") {
                let components = line.components(separatedBy: ",")
                if components.count == 2 {
                    let name = components[0]
                    var tail = components[1]
                    if tail.contains("#"), let valid = tail.components(separatedBy: "#").first, !valid.isEmpty {
                       tail = valid
                    }
                    
                    if let url = URL(string: tail) {
                        let item = TVPlayItem(name: name, tvg: nil, group: group ?? "", url: url.absoluteString, raw: line)
                        items.append(item)
                    } else {
                        group = name
                    }
                }
            } else {
                if let url = URL(string: line) {
                    current?.url = url.absoluteString
                    if let item = current {
                        items.append(item)
                        current = nil
                    }
                } else if line.count > 0 {
                    group = line
                }
            }
        }
        guard items.count > 0 else {
            return nil
        }
        let playlist = TVPlaylist(name: name, url: url)
        playlist.items = items
        playlist.epgUrls = epgUrl
        playlist.parseGroups()
        return playlist
    }
}


