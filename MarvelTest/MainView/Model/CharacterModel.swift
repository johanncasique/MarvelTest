//
//  CharacterModel.swift
//  MarvelTest
//
//  Created by johann casique on 26/10/20.
//

import Foundation

struct CharactersDomainModel {
    let pagination: PaginationDomainModel
    let results: [CharacterDomainModel]
    
    internal init(offset: Int, limit: Int, total: Int? = nil, count: Int? = nil, results: [Character]) {
        pagination = PaginationDomainModel(offset: offset, limit: limit, total: total, count: count)
        self.results = results.map {  return CharacterDomainModel(id: $0.id,
                                                              name: $0.name,
                                                              description: $0.description,
                                                              modified: $0.modified,
                                                              thumbnail: CharacterThumbnailDomainModel(path: $0.thumbnail.path,
                                                                                                       extension: $0.thumbnail.extension)) }
    }
}

struct CharacterDomainModel {
    let id: Int
    let name: String
    let description: String?
    let modified: String?
    let thumbnail: CharacterThumbnailDomainModel
    
    var imageURL: URL? {
        return URL(string: "\(thumbnail.path).\(thumbnail.extension)")
    }
}

struct CharacterThumbnailDomainModel {
    let path: String
    let `extension`: String
}

struct PaginationDomainModel {
    var offset, limit: Int
    var total, count: Int?
}
