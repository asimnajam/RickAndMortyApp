//
//  RemoteImagePipeline.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import Foundation
@testable import RickAndMortyApp

actor MockRemoteImagePipeline: RemoteImagePipeline {
    enum Response: Sendable {
        case success(Data)
        case failure
    }
    
    enum RemoteImagePipelineError: Error {
        case imageFetchFailed
    }
    
    private let response: Response
    private var requestUrls: [URL] = []
    
    init(response: Response) {
        self.response = response
    }
    
    func imageData(url: URL) async throws -> Data {
        switch response {
        case .success(let data):
            return data
        case .failure:
            throw RemoteImagePipelineError.imageFetchFailed
        }
    }
    
    func requestedUrls() -> [URL] {
        requestUrls
    }
}
