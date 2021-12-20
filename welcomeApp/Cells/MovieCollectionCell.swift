//
//  MovieCollectionCell.swift
//  welcomeApp
//
//  Created by Adam Mierov on 20/12/2021.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    
    // Setup movies values
    func setCellWithValuesOf(_ movie:Movie) {
        movieNameLabel.text = movie.name
        releaseYearLabel.text = "\(movie.year)"
    }

}
