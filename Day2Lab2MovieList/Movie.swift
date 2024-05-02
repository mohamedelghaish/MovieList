//
//  Movie.swift
//  Day2Lab2MovieList
//
//  Created by Mohamed Kotb Saied Kotb on 24/04/2024.
//

import Foundation

struct Movie {
    
    let title: String
    let image: Data?
    let releaseYear: Int
    let genre: [String]
    let rating: Double
    let url: String
}






extension Movie {
    init( title: String ,image: Data, releaseYear: Int, genre: String, rating: Double, url: String) {
       
        self.title = title
        self.image = image
        self.releaseYear = releaseYear
        self.genre = genre.components(separatedBy: ", ")
        self.rating = rating
        self.url = url
    }
}
