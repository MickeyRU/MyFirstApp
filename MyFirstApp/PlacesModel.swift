//
//  PlacesModel.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 14.07.2022.
//

import UIKit

struct Places {
    var name: String
    var image: String
    var location: String
    var type: String
    
   static let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]
    
    static func makePlaces () -> [Places] {
        var places = [Places]()
        
        for place in restaurantNames {
            places.append(Places(name: place, image: place, location: "Moscow", type: "Restaraunt"))
        }
        
        return places
    }
    
}
