//
//  Endpoint.swift
//  MarvelData
//
//  Created by johann casique on 26/10/20.
//

import Foundation

private enum MarvelKeys {
    static let privateKey = "d7330fec4bdf3f8f1fd63de54cf4367db660a125"
    static let publicKey = "e20a86c200384aa958eef56274e47aef"
}

private enum MarvelQuery: String {
    case apikey
    case hash
    case ts
}

public enum Endpoint {
    case characters
}

extension Endpoint {
   public var url: URL {
        switch self {
        case .characters:
            return buildEndpoint("characters")
        }
    }
    
    private func buildEndpoint(_ endpoint: String) -> URL {
        guard var components = URLComponents(url: .baseURL(with: endpoint), resolvingAgainstBaseURL: true) else {
            fatalError("Something whent wrong trying biulding endpoint")
        }
        
        let timestamp = "\(Date().timestamp)"
        let hashValue = "\(timestamp)\(MarvelKeys.privateKey)\(MarvelKeys.publicKey)".md5
        
        let queryItems =  [
            URLQueryItem(name: MarvelQuery.apikey.rawValue, value: MarvelKeys.publicKey),
            URLQueryItem(name: MarvelQuery.hash.rawValue, value: hashValue),
            URLQueryItem(name: MarvelQuery.ts.rawValue, value: timestamp),
            URLQueryItem(name: "orderBy", value: "name")
        ]
        components.queryItems = queryItems
        
        guard let url = components.url else {
            fatalError("Failed building querycomponents")
        }
        return url
    }
}

extension URL {
    static func baseURL(with endpoint: String) -> URL {
        guard let baseURL = URL(string: endpoint, relativeTo: URL(string: "https://gateway.marvel.com:443/v1/public/")) else {
            fatalError("URL string is invalid")
        }
        return baseURL
    }
}
