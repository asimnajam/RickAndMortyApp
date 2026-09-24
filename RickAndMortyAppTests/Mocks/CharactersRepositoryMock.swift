//
//  CharactersRepositoryMock.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import XCTest
@testable import RickAndMortyApp

actor MockCharactersRepository: CharactersRepository {
    enum Response: Sendable {
        case success(CharactersPage)
        case failure
    }
    
    enum RepositoryStubError: LocalizedError, Sendable {
        case failed

        var errorDescription: String? {
            "Stub failure"
        }
    }
    private let response: Response
    private var requestPages: [Int] = []
    
    init(response: Response) {
        self.response = response
    }
    
    func fetchCharacters(page: Int) async throws -> RickAndMortyApp.CharactersPage {
        requestPages.append(page)
        
        switch response {
        case .success(let charactersPage):
            return charactersPage
        case .failure:
            throw RepositoryStubError.failed
        }
    }
    
    func requestedPages() -> [Int] {
        requestPages
    }
}


