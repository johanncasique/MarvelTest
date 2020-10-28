//
//  CharactersViewModelProtocol.swift
//  MarvelTest
//
//  Created by johann casique on 26/10/20.
//

import Foundation

enum CharactersViewState: ViewStateProtocol {
    case loading
    case error
    case showData
    case emptyData
}

protocol CharactersViewModelProtocol: AnyObject {
    var characters: [Character]? { get }
    var numberOfrows: Int? { get }
    func viewDidLoad()
    func getModel(from index: IndexPath) -> CharacterTableViewCellViewModel?
    func newPage()
    func hasMoreData() -> Bool
    func didSelecteditem(at index: IndexPath)
}

protocol CharacterViewModelViewDelegate: AnyObject {
    func viewState(_ state: CharactersViewState)
}
