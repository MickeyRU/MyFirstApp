//
//  TableViewController.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 12.07.2022.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var places: Results<Place>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
    }

    //  MARK: - Table View Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let place = places[indexPath.row]

        cell.nameLabel.text = place.name
        cell.typeLabel.text = place.type
        cell.locationLabel.text = place.location
        cell.placeImageView.image = UIImage(data: place.imageData!)


        cell.placeImageView.layer.cornerRadius =  cell.placeImageView.frame.size.height / 2
        cell.placeImageView.clipsToBounds = true
        return cell
    }
    
    
    //  MARK: Table View Delegate
    
    // Удаление строки по свайпу с анимацией
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let place = places[indexPath.row]
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //  MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPlace" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place = places[indexPath.row]
            let newPlaceVC = segue.destination as! PlacesTableViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    @IBAction func unwindSigue(segue: UIStoryboardSegue) {
        guard let newPlaceVC = segue.source as? PlacesTableViewController else { return }
        newPlaceVC.saveNewPlace()
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonTapped(segue: UIStoryboardSegue) {
        dismiss(animated: true)
    }
}
