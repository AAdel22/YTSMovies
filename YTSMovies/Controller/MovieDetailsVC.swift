//
//  MovieDetailsVC.swift
//  YTSMovies
//
//  Created by Alaa Adel on 4/26/20.
//  Copyright © 2020 Alaa Adel. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailsVC: UIViewController {

    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    
    @IBOutlet weak var movieImagesScrollView: UIScrollView!
    @IBOutlet weak var movieImagesPageController: UIPageControl!
    
    @IBOutlet weak var movieDownloadCountLabel: UILabel!
    @IBOutlet weak var movieLikeLabel: UILabel!
    @IBOutlet weak var movieRateLabel: UILabel!
    @IBOutlet weak var movieLanguageLabel: UILabel!
    @IBOutlet weak var movieFullDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieURLLabel: UILabel!
    @IBOutlet weak var movieReviewsBTN: UIButton!
    
    var movieImages = [ImageResource]()
    
    var movieId: Int?
    var movieDetails: MovieDetails = MovieDetails()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieImagesScrollView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.movieReviewsBTN.layer.cornerRadius = self.movieReviewsBTN.frame.height / 2
        self.movieReviewsBTN.layer.borderWidth = 1
        self.movieReviewsBTN.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.movieReviewsBTN.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        hundleRefrech()
        
        
        
        
    }
    
    private func hundleRefrech() {
        Api.movieDetails(movieID: movieId!) { (erroe: Error?,movieDetails: MovieDetails? ) in
            if let movieDetails = movieDetails {
                self.movieDetails = movieDetails
                self.movieYearLabel.text = "\(movieDetails.year!)"
                self.movieGenresLabel.text = movieDetails.genres.joined(separator: ", ")
                
                self.movieLikeLabel.text = "\(movieDetails.likesCount!)"
                self.movieDownloadCountLabel.text = "\(movieDetails.downloadsCount!)"
                self.movieRateLabel.text = "\(movieDetails.rate!)"
                self.movieLanguageLabel.text = movieDetails.language
                
                self.movieFullDescriptionLabel.text = movieDetails.fullDescription
                
                self.movieURLLabel.text = movieDetails.movieURL
                
                self.saveMovieImage()
                
                self.addImageViewIntoScrollView()
                
                self.tableView.reloadData()
            }
        }
    }
    
    func saveMovieImage(){
        for imageURL in self.movieDetails.imagesURLs{
            let resource = ImageResource(downloadURL: URL(string: imageURL)!)
            
            self.movieImages.append(resource)
        }
    }
    
    func addImageViewIntoScrollView() {
        for i in 0..<self.movieImages.count{
            let imageView = UIImageView()
            imageView.kf.setImage(with: movieImages[i])
            imageView.contentMode = .scaleAspectFit
            let imagePostion = self.movieImagesScrollView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: imagePostion, y: 0, width: self.movieImagesScrollView.frame.width, height: self.movieImagesScrollView.frame.height)
            self.movieImagesScrollView.addSubview(imageView)
        }
        
        self.movieImagesPageController.numberOfPages = self.movieImages.count
        self.movieImagesPageController.currentPageIndicatorTintColor = UIColor.black
        self.movieImagesPageController.pageIndicatorTintColor = UIColor.lightGray
    }
}
extension MovieDetailsVC: UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = self.movieImagesScrollView.contentOffset.x / self.movieImagesScrollView.frame.size.width
        self.movieImagesPageController.currentPage = Int(pageNumber)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieDetails.cast!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActorTableViewCell", for: indexPath) as! ActorTableViewCell
        
        cell.cellDesign()
        cell.actorCharacterLabel.text = movieDetails.cast![indexPath.row].characterName
        cell.actorNameLabel.text = movieDetails.cast![indexPath.row].name
        cell.actorImageView.kf.setImage(with: URL(string: movieDetails.cast![indexPath.row].imgURL!))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
