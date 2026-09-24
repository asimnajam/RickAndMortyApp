//
//  CharacterRowView.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import SwiftUI

struct CharacterRowView: View {
    let character: Character
    let remoteImagePipeline: any RemoteImagePipeline

    var body: some View {
        HStack(alignment: .top) {
            RemoteImageView(url: character.imageURL, imagePipeline: remoteImagePipeline)
                .frame(width: 100)

            Spacer()
            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.headline)

                Text(character.species)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 5) {
                    Circle()
                        .fill(character.statusColor)
                        .frame(width: 8, height: 8)

                    Text(character.status)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(18)
        .background(.thinMaterial, in: .rect(cornerRadius: 28))
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .stroke(.white.opacity(0.45), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.10), radius: 18, y: 10)
    }
}

struct CharacterItemView: View {
    let character: Character
    let remoteImagePipeline: any RemoteImagePipeline

    var body: some View {
        HStack(alignment: .top) {
            RemoteImageView(url: character.imageURL, imagePipeline: remoteImagePipeline)
                .frame(width: 100)

            Spacer()
            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.headline)

                Text(character.species)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 5) {
                    Circle()
                        .fill(character.statusColor)
                        .frame(width: 8, height: 8)

                    Text(character.status)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(18)
        .background(.thinMaterial, in: .rect(cornerRadius: 28))
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .stroke(.white.opacity(0.45), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.10), radius: 18, y: 10)
    }

}

struct CharacterGridItemView: View {
    let character: Character
    let remoteImagePipeline: any RemoteImagePipeline

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RemoteImageView(url: character.imageURL, imagePipeline: remoteImagePipeline)
                .frame(maxWidth: .infinity)
                .clipped()

            Text(character.name)
                .font(.headline)
                .lineLimit(1)

            Text(character.species)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Label(character.status, systemImage: "circle.fill")
                .font(.caption)
                .foregroundStyle(.green)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(.thinMaterial)
        .clipShape(.rect(cornerRadius: 16))
    }
}

extension Character {
    /// Returns the corresponding status indicator color.
    var statusColor: Color {
        switch status.lowercased() {
        case "alive":
            .green
        case "dead":
            .red
        default:
            .gray
        }
    }
}
