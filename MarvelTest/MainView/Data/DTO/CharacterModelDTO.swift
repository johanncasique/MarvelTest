//
//  CharacterModelDTO.swift
//  MarvelTest
//
//  Created by johann casique on 7/4/21.
//

import Foundation

struct DataCharacterDTO: Decodable {
    let data: Characters
}

struct Characters: Decodable {
    var offset: Int
    var limit: Int
    var total: Int?
    var count: Int?

    let results: [Character]
    var pagination: CharacterPagination {
        return CharacterPagination(offset: offset,
                                   limit: limit,
                                   total: total,
                                   count: count)
    }
}

struct Character: Decodable {
    let id: Int
    let name: String
    let description: String?
    let modified: String?
    let thumbnail: CharacterThumbnail
    
    var imageURL: URL? {
        return URL(string: "\(thumbnail.path).\(thumbnail.extension)")
    }
}

struct CharacterThumbnail: Decodable {
    let path: String
    let `extension`: String
}
