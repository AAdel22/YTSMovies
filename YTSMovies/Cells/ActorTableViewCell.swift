//
//  ActorTableViewCell.swift
//  YTSMovies
//
//  Created by Alaa Adel on 4/27/20.
//  Copyright © 2020 Alaa Adel. All rights reserved.
//

import UIKit

class ActorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var actorImageView: UIImageView!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var actorCharacterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func cellDesign(){
        self.actorImageView.layer.cornerRadius = self.actorImageView.frame.width / 2
        self.actorImageView.layer.masksToBounds = true
    }
    
    func configure() {
        
    }

}
