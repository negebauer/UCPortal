//
//  UCPUtils.swift
//  Pods
//
//  Created by Nicolás Gebauer on 25-12-16.
//
//

import Kanna

public struct UCPUtils {
    
    public static func string(_ response: UCPResponse) -> String? {
        return string(response.data)
    }
    
    public static func string(_ data: Data?) -> String? {
        guard let data = data else { return nil }
        return String(data: data, encoding: UCPUtils.utf8) ?? ""
    }
    
    public static let utf8 = String.Encoding.utf8
}
