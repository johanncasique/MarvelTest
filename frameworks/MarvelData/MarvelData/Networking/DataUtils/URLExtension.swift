//
//  URLExtension.swift
//  MarvelData
//
//  Created by johann casique on 27/10/20.
//

import Foundation

extension URL {
    func appendingQueryParameters(_ parameters: [URLQueryItem]) -> URL {
        var urlComponent = URLComponents(url: self, resolvingAgainstBaseURL: true)
        var queryItems = urlComponent?.queryItems
        queryItems?.append(contentsOf: parameters)
        urlComponent?.queryItems = queryItems
        
        guard let url = urlComponent?.url else {
            fatalError("Failed building querycomponents")
        }
        return url
    }
}
