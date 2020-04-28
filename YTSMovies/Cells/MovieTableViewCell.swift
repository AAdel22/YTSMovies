//
//  MovieTableViewCell.swift
//  YTSMovies
//
//  Created by Alaa Adel on 4/25/20.
//  Copyright © 2020 Alaa Adel. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    @IBOutlet weak var movieRateLabel: UILabel!
    @IBOutlet weak var movieBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellDesign()
    }
    func cellDesign() {
        
        self.movieBackgroundView.layer.cornerRadius = 25
        self.movieBackgroundView.layer.borderWidth = 3
        self.movieBackgroundView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.movieBackgroundView.clipsToBounds = true
    }
    func configure(with data: MovieList){
        self.movieTitleLabel.text = data.titleLong
        self.movieRateLabel.text = "⭐️  \(data.rate ?? 0) / 10"
        self.movieGenresLabel.text = data.genres?.joined(separator: ", ")
        self.movieImageView.kf.setImage(with: URL(string: data.imgURL!))
    }
}
