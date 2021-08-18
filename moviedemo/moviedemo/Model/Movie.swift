//
//  Movie.swift
//  moviedemo
//
//  Created by Customer Support on 7/28/21.
//

import Foundation

struct SearchResponse: Codable {
    let page: Int
    let results: [SearchResult]
    let total_pages: Int64
    let total_results: Int64
}

struct SearchResult: Codable {
    let adult: Bool
    let backdrop_path: String
    let genre_ids: [Int64]
    let id: Int64
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Double
    let poster_path: String
    let release_date: String
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int64
}

