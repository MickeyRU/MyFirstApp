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

        let place = myPlaces[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.typeLabel.text = place.type
        cell.locationLabel.text = place.location
        
        if place.image == nil {
            cell.placeImageView.image = UIImage(named: place.restaurantImage!)
        } else {
            cell.placeImageView.image = place.image
        }
        
        
        cell.placeImageView.layer.cornerRadius =  cell.placeImageView.frame.size.height / 2
        cell.placeImageView.clipsToBounds = true
        return cell
    }
    
    @IBAction func unwindSigue(segue: UIStoryboardSegue) {
        guard let newPlaceVC = segue.source as? PlacesTableViewController else { return }
        newPlaceVC.saveNewPlace()
        myPlaces.append(newPlaceVC.newPlace!)
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonTapped(segue: UIStoryboardSegue) {
        dismiss(animated: true)
    }
}
