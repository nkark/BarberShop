//
//  Appointment.swift
//  BarberShop
//
//  Created by Nitin Karki on 4/4/17.
//  Copyright © 2017 Nitin Karki. All rights reserved.
//

import Foundation
import ObjectMapper

class Appointment:Mappable {
    
    var haircutter:Person?
    var customer:Person?
    var date:Date?
    var dateStamp:NSNumber?
    var dateString:String {
        get {
            if let dateString = self.date {
                let myFormatter = DateFormatter()
                myFormatter.dateStyle = .full
                myFormatter.timeStyle = .short
                
                // e.g. Monday, April 17, 2017 at 9:34 PM
                return myFormatter.string(from: dateString)
            } else {
                return ""
            }
        }
    }
    var notes:String?
    var totalBeforeTax:Float?
    var totalAfterTax:Float?
    
    func mapping(map: Map) {

        dateStamp <- map["dateStamp"]
        updateDateAfterFirebaseFetch()
        
        haircutter <- map["haircutter"]
        customer <- map["customer"]
        notes <- map["notes"]
        totalBeforeTax <- map["totalBeforeTax"]
        totalAfterTax <- map["totalAfterTax"]
    }
    
    init(haircutter:Person?, customer:Person?, date:Date) {
        self.haircutter = haircutter
        self.customer = customer
        self.date = date
        self.dateStamp = dateToNSNumber(date: date)
    }
    
    required init?(map: Map) {}
    
    func updateDateAfterFirebaseFetch() {
        if let stamp = self.dateStamp {
            let date = Date(timeIntervalSince1970: stamp.doubleValue)
            self.date = date
        }
    }
    
    func dateToNSNumber(date:Date) -> NSNumber {
        return NSNumber(value: Int(date.timeIntervalSince1970))
    }

}
