//
//  CharactersUseCase.swift
//  MarvelTest
//
//  Created by johann casique on 26/10/20.
//

import MarvelData

struct CharactersUseCase: BackendDataSource {
    func request(with parameters: CharacterPagination, then handler: @escaping (Result<Characters, Error>) -> Void) {
        NetworkinRequest<CharactersResource>().request(.init(pagination: parameters), using: .shared) { result in
            switch result {
            case .success(let response):
                guard let model = try? response.map(to: CharactersDomainModel.self) else {
                    return
                }
                handler(.success(model.data))
            case .failure: break
            }
        }
    }
    
    typealias DomainModel = Characters
}

struct CharactersResource: NetworkingResource {
    
    let characterPagination: CharacterPagination
    
    var task: Task {
        return .requestWithParameters(characterPagination.parameters)
    }
    
    var endpoint: Endpoint {
        return .characters
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    init(pagination: CharacterPagination) {
        self.characterPagination = pagination
    }
}

struct CharacterPagination: Parameters, Pagination, Encodable  {

    var offset: Int
    var limit: Int
    var total: Int?
    var count: Int?
    var parameters: [URLQueryItem] {
        return [URLQueryItem(name:"offset", value:"\(offset)"),
                URLQueryItem(name: "limit", value: "\(limit)")]
    }
    var hasMoreData: Bool {
        guard let count = self.count else {
            return false
        }
        return count > 0
    }
}

