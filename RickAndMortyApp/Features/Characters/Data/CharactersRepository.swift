//
//  CharactersRepository.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import Foundation

protocol CharactersRepository {
    func fetchCharacters(page: Int) async throws -> CharactersPage
    func fetchCharacters(id: String) async throws -> CharacterDetails
}
