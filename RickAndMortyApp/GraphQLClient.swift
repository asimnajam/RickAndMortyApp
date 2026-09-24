//
//  GraphQLClient.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import Apollo
import Foundation

final class GraphQLClient {
    static let shared = GraphQLClient()

    let apollo: ApolloClient

    private init() {
        apollo = ApolloClient(
            url: URL(string: "https://rickandmortyapi.com/graphql")!
        )
    }
}
