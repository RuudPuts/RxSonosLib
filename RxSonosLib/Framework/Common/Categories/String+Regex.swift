//
//  String+Regex.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2016 Uberweb. All rights reserved.
//

import Foundation


extension String {
    
    func extractUUID() -> String? {
        return self.match(with: "uuid:([a-zA-Z0-9_]+)")?.first
    }
    
    func baseUrl() -> String? {
        return self.match(with: "(https?://[0-9:.]+)")?.first
    }
    
    func urlSuffix() -> String? {
        return self.match(with: "^https?://[0-9:.]+(.*)$")?.first
    }
    
    func validateXml() -> String {
        let regex = try! NSRegularExpression(pattern: "(\")([A-Za-z0-9-:]+=)", options: [])
        return regex.stringByReplacingMatches(in: self, options: .withTransparentBounds, range: NSRange(location: 0, length: self.count), withTemplate: "$1 $2")
    }
    
    func match(with pattern: String) -> [String]? {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        return regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)).first?.toArray(for: self)
    }
    
    var int: Int? {
        return Int(self)
    }
}

extension Array where Element == URLQueryItem {
    subscript(key: String) -> String? {
        get {
            return filter({ $0.name == key }).first?.value
        }
    }
}

extension NSTextCheckingResult {
    func toArray(for string: String) -> [String] {
        var result = [String]()
        for index in 1..<self.numberOfRanges {
            if let value = self.substring(for: string, index: index) {
                result.append(value)
            }
        }
        return result
    }
    
    func substring(for string: String, index: Int) -> String? {
        guard index < self.numberOfRanges,
            let swiftRange = self.range(at: index).toRange(for: string) else {
            return nil
        }
        return String(string[swiftRange])
    }
}

extension NSRange {
    func toRange(for str: String) -> Range<String.Index>? {
        guard let fromUTFIndex = str.index(str.startIndex, offsetBy: location, limitedBy: str.endIndex),
            let toUTFIndex = str.index(fromUTFIndex, offsetBy: length, limitedBy: str.endIndex),
            let fromIndex = String.Index(fromUTFIndex, within: str),
            let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        return fromIndex ..< toIndex
    }
}
