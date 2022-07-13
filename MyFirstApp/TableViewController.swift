//
//  TableViewController.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 12.07.2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - UITableViewDataSource


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = restaurantNames[indexPath.row]
        content.image = UIImage(named: restaurantNames[indexPath.row])
        content.imageProperties.reservedLayoutSize = CGSize(width: 30, height: 30)
        cell.contentConfiguration = content
        return cell
    }
}
