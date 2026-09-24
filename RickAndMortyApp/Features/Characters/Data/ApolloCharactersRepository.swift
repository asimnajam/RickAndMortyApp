//
//  ApolloCharactersRepository.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import Apollo
import Foundation
import RickAndMortyAPI

final class ApolloCharactersRepository {
    let client: ApolloClient

    init(client: ApolloClient) {
        self.client = client
    }
}

extension ApolloCharactersRepository: CharactersRepository {
    @concurrent
    func fetchCharacters(page: Int) async throws -> CharactersPage {
        do {
            let response = try await client.fetch(query: CharactersQuery(page: Int32(page)))

            if let errors = response.errors, !errors.isEmpty {
                throw RepositoryError.graphQL(errors.map { $0.localizedDescription })
            }

            let characters = response.data?.characters?.results?.compactMap { result -> Character? in
                guard let result,
                      let id = result.id,
                      let name = result.name else {
                    return nil
                }
                return Character(
                    id: id,
                    name: name,
                    status: result.status ?? "Unknown",
                    species: result.species ?? "Unknown",
                    imageURL: URL(string: result.image ?? ""))
            }

            return CharactersPage(
                characters: characters ?? [],
                nextPage: response.data?.characters?.info?.next)
        } catch {
            throw error
        }
    }

    @concurrent
    func fetchCharacters(id: String) async throws -> CharacterDetails {
        let response = try await client.fetch(query: CharacterDetailsQuery(id: id))

        if let errors = response.errors {
            throw RepositoryError.graphQL(errors.map { $0.localizedDescription })
        }

        guard let character = response.data?.character else { throw RepositoryError.missingCharacter }
        guard let id = character.id else { throw RepositoryError.missingID }

        return CharacterDetails(
            id: id,
            name: character.name ?? "",
            status: character.status ?? "",
            species: character.species ?? "",
            gender: character.gender ?? "",
            imageURL: character.image.flatMap { URL(string: $0) },
            originName: character.origin?.name ?? "",
            locationName: character.location?.name ?? "",
            episodes: character.episode.compactMap { episode in
                guard let episode, let id = episode.id else {
                    return nil
                }

                return EpisodeSummary(
                    id: id,
                    name: episode.name ?? "Unknown",
                    code: episode.episode ?? "Unknown")
            })
    }
}

enum RepositoryError: LocalizedError {
    case graphQL([String])
    case missingCharacter
    case missingID

    var errorDescription: String? {
        switch self {
        case .graphQL(let messages):
            messages.joined(separator: "\n")
        case .missingCharacter:
            "Missing Character"
        case .missingID:
            "Missing ID"
        }
    }
}
