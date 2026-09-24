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
    @Test
    func `Start with the idle state`() {
        let repository = MockCharactersRepository(
            response: .success(
                CharactersPage(
                    characters: [],
                    nextPage: nil)))
        let remoteImagePipeline = MockRemoteImagePipeline(response: .success(Data()))
        let sut = CharactersViewModel(
            repository: repository,
            remoteImagePipeline: remoteImagePipeline)

        #expect(sut.state == .idle)
    }

    @Test
    func `Loads characters successfully`() async {
        let expectedCharacters = [
            Character(
                id: "1",
                name: "Rick Sanchez",
                status: "Alive",
                species: "Human",
                imageURL: URL(
                    string: "https://example.com/rick.jpeg")),
            Character(
                id: "2",
                name: "Morty Smith",
                status: "Alive",
                species: "Human",
                imageURL: URL(
                    string: "https://example.com/morty.jpeg"))
        ]
        let repository = MockCharactersRepository(
            response: .success(
                CharactersPage(
                    characters: expectedCharacters,
                    nextPage: nil)))
        let remoteImagePipeline = MockRemoteImagePipeline(response: .success(Data()))
        let sut = CharactersViewModel(
            repository: repository,
            remoteImagePipeline: remoteImagePipeline)
        await sut.load()

        #expect(
            sut.state == .loaded(expectedCharacters))

        let requestedPages = await repository.requestedPages()

        #expect(
            requestedPages == [1])
    }

    @Test
    func `handle empty response`() async {
        let repository = MockCharactersRepository(
            response: .success(
                CharactersPage(
                    characters: [],
                    nextPage: nil)))
        let remoteImagePipeline = MockRemoteImagePipeline(response: .success(Data()))
        let sut = CharactersViewModel(
            repository: repository,
            remoteImagePipeline: remoteImagePipeline)
        await sut.load()

        #expect(
            sut.state == .loaded([]))
    }

    @Test
    func `Moves into the failed state`() async {
        let repository = MockCharactersRepository(
            response: .failure)
        let remoteImagePipeline = MockRemoteImagePipeline(response: .failure)
        let sut = CharactersViewModel(
            repository: repository,
            remoteImagePipeline: remoteImagePipeline)
        await sut.load()

        #expect(
            sut.state == .failed("Stub failure"))
    }
}
