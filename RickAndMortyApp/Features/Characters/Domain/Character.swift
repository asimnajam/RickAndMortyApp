//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

import Foundation

struct Character: Identifiable, Equatable, Sendable {
    let id: String
    let name: String
    let status: String
    let species: String
    let imageURL: URL?
}
