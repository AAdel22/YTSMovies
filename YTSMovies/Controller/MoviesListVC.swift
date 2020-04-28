//
//  ViewController.swift
//  YTSMovies
//
//  Created by Alaa Adel on 4/25/20.
//  Copyright © 2020 Alaa Adel. All rights reserved.
//

import UIKit
import Kingfisher

class MoviesListVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    var movies: [MovieList] = [MovieList]()
    
    
    
    var nextPageNumber: Int = 1
    var currentMoviesCount = 0
    var tableViewIsForDisplay: MovieResult = .list {
        didSet{
            nextPageNumber = 1
        }
    }
    var currentResponseMoviesCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        movieSearchBar.delegate = self
        
        let navBarFilterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .done, target: self, action: #selector(showFilterView))
        
        self.navigationItem.rightBarButtonItem = navBarFilterButton
        
        allMovies(reset: false)
    }
    
    @objc func showFilterView(){
        self.performSegue(withIdentifier: "segueFilter", sender: self)
    }
    
    var page: Int = 1
    var query: String!
    var genre: String = "alaa"
    var rate: Int = 1
    var quality: String = "All"
    var sortBy: String = "date_added"
    var orderBy: String = "desc"
    
    func allMovies(reset: Bool) {
        Api.allMovies(page: page) { (error: Error?, movies: [MovieList]?) in
            if let movies = movies {
                self.movies = movies
                
                self.currentResponseMoviesCount = movies.count
                
                self.tableView.reloadData()
                
                self.nextPageNumber+=1
            }
        }
    }
    
    func searchMovies() {
        Api.searchMovies(page: page, query: query) { (error: Error?, movies: [MovieList]?) in
            if let movies = movies {
                self.movies = movies
                self.tableView.reloadData()
            }
        }
    }
}

extension MoviesListVC: UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {
    
    // searchBar.....
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let queryTerm = searchBar.text, queryTerm.trimmingCharacters(in: [" "]) != ""{
            
            self.movies.removeAll(keepingCapacity: false)
            
            tableViewIsForDisplay = .search
            
            self.query = queryTerm
            
            searchMovies()
        }
        self.view.endEditing(true)
    }
    
    // tableView.....
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (movies.count - 1 == indexPath.row) && (self.movies.count < self.currentMoviesCount){
            if tableViewIsForDisplay == .list {
                allMovies(reset: false)
            } else if tableViewIsForDisplay == .search {
                searchMovies()
            }
        }
        
    }
    // func to show MovieDetails And pass MovieID
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMovieDetails" {
            let movieDetailsVC = segue.destination as! MovieDetailsVC
            if let movieIndex = tableView.indexPathForSelectedRow?.row {
                if let movieID = movies[movieIndex].id {
                    movieDetailsVC.movieId = movieID
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

