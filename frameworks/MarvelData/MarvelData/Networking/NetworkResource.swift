//
//  NetworkResource.swift
//  MarvelData
//
//  Created by johann casique on 26/10/20.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
}

public protocol APIRequest {
    associatedtype APIResponse
    
    var path: String { get }
    var method: HTTPMethod { get }
    
    func generateBody() -> Data?
    func generateHeaders() -> [String: String]
    func generateQueryItems() -> [URLQueryItem]
    func generateURLRequest(_ baseURL: URL) -> URLRequest
    
    func accept(_ response: HTTPURLResponse) -> Bool
    func parse(_ response: HTTPURLResponse, data: Data?) -> Result<APIResponse, Error>
    func error(_ response: HTTPURLResponse, data: Data?, error: Error?) -> Result<APIResponse, Error>
}

public protocol APIClient {
    func send<T: APIRequest>(_ request: T, completion: @escaping (Result<T.APIResponse, Error>) -> Void)
}

// TODO: create file
public protocol NetworkLoggerProtocol {
    func showLog(_ request: URLRequest)
    func showLog(data: Data?, response: URLResponse?, error: Error?)
}

// TODO: create file
public protocol NetworkRecorderProtocol {
    func record<T: APIRequest>(request: T, data: Data?)
}

//TODO: create file
public extension NSError {
    static let undefinedError = NSError(domain: "Networking", code: -600, userInfo: nil)
    static let emptyResponse = NSError(domain: "Empty Response", code: -601, userInfo: nil)
}
public class MarvelClient: APIClient {

    private let baseURL: URL
    private let session: URLSession
    private let clientHeaders: () -> [String: String]
    private let systemErrorHandler: ((Error?) -> Error)?
    private let responseErrorHandler: ((HTTPURLResponse) -> Error)?
    private let logger: NetworkLoggerProtocol
    private let recorder: NetworkRecorderProtocol?
    private let responseQueue: DispatchQueue
    
    public init(baseURL: URL,
                session: URLSession = URLSession(configuration: URLSessionConfiguration.default),
                clientHeaders: @escaping () -> [String : String] = {[:]},
                systemErrorHandler: ((Error?) -> Error)? = nil,
                responseErrorHandler: ((HTTPURLResponse) -> Error)? = nil,
                logger: NetworkLoggerProtocol,
                recorder: NetworkRecorderProtocol? = nil, responseQueue: DispatchQueue = .main) {
        self.baseURL = baseURL
        self.session = session
        self.clientHeaders = clientHeaders
        self.systemErrorHandler = systemErrorHandler
        self.responseErrorHandler = responseErrorHandler
        self.logger = logger
        self.recorder = recorder
        self.responseQueue = responseQueue
    }
    
    public func send<T>(_ request: T, completion: @escaping (Result<T.APIResponse, Error>) -> Void) where T : APIRequest {
        let endpoint = urlRequest(for: request)
        logger.showLog(endpoint)
        let task = session.dataTask(with: endpoint) { [weak self] (data, response, error) in
            guard let self = self else { return }
            self.logger.showLog(data: data, response: response, error: error)
            let result = self.handleResponse(request, data: data, response: response, error: error)
            self.responseQueue.async {
                completion(result)
            }
        }
        task.resume()
    }
    
    public func urlRequest<T: APIRequest>(for request: T) -> URLRequest {
        var urlRequest = request.generateURLRequest(baseURL)
        clientHeaders().forEach { (key, value) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        return urlRequest
    }
    
    public func handleResponse<T: APIRequest>(_ request: T, data: Data?, response: URLResponse?, error: Error?) -> Result<T.APIResponse, Error> {
        if let systemError = systemErrorHandler?(error) ?? error {
            return .failure(systemError)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure("Invalid response" as! Error)
        }
        
        if request.accept(httpResponse) {
            if let recorder = recorder {
                recorder.record(request: request, data: data)
            }
            return request.parse(httpResponse, data: data)
        } else {
            let result = request.error(httpResponse, data: data, error: error)
            switch result {
            case .success:
                return result
            case .failure(let resultError):
                if let nsError = resultError as NSError?,
                   nsError == NSError.undefinedError {
                    let globalError = responseErrorHandler?(httpResponse) ?? resultError
                    return .failure(globalError)
                } else {
                    return result
                }
                
            }
        }
    }
}

public extension APIRequest {
    var method: HTTPMethod { return .get }
    
    func generateBody() -> Data? {
        return nil
    }
    
    func generateHeaders() -> [String: String] {
        return [:]
    }
    
    func generateQueryItems() -> [URLQueryItem] {
        return []
    }
    func generateURLRequest(_ baseURL: URL) -> URLRequest {
        var urlRequest = appendURLRequest(baseURL)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = generateBody()
        urlRequest.allHTTPHeaderFields = generateHeaders()
        return urlRequest
    }
    
    func accept(_ response: HTTPURLResponse) -> Bool {
        return 200..<300 ~= response.statusCode
    }
    
    func error(_ response: HTTPURLResponse, data: Data?, error: Error?) -> Result<APIResponse, Error> {
        guard let sessionError = error else {
            return .failure(NSError.undefinedError)
        }
        return .failure(sessionError)
    }
    
    private func appendURLRequest(_ baseURL: URL) -> URLRequest {
        
        guard let url = URL(string: path, relativeTo: baseURL),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            fatalError("Bad resource namd \(path)")
        }
        
        let customQueryItem = generateQueryItems()
        components.queryItems = customQueryItem.isEmpty ? nil : customQueryItem
        guard let finalUrl = components.url else { fatalError("Bad URLComponents construction") }
        return URLRequest(url: finalUrl)
    }
}

// TODO: create file
public protocol JSONAPIRequest: APIRequest {
    var decoder: JSONDecoder { get }
}

public extension JSONAPIRequest where APIResponse: Decodable {
    public func parse(_ response: HTTPURLResponse, data: Data?) -> Result<APIResponse, Error> {
        guard let responseData = data else {
            return .failure(NSError.emptyResponse)
        }
        
        do {
            let responseObject = try decoder.decode(APIResponse.self, from: responseData)
            return .success(responseObject)
        } catch {
            return .failure(error)
        }
    }
}

// TODO: create file repository
public protocol DomainMapeable: APIRequest {
    associatedtype Domain
    static func convert(_ response: APIResponse) -> Result<Domain, Error>
}

public class Repository<Domain> {
    let client: APIClient
    
    public init(_ client: APIClient) {
        self.client = client
    }
    
    public func fetch<Request>(_ request: Request, completion: @escaping (Result<Domain, Error>) -> Void) where Request: DomainMapeable, Request.Domain == Domain {
        client.send(request) { completion($0.flatMap(Request.convert)) }
    }
}


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
