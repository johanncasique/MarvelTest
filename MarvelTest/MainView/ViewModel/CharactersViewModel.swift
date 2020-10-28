//
//  MainCharactersViewModel.swift
//  MarvelTest
//
//  Created by johann casique on 26/10/20.
//

import Foundation

class CharactersViewModel: CharactersViewModelProtocol {

    var characters: [Character]?
    var viewState: ViewState<CharactersViewState>?
    weak var delegate: CharacterViewModelViewDelegate?
    var coordinatorDelagate: CharactersCoordinatorDelegate?
    var pagination: CharacterPagination?
    
    var numberOfrows: Int? {
        return characters?.count ?? 0
    }

    func viewDidLoad() {
    
        updateViewState(.loading)
        characters = [Character]()
        pagination = defaultPagination()
        guard let pagination = pagination else {
            return
        }

        CharactersUseCase().request(with: pagination) { [weak self] response in
            switch response {
            case .success(let characters):
                DispatchQueue.main.async {
                    self?.pagination = characters.pagination
                    self?.characters = characters.results
                    self?.updateViewState(.showData)
                }
            case .failure(let error):
                print(error)
                self?.updateViewState(.error)
            }
        }
    }
    
    func newPage() {
        guard var pagination = pagination, let countPagination = pagination.count else {
            return
        }
        
        if countPagination > 0, let characters = self.characters {
            pagination.offset += characters.count + 1
            CharactersUseCase().request(with: pagination) { [weak self] response in
                switch response {
                case .success(let characters):
                    DispatchQueue.main.async {
                        self?.pagination = characters.pagination
                        self?.characters? += characters.results
                        self?.updateViewState(.showData)
                    }
                case .failure(let error):
                    print(error)
                    self?.updateViewState(.error)
                }
            }
        }
    }
    
    func hasMoreData() -> Bool {
        guard let pagination = pagination else {
            return false
        }
        
        return pagination.hasMoreData
    }
    
    private func defaultPagination() -> CharacterPagination {
        CharacterPagination(offset: 0, limit: 20)
    }
    
    func getModel(from index: IndexPath) -> CharacterTableViewCellViewModel? {
        guard let model = characters?[index.row] else {
            return nil
        }
        let viewModel = CharacterTableViewCellViewModel(imageURL: model.imageURL, name: model.name, description: model.description ?? "")
        return viewModel
    }
    
    func updateViewState(_ state: CharactersViewState) {
        if viewState == nil {
            viewState = ViewState(state: state)
        } else {
            viewState?.state = state
        }
        delegate?.viewState(state)
    }
    
    func didSelecteditem(at index: IndexPath) {
        guard let character = characters?[index.row] else {
            assertionFailure("getting character failed")
            return
        }
        coordinatorDelagate?.openDetail(for: character)
    }
}
