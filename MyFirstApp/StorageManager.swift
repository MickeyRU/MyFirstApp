//
//  StorageManager.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 20.07.2022.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
        
        try! realm.write{
            realm.add(place)
        }
    }
}
