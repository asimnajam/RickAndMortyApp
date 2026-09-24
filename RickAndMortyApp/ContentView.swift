//
//  ContentView.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import Apollo
import RickAndMortyAPI
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("loading charactoer")
            .task {
                await loadCharacters()
            }
    }

    func loadCharacters() async {
        do {
            let response = try await GraphQLClient.shared.apollo.fetch(
                query: CharactersQuery(page: 1))

            if let errors = response.errors {
                errors.forEach {
                    print("GraphQL error:", $0.localizedDescription)
                }
            }

            let characters =
                response.data?.characters?.results?
                    .compactMap { $0 } ?? []

            for character in characters {
                print(character.name ?? "Unknown")
            }
        } catch {
            print("Network error:", error)
        }
    }
}

#Preview {
    ContentView()
}
