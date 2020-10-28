//
//  BackendDatasource.swift
//  MarvelData
//
//  Created by johann casique on 26/10/20.
//

import Foundation

public protocol Parameters {
    
}

public protocol BackendDataSource {
    associatedtype DomainModel
    associatedtype Params: Parameters
    
    func request(with parameters: Params, then handler: @escaping (Result<DomainModel, Error>) -> Void)
}

