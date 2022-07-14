//
//  TableViewController.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 12.07.2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    var myPlaces = Places.makePlaces()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPlaces.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        cell.nameLabel.text = myPlaces[indexPath.row].name
        cell.placeImageView.image = UIImage(named: myPlaces[indexPath.row].image)
        cell.typeLabel.text = myPlaces[indexPath.row].type
        cell.locationLabel.text = myPlaces[indexPath.row].location
        cell.placeImageView.layer.cornerRadius =  cell.placeImageView.frame.size.height / 2
        cell.placeImageView.clipsToBounds = true
        return cell
    }
    
    @IBAction func cancelAction(segue: UIStoryboardSegue) {
        
    }
}
