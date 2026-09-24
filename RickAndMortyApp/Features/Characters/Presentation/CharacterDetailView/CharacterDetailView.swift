//
//  CharacterDetailView.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 24/09/2026.
//

import SwiftUI

struct CharacterDetailView: View {
    @StateObject private var viewModel: CharacterDetailViewModel

    init(viewModel: CharacterDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Loading character…")

            case .loaded(let character):
                content(character)

            case .failed(let message):
                ContentUnavailableView {
                    Label("Unable to Load", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(message)
                } actions: {
                    Button("Try Again") {
                        Task {
                            await viewModel.retry()
                        }
                    }
                }
            }
        }
        .navigationTitle("Character Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
    }

    private func content(_ character: CharacterDetails) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RemoteImageView(url: character.imageURL, imagePipeline: viewModel.remoteImagePipeline)
                    .scaledToFit()

                Text(character.name)
                    .font(.largeTitle.bold())

                LabeledContent("Status", value: character.status)
                LabeledContent("Species", value: character.species)
                LabeledContent("Gender", value: character.gender)
                LabeledContent("Origin", value: character.originName)
                LabeledContent("Location", value: character.locationName)

                Divider()

                Text("Episodes")
                    .font(.title2.bold())

                ForEach(character.episodes) { episode in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(episode.name)
                            .font(.headline)

                        Text(episode.code)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
        }
    }
}
