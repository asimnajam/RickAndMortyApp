//
//  FeedImagePipeline.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import Foundation

protocol RemoteImagePipeline {
    func imageData(url: URL) async throws -> Data
}

actor DefaultRemoteImagePipeline {
    enum APIError: Error, Sendable {
        case invalidURL
        case invalidResponse
        case unsuccessfulResponse(
            statusCode: Int,
            data: Data)
    }

    let session: URLSession
    let cache = NSCache<NSURL, NSData>()
    var inFLightTask = [URL: Task<Data, Error>]()

    init(session: URLSession = .shared) {
        self.session = session
    }

    private func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.httpMaximumConnectionsPerHost = 6
        configuration.urlCache = URLCache(
            memoryCapacity: 24 * 1024 * 1024,
            diskCapacity: 160 * 1024 * 1024,
            diskPath: "InterviewNewsFeedImages")

        return URLSession(configuration: configuration)
    }
}

extension DefaultRemoteImagePipeline: RemoteImagePipeline {
    func imageData(url: URL) async throws -> Data {
        if let cacheData = cache.object(forKey: url as NSURL) {
            return cacheData as Data
        }

        if let inFLightTask = inFLightTask[url] {
            return try await inFLightTask.value
        }

        let session = makeSession()

        let task = Task<Data, Error> {
            let request = URLRequest(
                url: url,
                cachePolicy: .returnCacheDataElseLoad,
                timeoutInterval: 30)

            let (data, response) = try await session.data(for: request)
            try Task.checkCancellation()

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }

            return data
        }

        inFLightTask[url] = task

        do {
            let data = try await task.value
            cache.setObject(data as NSData, forKey: url as NSURL, cost: data.count)
            inFLightTask[url] = nil
            return data
        } catch {
            throw error
        }
    }
}
