//
//  TableViewController.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 12.07.2022.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var places: Results<Place>!
    private var filtredPlaces: Results<Place>!
    private var ascendingSorting = true
    private var searchBarIsmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsmpty
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reverceSortingButton: UIBarButtonItem!
    @IBOutlet weak var sortTypeSegmentedControl: UISegmentedControl!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
        
        //Setup the search controller
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }

    //  MARK: Table View Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if isFiltering {
                return filtredPlaces.count
            }
            return places.isEmpty ? 0 : places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        var place = Place()
        
        if isFiltering {
            place = filtredPlaces[indexPath.row]
        } else {
            place = places[indexPath.row]
        }
        
        cell.nameLabel.text = place.name
        cell.typeLabel.text = place.type
        cell.locationLabel.text = place.location
        cell.placeImageView.image = UIImage(data: place.imageData!)


        cell.placeImageView.layer.cornerRadius =  cell.placeImageView.frame.size.height / 2
        cell.placeImageView.clipsToBounds = true
        cell.previewRating.rating = Int(place.rating)
        return cell
    }
    
    
    //  MARK: Table View Delegate
    
    // Отмена выделения после редактипрования и возврата к общему списку заведений
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
            let place: Place
            if isFiltering {
                place = filtredPlaces[indexPath.row]
            } else {
                place = places[indexPath.row]
            }
            let newPlaceVC = segue.destination as! PlacesViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    @IBAction func unwindSigue(segue: UIStoryboardSegue) {
        guard let newPlaceVC = segue.source as? PlacesViewController else { return }
        newPlaceVC.saveNewPlace()
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonTapped(segue: UIStoryboardSegue) {
        dismiss(animated: true)
    }
    
    
    @IBAction func sortType(_ sender: UISegmentedControl) {
        
        sorting()
    }
    
    @IBAction func reverceSorted(_ sender: Any) {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reverceSortingButton.image = UIImage(named: "AZ")
        } else {
            reverceSortingButton.image = UIImage(named: "ZA")
        }
        
        sorting()
    }
    
    private func sorting(){
        if sortTypeSegmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        tableView.reloadData()
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filtredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText) //  запрос из документации по realm
        tableView.reloadData()
    }
    
    
}
