//
//  State.swift
//  RickAndMortyApp
//
//  Created by Syed Asim Najam on 23/09/2026.
//

enum LoadingState<T: Equatable>: Equatable {
    case idle
    case loading
    case loaded(T)
    case failed(String)
}
