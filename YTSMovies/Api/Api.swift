//
//  Api.swift
//  YTSMovies
//
//  Created by Alaa Adel on 4/25/20.
//  Copyright © 2020 Alaa Adel. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Api: NSObject {
    
    class func allMovies(page: Int,completion: @escaping (_ error: Error?, _ movies: [MovieList]?)-> Void) {
        let url = "https://yts.mx/api/v2/list_movies.json?page=\(page)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil) .responseJSON { response in
            
            switch response.result {
            case .failure(let error):
                completion(error, nil)
                print(error)
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                guard let dataArr = json["data"]["movies"].array else {
                    completion(nil,nil)
                    return
                }
                
                var movies = [MovieList]()
                
                
                for data in dataArr {
                    guard let data = data.dictionary else {return}
                    let movie = MovieList()
                    movie.id = data["id"]?.int ?? 0
                    
                    movie.title = data["title"]?.string ?? ""
                    movie.titleLong = data["title_long"]?.string ?? ""
                    
                    let genresJson = data["genres"]?.arrayValue
                    var genres: [String] = [String]()
                    for genre in genresJson! {
                        genres.append(genre.stringValue)
                    }
                    
                    movie.genres = genres
                    
                    movie.imgURL = data["small_cover_image"]?.string ?? ""
                    movie.rate = data["rating"]?.float ?? 0
                    
                    movie.moviesCount = json["data"]["movie_count"].int

                    movies.append(movie)
                }
                completion(nil,movies)
            }
        }
    }
    class func filterMovies(page: Int,quality: String,rating: Int,query: String,genre: String,sortBy: String,orderBy: String,completion: @escaping (_ error: Error?, _ movies: [MovieList]?)-> Void) {
        let url = "https://yts.mx/api/v2/list_movies.json?quality=\(quality)&minimum_rating=\(rating)&query_term=\(query)&genre=\(genre)&sort_by=\(sortBy)&order_by=\(orderBy)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil) .responseJSON { response in
            
            switch response.result {
            case .failure(let error):
                completion(error, nil)
                print(error)
            case .success(let value):
                let json = JSON(value)
                //print(json)
                
                guard let dataArr = json["data"]["movies"].array else {
                    completion(nil,nil)
                    return
                }
                
                var movies = [MovieList]()
                
                
                for data in dataArr {
                    guard let data = data.dictionary else {return}
                    let movie = MovieList()
                    movie.id = data["id"]?.int ?? 0
                    
                    movie.title = data["title"]?.string ?? ""
                    movie.titleLong = data["title_long"]?.string ?? ""
                    
                    let genresJson = data["genres"]?.arrayValue
                    var genres: [String] = [String]()
                    for genre in genresJson! {
                        genres.append(genre.stringValue)
                    }
                    
                    movie.genres = genres
                    
                    movie.imgURL = data["small_cover_image"]?.string ?? ""
                    movie.rate = data["rating"]?.float ?? 0
                    
                    movie.moviesCount = json["data"]["movie_count"].int
                    
                    movies.append(movie)
                }
                completion(nil,movies)
            }
        }
    }
    class func searchMovies(page: Int,query: String,completion: @escaping (_ error: Error?, _ movies: [MovieList]?)-> Void) {
        let url = "https://yts.mx/api/v2/list_movies.json?page=\(page)&query_term=\(query)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil) .responseJSON { response in
            
            switch response.result {
            case .failure(let error):
                completion(error, nil)
                print(error)
            case .success(let value):
                let json = JSON(value)
                 print(json)
                
                guard let dataArr = json["data"]["movies"].array else {
                    completion(nil,nil)
                    return
                }
                var movies = [MovieList]()
                for data in dataArr {
                    
                    
                    guard let data = data.dictionary else {return}
                    let movie = MovieList()
                    movie.id = data["id"]?.int ?? 0
                    
                    movie.title = data["title"]?.string ?? ""
                    movie.titleLong = data["title_long"]?.string ?? ""
                    
                    let genresJson = data["genres"]?.arrayValue
                    var genres: [String] = [String]()
                    for genre in genresJson! {
                        genres.append(genre.stringValue)
                    }
                    
                    movie.genres = genres
                    
                    movie.imgURL = data["small_cover_image"]?.string ?? ""
                    movie.rate = data["rating"]?.float ?? 0
                    
                    movies.append(movie)
                }
                completion(nil,movies)
            }
        }
    }
    
    class func movieDetails(movieID: Int,completion: @escaping (_ error: Error?, _ movies: MovieDetails?)-> Void) {
        
        let url = "https://yts.mx/api/v2/movie_details.json?movie_id=\(movieID)&with_images=true&with_cast=true"
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil) .responseJSON { response in
            
            switch response.result {
            case .failure(let error):
                completion(error, nil)
                print(error)
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                if json["data"] != JSON.null {
                    let movieDetails = json["data"]["movie"]
                    
                    
                    // save images to Array
                    var movieImages: [String] = [String]()
                    movieImages.append(movieDetails["medium_cover_image"].stringValue)
                    movieImages.append(movieDetails["medium_screenshot_image1"].stringValue)
                    movieImages.append(movieDetails["medium_screenshot_image2"].stringValue)
                    movieImages.append(movieDetails["medium_screenshot_image3"].stringValue)
                    movieImages.append(movieDetails["background_image"].stringValue)
                    
                    
                    // save genres to array
                    let genresJson = movieDetails["genres"].arrayValue
                    var genres: [String] = [String]()
                    for genre in genresJson {
                        genres.append(genre.stringValue)
                    }
                    
                    // save cast to array
                    let cast = movieDetails["cast"].arrayValue
                    var actors: [Actor] = [Actor]()
                    for actor in cast {
                        let actorObject: Actor = Actor(name: actor["name"].stringValue, characterName: actor["character_name"].stringValue, imgURL: actor["url_small_image"].string ?? "https://www.mearto.com/assets/no-image-83a2b680abc7af87cfff7777d0756fadb9f9aecd5ebda5d34f8139668e0fc842.png")
                        actors.append(actorObject)
                    }
                    
                    let movieDetailObject = MovieDetails(id: movieDetails["id"].int, imagesURLs: movieImages, title: movieDetails["title_english"].string, rate: movieDetails["rating"].float, genres: genres, year: movieDetails["year"].int, downloadsCount: movieDetails["download_count"].int, likesCount: movieDetails["like_count"].int, runTime: movieDetails["runtime"].int, fullDescription: movieDetails["description_full"].string, movieURL: movieDetails["url"].string, language: movieDetails["language"].string,cast: actors)
                    
                    completion(nil,movieDetailObject)
                }
                
            }
        }
    }
}
