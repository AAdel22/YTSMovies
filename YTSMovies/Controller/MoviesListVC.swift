//
//  ViewController.swift
//  YTSMovies
//
//  Created by Alaa Adel on 4/25/20.
//  Copyright © 2020 Alaa Adel. All rights reserved.
//

import UIKit
import Kingfisher

class MoviesListVC: UIViewController,DataSentByDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    var movies: [MovieList] = [MovieList]()
   
    
    var searchQuery: String!
    var pageNumber: Int = 1
    
    var tableViewIsForDisplay: MovieResult = .list {
        didSet{
            pageNumber = 1
        }
    }
        
    private var refreshController:UIRefreshControl = UIRefreshControl()
    
    var currentResponseMoviesCount = 0
    
    // the filter Var
    private var filterQuery: String = "0"
    private var filterGenre: String = "all"
    private var filterRate: Int = 0
    private var filterQuality: String = "All"
    private var filterSortBy: String = "date_added"
    private var filterOrderBy: String = "desc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        movieSearchBar.delegate = self
        
        let navBarFilterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .done, target: self, action: #selector(showFilterView))
        
        self.navigationItem.rightBarButtonItem = navBarFilterButton
        filterMovies()
        allMovies()
        refreshController.addTarget(self, action: #selector(refreachTableView), for: UIControlEvents.valueChanged)
        self.tableView.refreshControl = refreshController
        self.tableView.addSubview(refreshController)
    }
    
    @objc func showFilterView(){
        self.performSegue(withIdentifier: "segueFilter", sender: self)
    }
    func allMovies() {
        self.navigationItem.title = "List Movies"
        
        Api.allMovies(page: pageNumber) { (error: Error?, movies: [MovieList]?) in
            if let movies = movies {
                self.movies = movies
                let movie = MovieList()
                self.currentResponseMoviesCount = movie.moviesCount ?? 0
                self.tableView.reloadData()
                self.pageNumber+=1
            }
        }
    }
    
    func searchMovies() {
        self.navigationItem.title = "Search Movies"
        self.tableViewIsForDisplay = .search
        Api.searchMovies(page: pageNumber, query: searchQuery) { (error: Error?, movies: [MovieList]?) in
            if let movies = movies {
                self.movies = movies
                let movie = MovieList()
                self.currentResponseMoviesCount = movie.moviesCount ?? 0
                
                self.tableView.reloadData()
            }
        }
    }
    func filterMovies() {
        self.navigationItem.title = "Filter Movies"
        
        Api.filterMovies(page: pageNumber, quality: filterQuality, rating: filterRate, query: filterQuery, genre: filterGenre, sortBy: filterSortBy, orderBy: filterOrderBy) { (error: Error?, movies: [MovieList]?) in
            if let movies = movies {
                self.movies = movies
                self.tableViewIsForDisplay = .filter
                self.tableView.reloadData()
            }
        }
    }
    func userDidApplySomeFilter(query: String, genre: String, minRate: Int, quality: String, sortBy: String, orderBy: String) {
        
        self.tableViewIsForDisplay = .filter
        
        self.filterQuery = query
        self.filterGenre = genre
        self.filterRate = minRate
        self.filterQuality = quality
        self.filterSortBy = sortBy
        self.filterOrderBy = orderBy
        
        self.movies.removeAll(keepingCapacity: false)
        self.filterMovies()
    }
    @objc func refreachTableView() {
        
        self.tableViewIsForDisplay = .list
        self.movieSearchBar.text = nil
        
        self.allMovies()
        self.refreshController.endRefreshing()
    }
}

extension MoviesListVC: UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {
    // searchBar.....
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let queryTerm = searchBar.text, queryTerm.trimmingCharacters(in: [" "]) != ""{
            
            self.movies.removeAll(keepingCapacity: true)
            
            self.tableViewIsForDisplay = .search
            
            self.searchQuery = queryTerm
            
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
        if (self.movies.count - 1 == indexPath.row) && (self.movies.count < self.currentResponseMoviesCount) {
            if tableViewIsForDisplay == .list {
                allMovies()
            } else if tableViewIsForDisplay == .search {
                searchMovies()
            } else if tableViewIsForDisplay == .filter {
                filterMovies()
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

