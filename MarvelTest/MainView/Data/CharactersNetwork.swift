//
//  CharactersNetwork.swift
//  MarvelTest
//
//  Created by johann casique on 7/4/21.
//

import Foundation
import MarvelData

struct CharactersNetwork: JSONAPIRequest, DomainMapeable {
    
    typealias APIResponse = DataCharacterDTO
    
    var decoder: JSONDecoder {
        return JSONDecoder()
    }
    
    var path: String {
        return "characters"
    }
    
    func generateQueryItems() -> [URLQueryItem] {
        let pagination = CharacterPagination(offset: 0, limit: 20, total: nil, count: nil)
        return [URLQueryItem(name:"offset", value:"\(pagination.offset)"),
                URLQueryItem(name: "limit", value: "\(pagination.limit)")]
    }
    
    static func convert(_ response: DataCharacterDTO) -> Result<CharactersDomainModel, Error> {
        return .success(CharactersDomainModel(offset: response.data.offset,
                                              limit: response.data.limit,
                                              total: response.data.total, count: response.data.count,
                                              results: response.data.results))
    }
}
