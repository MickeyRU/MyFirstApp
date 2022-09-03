//
//  StorageManager.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 20.07.2022.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    //  Метод класса для сохранения объекта в базе
    static func saveObject(_ place: Place) {
        
        try! realm.write{
            realm.add(place)
        }
    }
    
    //  Метод класса для удаления объекта из базы
    static func deleteObject(_ place: Place) {
        
        try! realm.write{
            realm.delete(place)
        }
    }
}
