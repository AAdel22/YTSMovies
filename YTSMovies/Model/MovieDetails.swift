//
//  MovieDetails.swift
//  YTSMovies
//
//  Created by Alaa Adel on 4/26/20.
//  Copyright © 2020 Alaa Adel. All rights reserved.
//

import Foundation

struct MovieDetails {
    
    var id: Int?
    var imagesURLs: [String] = []
    var title: String?
    var rate: Float?
    var genres: [String] = []
    var year: Int?
    var downloadsCount: Int?
    var likesCount: Int?
    var runTime: Int?
    var fullDescription: String?
    var movieURL: String?
    var language: String?
    
    var cast: [Actor]? = []
}
struct Actor {
    var name: String?
    var characterName: String?
    var imgURL: String?
}
