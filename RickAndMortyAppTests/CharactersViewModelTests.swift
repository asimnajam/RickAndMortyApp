//
//  CharactersViewModelTests.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import Foundation
import Testing

@testable import RickAndMortyApp

@Suite("CharactersViewModelTests")
@MainActor
struct CharactersViewModelTests {
    @Test("Start with the idle state")
    func startIdle() {
        let repository = MockCharactersRepository(
            response: .success(
                CharactersPage(
                    characters: [],
                    nextPage: nil
                )
            )
        )
        let remoteImagePipeline = MockRemoteImagePipeline(response: .success(Data()))
        let sut = CharactersViewModel(
            repository: repository,
            remoteImagePipeline: remoteImagePipeline
        )
        
        #expect(sut.state == .idle)
    }
    
    @Test("Loads characters successfully")
    func loadCharactersSuccessfully() async {
        let expectedCharacters = [
            Character(
                id: "1",
                name: "Rick Sanchez",
                status: "Alive",
                species: "Human",
                imageURL: URL(
                    string: "https://example.com/rick.jpeg"
                )
            ),
            Character(
                id: "2",
                name: "Morty Smith",
                status: "Alive",
                species: "Human",
                imageURL: URL(
                    string: "https://example.com/morty.jpeg"
                )
            )
        ]
        let repository = MockCharactersRepository(
            response: .success(
                CharactersPage(
                    characters: expectedCharacters,
                    nextPage: nil
                )
            )
        )
        let remoteImagePipeline = MockRemoteImagePipeline(response: .success(Data()))
        let sut = CharactersViewModel(
            repository: repository,
            remoteImagePipeline: remoteImagePipeline
        )
        await sut.load()
        
        #expect(
            sut.state == .loaded(expectedCharacters)
        )
        
        let requestedPages = await repository.requestedPages()
        
        #expect(
            requestedPages == [1]
        )
    }
    
    @Test("handle empty response")
    func handleEmptyResponse() async {
        let repository = MockCharactersRepository(
            response: .success(
                CharactersPage(
                    characters: [],
                    nextPage: nil
                )
            )
        )
        let remoteImagePipeline = MockRemoteImagePipeline(response: .success(Data()))
        let sut = CharactersViewModel(
            repository: repository,
            remoteImagePipeline: remoteImagePipeline
        )
        await sut.load()
        
        #expect(
            sut.state == .loaded([])
        )
    }
    
    @Test("Moves into the failed state")
    func handlesFailure() async {
        let repository = MockCharactersRepository(
            response: .failure
        )
        let remoteImagePipeline = MockRemoteImagePipeline(response: .failure)
        let sut = CharactersViewModel(
            repository: repository,
            remoteImagePipeline: remoteImagePipeline
        )
        await sut.load()
        
        #expect(
            sut.state == .failed("Stub failure")
        )
    }
}
