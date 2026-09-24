//
//  CharactersViewModel.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import Foundation
internal import Combine
import SwiftUI

@MainActor
final class CharactersViewModel: ObservableObject {
    // Pagination
    @Published private(set) var nextPage: Int? = 1
    @Published private(set) var isLoadingNextPage = false
    @Published private(set) var paginationError: String?
    
    @Published private(set) var state: LoadingState<[Character]> = .idle

    
    
    let repository: CharactersRepository
    let remoteImagePipeline: RemoteImagePipeline

    init(repository: CharactersRepository, remoteImagePipeline: RemoteImagePipeline) {
        self.repository = repository
        self.remoteImagePipeline = remoteImagePipeline
    }
    
    func load() async {
        switch state {
        case .idle, .failed:
            break
        case .loading, .loaded:
            return
        }
        
        state = .loading

        do {
            let page = try await repository.fetchCharacters(page: 1)
            self.nextPage = page.nextPage
            state = .loaded(page.characters)
            
        } catch is CancellationError {
            state = .idle
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
    
    func loadCharactersIfNeeded() async {
        guard case .loaded(let currentCharacters) = state,
              let nextPage,
              !isLoadingNextPage else {
            return
        }
        
        isLoadingNextPage = true
        paginationError = nil
        
        defer {
            isLoadingNextPage = false
        }
        
        do {
            let page = try await repository.fetchCharacters(page: nextPage)
            
            state = .loaded(currentCharacters + page.characters)
            isLoadingNextPage = false
            self.nextPage = page.nextPage
        } catch is CancellationError {
            isLoadingNextPage = false
        } catch {
            paginationError = error.localizedDescription
            isLoadingNextPage = false
        }
        
        await load()
    }
}
