//
//  MoviesCell.swift
//  MovieViewer
//
//  Created by Shumba Brown on 1/7/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class MoviesCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
