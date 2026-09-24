//
//  ApolloClientFactory.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import Apollo
import Foundation

enum ApolloClientFactory {
    static func makeClient() -> ApolloClient {
        ApolloClient(
            url: URL(string: "https://rickandmortyapi.com/graphql")!
        )
    }
}
