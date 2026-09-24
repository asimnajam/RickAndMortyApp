//
//  RickAndMortyAppApp.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import SwiftUI

@main
struct RickAndMortyAppApp: App {
    let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            CharactersView(
                repository: container.charactersRepository,
                remoteImagePipeline: container.remoteImagePipline)
        }
    }
}
