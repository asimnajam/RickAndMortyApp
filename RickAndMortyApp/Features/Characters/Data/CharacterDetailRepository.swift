//
//  CharacterDetailRepository.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import Apollo
import Foundation
import RickAndMortyAPI

// protocol CharacterDetailRepository {
//    func fetchCharacters(id: Int) async throws -> CharacterDetails
// }

// struct CharacterDetailRepositoryImpl {
//    let client: ApolloClient
//
//    init(client: ApolloClient) {
//        self.client = client
//    }
//
//    func fetchCharacters(id: Int) async throws -> CharacterDetails {
//        let response = try await client.fetch(query: CharacterDetailsQuery(id: "\(id)"))
//
//        if let errors = response.errors {
//            throw RepositoryError.graphQL(errors.map { $0.localizedDescription })
//        }
//
//        guard let character = response.data?.character else { throw CharacterMappingError.missingCharacter }
//        guard let id = character.id else { throw CharacterMappingError.missingID }
//
//        return CharacterDetails(
//            id: id,
//            name: character.name ?? "",
//            status: character.status ?? "",
//            species: character.species ?? "",
//            gender: character.gender ?? "",
//            imageURL: character.image.flatMap { URL(string: $0) },
//            originName: character.origin?.name ?? "",
//            locationName: character.location?.name ?? "",
//            episodes: character.episode.compactMap { episode in
//                guard let episode, let id = episode.id else {
//                    return nil
//                }
//
//                return EpisodeSummary(
//                    id: id,
//                    name: episode.name ?? "Unknown",
//                    code: episode.episode ?? "Unknown"
//                )
//            })
//
//    }
// }

// import Foundation
// import RickAndMortyAPI
//
// enum CharacterMappingError: Error {
//    case missingCharacter
//    case missingID
// }
//
// extension RickAndMortyAPI.CharacterDetailsQuery.Data.Character {
//    func toDomain() throws -> CharacterDetails {
//        guard let id else {
//            throw CharacterMappingError.missingID
//        }
//
//        return CharacterDetails(
//            id: id,
//            name: name ?? "Unknown",
//            status: status ?? "Unknown",
//            species: species ?? "Unknown",
//            gender: gender ?? "Unknown",
//            imageURL: image.flatMap(URL.init(string:)),
//            originName: origin?.name ?? "Unknown",
//            locationName: location?.name ?? "Unknown",
//            episodes: episode.compactMap { episode in
//                guard let episode, let id = episode.id else {
//                    return nil
//                }
//
//                return EpisodeSummary(
//                    id: id,
//                    name: episode.name ?? "Unknown",
//                    code: episode.episode ?? "Unknown"
//                )
//            }
//        )
//    }
// }
