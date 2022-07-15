//
//  PlacesTableViewController.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 15.07.2022.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            view.endEditing(true)
        }
    }
}

// Закрываем клавиатуру по нажатию на Done

extension PlacesTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
