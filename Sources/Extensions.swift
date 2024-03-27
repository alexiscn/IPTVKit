import Foundation
import CryptoKit

extension String {
    var md5: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        return Insecure.MD5.hash(data: data).toHexString()
    }
    
    func getAttribute(_ key: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: key + #"="(.*?)""#, options: []) else {
            return nil
        }
        let matches = regex.matches(in: self, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: count))
        if let match = matches.first, match.numberOfRanges == 2 {
            let matchRange = match.range(at: 1)
            if let range = Range(matchRange, in: self) {
                return String(self[range])
            }
        }
        return nil
    }
    
    var urlEncoded: String {
        let str = self.replacingOccurrences(of: " ", with: "%20")
        let allowedCharacters = CharacterSet(charactersIn: #"!$^*;'"`<>(){}|"#).inverted
        return (str as NSString).addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? self
    }
}

extension Digest {
    
    func toHexString() -> String {
        map { String(format: "%02x", $0) }.joined()
    }
    
}
