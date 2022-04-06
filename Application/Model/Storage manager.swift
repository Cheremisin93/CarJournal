//
//  Item.swift
//  CarJournal
//
//  Created by Cheremisin Andrey on 05.04.2022.
//

import RealmSwift

let realm = try! Realm()


class StorageManager {
    
    static func saveObject(_ work: Work) {
        
        try! realm.write {
            realm.add(work)
            realm.refresh()
        }
    }
    
    
    static func deleteObject(_ work: Work) {
        
        try! realm.write {
            realm.delete(work)
            realm.refresh()
        }
    }
    
    
}
