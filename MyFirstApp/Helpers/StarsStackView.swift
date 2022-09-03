//
//  StarsStackView.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 08.08.2022.
//

import UIKit

// Помечаем ключевым словом @IBDesignable - для отображения контекта из кода в interface builder

class StarsStackView: UIStackView {
    
    // MARK: Properties
    
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    //  Помечаем ключевым словом @IBInspectable и явно указываем тип данных - чтобы свойство появилось в interface builder
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButton()
        }
    }
    @IBInspectable var starsCount: Int = 5 {
        didSet {
            setupButton()
        }
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: Setup buttons
    
    private func setupButton() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Загружаем изображения для кнопок
        // определяет место нахождение ресурсов для проекта
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        // Создание 5 эксземляров кнопок через цикл
        for _ in 1...starsCount {
            
            // Создание обьекта кнопки
            let button = UIButton()
            
            // Настройка внешнего вида кнопки
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Работа с констрейнтами
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Добавление кнопки на экран
            addArrangedSubview(button)
            
            // Добавление действия к кнопке
            button.addTarget(self, action: #selector(rattingbuttonTapped(button:)), for: .touchUpInside)
            
            // Добавляем кнопки в массив
            ratingButtons.append(button)
        }
        updateButtonSelectionState()
    }
    
    // MARK: Button actions
    
    @objc func rattingbuttonTapped(button: UIButton){
        
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        
        //  считаем рейтинг выбранной звезды
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
