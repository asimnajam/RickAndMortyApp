//
//  CharacterDetailViewModel.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import Foundation
internal import Combine

import Apollo
import RickAndMortyAPI

final class CharacterDetailViewModel: ObservableObject {
    @Published private(set) var state: LoadingState<CharacterDetails> = .idle

    private let repository: CharactersRepository
    let remoteImagePipeline: RemoteImagePipeline
    private let characterID: String
    
    init(repository: CharactersRepository, remoteImagePipeline: RemoteImagePipeline, characterID: String) {
        self.repository = repository
        self.remoteImagePipeline = remoteImagePipeline
        self.characterID = characterID
    }
    
    func load() async {
        guard state != .loading else { return }
        state = .loading
        
        do {
            let detail = try await repository.fetchCharacters(id: characterID)
            state = .loaded(detail)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
    
    func retry() async {
        state = .idle
        await load()
    }
}
