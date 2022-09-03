//
//  PreviewStarsStackView.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 08.08.2022.
//

import UIKit

class PreviewStarsStackView: UIStackView {
    
    private var starSize: CGSize = CGSize(width: 15.0, height: 15.0)
    
    var rating = 0 {
        didSet {
            setupRatingForPlace()
        }
    }
    
    var starsCount = 5
    
    private var starImages = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStarsImage()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStarsImage()
    }
    
    private func setupStarsImage() {
        for _ in 0..<starsCount {
            let starImage = UIImageView()
            starImage.image = UIImage(named: "emptyStar")
            
            // Работа с констрейнтами
            starImage.translatesAutoresizingMaskIntoConstraints = false
            starImage.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            starImage.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            addArrangedSubview(starImage)
            
            starImages.append(starImage)
        }
    }
    
    private func setupRatingForPlace() {
        for (index, star) in starImages.enumerated() {
            if index + 1 <= rating {
            star.image = UIImage(named: "filledStar")
            } else {
            star.image = UIImage(named: "emptyStar")
            }
        }
    }
}
