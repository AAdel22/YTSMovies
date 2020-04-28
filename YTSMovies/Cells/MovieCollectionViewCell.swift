//
//  MovieCollectionViewCell.swift
//  YTSMovies
//
//  Created by Alaa Adel on 4/25/20.
//  Copyright © 2020 Alaa Adel. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieCollectionViewCell",
                     bundle: nil)
    }
}
