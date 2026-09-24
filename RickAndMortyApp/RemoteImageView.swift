//
//  RemoteImageView.swift
//  NewsFeed
//
//  Created by Syed Asim Najam on 18/09/2026.
//

import SwiftUI

//https://www.youtube.com/watch?v=HO1jOqbnkBA&t=3s

private enum RemoteImagePhase {
    case idle
    case loading
    case success(Image)
    case failure
}

struct RemoteImageView<Content, Placeholder>: View where Content: View, Placeholder: View {
    let url: URL?
    let imagePipeline: RemoteImagePipeline

    @ViewBuilder let content: (Image) -> Content
    @ViewBuilder let placeholder: () -> Placeholder

    @State private var phase: RemoteImagePhase = .idle

    init(
        url: URL?,
        imagePipeline: RemoteImagePipeline,
        @ViewBuilder content: @escaping (Image) -> Content = { $0.resizable().scaledToFill() },
        @ViewBuilder placeholder: @escaping () -> Placeholder = {
            ProgressView().tint(.white)
        }
    ) {
        self.url = url
        self.imagePipeline = imagePipeline
        self.content = content
        self.placeholder = placeholder
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.19, green: 0.22, blue: 0.30),
                            Color(red: 0.41, green: 0.48, blue: 0.58)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            currentPhaseView
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .task(id: url) {
            await loadImage()
        }
    }

    @ViewBuilder
    private var currentPhaseView: some View {
        switch phase {
        case .idle, .loading:
            placeholder()
            
        case .success(let image):
            content(image)
            
        case .failure:
            VStack(spacing: 6) {
                Image(systemName: "photo.badge.exclamationmark")
                    .font(.system(size: 20))
                Text("Error")
                    .font(.caption2.weight(.semibold))
            }
            .foregroundStyle(.white)
        }
    }

    @MainActor
    private func loadImage() async {
        guard let url else {
            phase = .failure
            return
        }
        
        phase = .loading
        
        do {
            let data = try await imagePipeline.imageData(url: url)
            try Task.checkCancellation()
            
            guard let image = UIImage(data: data) else {
                phase = .failure
                return
            }
            
            phase = .success(Image(uiImage: image))
        } catch is CancellationError {
            return
        } catch {
            phase = .failure
        }
    }
}
