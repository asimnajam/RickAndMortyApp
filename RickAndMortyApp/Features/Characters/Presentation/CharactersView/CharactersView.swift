//
//  CharactersView.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import SwiftUI

enum AppRoute: Hashable {
    case characterDetail(id: String)
    case settings
}

@MainActor
struct CharactersView: View {
    @StateObject private var viewModel: CharactersViewModel
    @State private var path: [AppRoute] = []
    
    @AppStorage("characterLayout")
    private var layout: CharacterLayout = .list
    
    private let columnsOne = [
        GridItem(.adaptive(minimum: 160), spacing: 12)
    ]
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    init(repository: CharactersRepository, remoteImagePipeline: RemoteImagePipeline) {
        _viewModel = StateObject(wrappedValue: CharactersViewModel(
            repository: repository,
            remoteImagePipeline: remoteImagePipeline)
        )
    }

    var body: some View {
        NavigationStack(path: $path) {
            content
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            layout = layout == .list ? .grid : .list
                        } label: {
                            Image(
                                systemName: layout == .list
                                    ? "square.grid.2x2"
                                    : "list.bullet"
                            )
                        }
                        .accessibilityLabel(
                            layout == .list ? "Show grid" : "Show list"
                        )
                    }
                }
                .navigationTitle("Characters")
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .characterDetail(let id):
                        CharacterDetailView(
                            viewModel: CharacterDetailViewModel(
                                repository: viewModel.repository,
                                remoteImagePipeline: viewModel.remoteImagePipeline,
                                characterID: id
                            )
                        )
                    case .settings:
                        SettingsView()
                    }
                }
        }
        .task {
            await viewModel.load()
        }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading Character..")
        case .loaded(let characters):
            listView(characters)
        case .failed(let message):
            errorView(message: message)
        }
    }
    
    @ViewBuilder
    func characterCollection(_ characters: [Character]) -> some View {
        switch layout {
        case .grid:
            LazyVGrid(columns: columns) {
                ForEach(characters, id: \.id) { character in
                    NavigationLink(value: AppRoute.characterDetail(id: character.id)) {
                        CharacterGridItemView(
                            character: character,
                            remoteImagePipeline: viewModel.remoteImagePipeline
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        case .list:
            LazyVStack {
                ForEach(characters, id: \.id) { character in
                    NavigationLink(value: AppRoute.characterDetail(id: character.id)) {
                        CharacterRowView(
                            character: character,
                            remoteImagePipeline: viewModel.remoteImagePipeline
                        )
                    }
                    .buttonStyle(.plain)
                    
                    
                }
                Color.clear
                    .frame(height: 1)
                    .task(id: viewModel.nextPage) {
                        await viewModel.loadCharactersIfNeeded()
                    }
            }
        }
    }
    
    func listView(_ characters: [Character]) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                characterCollection(characters)
                paginationTrigger()
            }
//            LazyVStack {
//                ForEach(characters, id: \.id) { character in
//                    NavigationLink(value: AppRoute.characterDetail(id: character.id)) {
//                        CharacterRowView(
//                            character: character,
//                            remoteImagePipeline: viewModel.remoteImagePipeline
//                        )
//                    }
//                    .buttonStyle(.plain)
//                    
//                    
//                }
//                Color.clear
//                    .frame(height: 1)
//                    .task(id: viewModel.nextPage) {
//                        await viewModel.loadCharactersIfNeeded()
//                    }
//            }
        }
    }
    
    private func paginationTrigger() -> some View {
        Color.clear
            .frame(height: 1)
            .task(id: viewModel.nextPage) {
                await viewModel.loadCharactersIfNeeded()
            }
    }
    
    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.slash")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            
            Text("No Characters")
                .font(.headline)
            
            Text("The API returned an empty result.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.largeTitle)
                .foregroundStyle(.red)
            
            Text("Unable to Load Characters")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                Task {
                    await viewModel.load()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct ProfileView: View {
    let username: String
    
    // Pass the binding if child views need to navigate programmatically
    @Binding var path: [AppRoute]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome, \(username)!")
                .font(.title)
            
            Button("View Privacy Policy") {
                path.append(.settings)
            }
            
            Button("Pop to Root", role: .destructive) {
                // Emptying the array instantly returns the user to the home screen
                path.removeAll()
            }
        }
        .navigationTitle("Profile")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings Dashboard")
            .navigationTitle("Settings")
    }
}
