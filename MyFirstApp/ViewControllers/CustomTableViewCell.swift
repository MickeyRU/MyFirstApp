//
//  CustomTableViewCell.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 13.07.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var previewRating: PreviewStarsStackView!
}
