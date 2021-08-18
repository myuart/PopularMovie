//
//  Configuration.swift
//  moviedemo
//
//  Created by Customer Support on 8/16/21.
//

import Foundation

struct ConfigurationResponse: Codable {
    let images: ImageConfig
    let change_keys: [String]
}

struct ImageConfig: Codable {
    let base_url: String
    let secure_base_url : String
    let backdrop_sizes: [String]
    let logo_sizes: [String]
    let poster_sizes: [String]
    let profile_sizes: [String]
    let still_sizes: [String]
}

    
