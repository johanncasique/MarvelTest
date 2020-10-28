//
//  NetworkResource.swift
//  MarvelData
//
//  Created by johann casique on 26/10/20.
//

import Foundation

public protocol NetworkingResource {
    var endpoint: Endpoint { get }
    var headers: [String: String] { get }
    var acceptedHttpSuccessValue: Range<Int> { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var sessionError: [Int] { get }
    var task: Task { get }
}

public enum Task {
    case requestWithParameters([URLQueryItem])
}

public extension NetworkingResource {
    var cachePolicy: URLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
    
    var acceptedHttpSuccessValue: Range<Int> {
        return 200..<300
    }
    
    var sessionError: [Int] {
        return [401]
    }
}

public typealias Handler = (Result<Response, NetworkingError>) -> Void
protocol NetworkingType {
    associatedtype Resource
    
    func request(_ resource: Resource, using session: URLSession, then handler: @escaping Handler) -> URLSessionDataTask
}

public struct NetworkinRequest<R: NetworkingResource>: NetworkingType {
    
    public init() {}
    
    @discardableResult
    public func request(_ resource: R, using session: URLSession = .shared, then handler: @escaping Handler) -> URLSessionDataTask {
        
        var url = resource.endpoint.url
        if case let .requestWithParameters(parameters) = resource.task {
            url = url.appendingQueryParameters(parameters)
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            let response = Response(urlRequest: URLRequest(url: url),
                                    data: data, httpURLResponse: response as? HTTPURLResponse)
            if let error = error {
                handler(.failure(.underlying(error, response)))
                return
            }
            guard let urlResponse = response.httpURLResponse, resource.acceptedHttpSuccessValue.contains(urlResponse.statusCode) else {
                handler(.failure(.statusCode(response)))
                return
            }
            handler(.success(response))
        }
        task.resume()
        return task
    }
}
