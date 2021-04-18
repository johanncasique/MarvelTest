//
//  CharactersRepository.swift
//  MarvelTest
//
//  Created by johann casique on 7/4/21.
//

import Foundation
import MarvelData

struct CharactersRepository {
    let repository: Repository<CharactersDomainModel>
    
    func fetch(_ completion: @escaping ((Result<CharactersDomainModel, Error>) -> Void)) {
        repository.fetch(CharactersNetwork()) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let domainModel):
                completion(.success(domainModel))
            }
        }
    }
}
