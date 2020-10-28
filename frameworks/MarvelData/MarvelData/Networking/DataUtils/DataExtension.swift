//
//  DataExtension.swift
//  MarvelData
//
//  Created by johann casique on 26/10/20.
//

import Foundation

extension Data {
    var prettyJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let prettyPrintedData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
              else { return nil }
        return String(data: prettyPrintedData, encoding: .utf8)
    }
    
    var json: Any? {
        return try? JSONSerialization.jsonObject(with: self, options: .allowFragments)
    }
}
