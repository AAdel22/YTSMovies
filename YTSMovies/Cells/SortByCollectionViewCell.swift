//
//  SortByCollectionViewCell.swift
//  YTSMovies
//
//  Created by Alaa Adel on 4/26/20.
//  Copyright © 2020 Alaa Adel. All rights reserved.
//

import UIKit

class SortByCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var sortByLabel: UILabel!
    
    
    func cellDesign() {
        self.viewCell.layer.cornerRadius = self.viewCell.frame.height / 2
        self.viewCell.layer.borderWidth = 1
        self.viewCell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.sortByLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func configure(with data: String, isSelected: Bool){
        self.sortByLabel.text = data
        if isSelected {
            self.viewCell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.sortByLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            self.viewCell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.sortByLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
    }
}
