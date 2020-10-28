//
//  DetailViewModel.swift
//  MarvelTest
//
//  Created by johann casique on 27/10/20.
//

import Foundation

protocol CharacterDetailViewModelProtocol: AnyObject{
    var name: String { get }
    var description: String { get }
    var imageURL: URL? { get }
}

class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    private (set)var character: Character
    
    init(_ character: Character) {
        self.character = character
    }
    
    var name: String {
        return character.name
    }
    
    var description: String {
        guard let description = character.description else {
            return "Description unavailable"
        }

        return description.isEmpty ? "Description unavailable" : description
    }
    
    var imageURL: URL? {
        return character.imageURL
    }
}
