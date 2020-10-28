//
//  ViewState.swift
//  MarvelTest
//
//  Created by johann casique on 25/10/20.
//

import Foundation

protocol ViewStateProtocol { }

struct ViewState<T> where T: ViewStateProtocol {
    var state: T
}
