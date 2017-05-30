//
//  Promotion.swift
//  BarberShop
//
//  Created by Nitin Karki on 4/4/17.
//  Copyright © 2017 Nitin Karki. All rights reserved.
//

import Foundation

class Promotion {
    var title:String?
    var description:String?
    var range:Dictionary<String, Date>?
    
    init(title:String, description:String, range:Dictionary<String, Date>) {
        self.title = title
        self.description = description
        self.range = range
    }
}
