//
//  DateExtension.swift
//  MarvelData
//
//  Created by johann casique on 26/10/20.
//

import Foundation

extension Date {
    var timestamp: String {
        return "\(timeIntervalSince1970)"
    }
}
