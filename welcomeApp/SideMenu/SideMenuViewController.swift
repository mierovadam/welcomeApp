//
//  SideMenuViewController.swift
//  welcomeApp
//
//  Created by Adam Mierov on 15/12/2021.
//
import SideMenu
import UIKit

class SideMenuViewController: UITableViewController {

    @IBOutlet weak var firstMode: UITableViewCell!
    @IBOutlet weak var secondMode: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            
        }
    }
}
