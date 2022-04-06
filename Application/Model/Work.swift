//
//  WorkDetails.swift
//  CarJournal
//
//  Created by Cheremisin Andrey on 06.04.2022.
//

import UIKit
import RealmSwift

class Work: Object {
    
    @objc dynamic var imageData: Data?
    
    @objc dynamic var title = ""
    @objc dynamic var price: String?
    @objc dynamic var date: String?
    @objc dynamic var milage: String?
    
    convenience init(title: String, price: String?, date: String?, milage: String?, imageData: Data?) {
        self.init()
        self.title = title
        self.price = price
        self.date = date
        self.milage = milage
        self.imageData = imageData
    }
    
}
