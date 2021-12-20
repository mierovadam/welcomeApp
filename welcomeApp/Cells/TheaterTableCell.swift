//
//  TheaterTableCell.swift
//  welcomeApp
//
//  Created by Adam Mierov on 20/12/2021.
//

import UIKit

class TheaterCell: UITableViewCell {

    @IBOutlet weak var theaterLBL: UILabel!
    
    // Setup movies values
    func setCellWithValuesOf(_ theater:String) {
        theaterLBL.text = theater
    }
}
