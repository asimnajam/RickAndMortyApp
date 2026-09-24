//
//  AppContainer.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

final class AppContainer {
    let charactersRepository: any CharactersRepository
    let remoteImagePipline: any RemoteImagePipeline
    
    init() {
        charactersRepository = ApolloCharactersRepository(
            client: ApolloClientFactory.makeClient()
        )
        remoteImagePipline = DefaultRemoteImagePipeline()
    }
}
