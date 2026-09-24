//
//  CharacterDetails.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import Foundation

struct CharacterDetails: Equatable, Sendable {
    let id: String
    let name: String
    let status: String
    let species: String
    let gender: String
    let imageURL: URL?
    let originName: String
    let locationName: String
    let episodes: [EpisodeSummary]
}

struct EpisodeSummary: Equatable, Identifiable, Sendable {
    let id: String
    let name: String
    let code: String
}
