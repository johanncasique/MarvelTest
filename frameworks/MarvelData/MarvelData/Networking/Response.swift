//
//  Response.swift
//  MarvelData
//
//  Created by johann casique on 26/10/20.
//

import Foundation

public final class Response: CustomDebugStringConvertible {
    public let urlRequest: URLRequest
    public let data: Data?
    public let httpURLResponse: HTTPURLResponse?
    
    public var description: String {
        return """
        Requested URL: \(urlRequest.url?.absoluteString ?? "nil"),
        Status code \(httpURLResponse?.statusCode ?? -999),
        Data count: \(data?.count ?? -999),
        """
    }
    
    public var debugDescription: String {
        return description
    }
    
    public var prettyJSOnString: String? {
        return data?.prettyJSONString
    }
    
    public var json: Any? {
        return data?.json
    }
    
    public var statusCode: Int {
        return httpURLResponse?.statusCode ?? -999
    }
    
    public init(urlRequest: URLRequest, data: Data?, httpURLResponse: HTTPURLResponse?) {
        self.urlRequest = urlRequest
        self.data = data
        self.httpURLResponse = httpURLResponse
    }
    
    public func map<D: Decodable>(to type: D.Type, decoder: JSONDecoder = JSONDecoder()) throws -> D {
        guard let data = data else { throw NetworkingError.noData(self) }
        
        do {
            return try decoder.decode(type, from: data)
        } catch let error {
            throw NetworkingError.decoding(error, self)
        }
    }
}

public enum NetworkingError: Swift.Error {
    case noData(Response)
    case statusCode(Response)
    case decoding(Swift.Error, Response?)
    case underlying(Swift.Error, Response?)
}

public extension NetworkingError {
    var response: Response? {
        switch self {
        case let .noData(response):
            return response
        case let .statusCode(response):
            return response
        case let .decoding(_, response):
            return response
        case let .underlying(_, response):
            return response
        }
    }
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData:
            return "The request gave no data"
        case .statusCode:
            return "Status code did not fall within given range."
        case .decoding:
            return "Failed to map data to a Decodable Object"
        case let .underlying(error, _):
            return error.localizedDescription
        }
    }
}
