//
//  Person.swift
//  BarberShop
//
//  Created by Nitin Karki on 4/4/17.
//  Copyright © 2017 Nitin Karki. All rights reserved.
//

import Foundation
import FirebaseAuth
import ObjectMapper

class Person:Mappable {
    
    var firebaseUser:FIRUser?
    var firstName:String = ""
    var lastName:String = ""
    var username:String = ""
    var email:String = ""
    var contactNumber:String = ""
    var upcomingAppointments:[Appointment] = []
    var pastAppointments:[String: Appointment] = [:]
    var notifications:[Notification] = []


    
    func mapping(map: Map) {
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        contactNumber <- map["contactNumber"]
        email <- map["email"]
        upcomingAppointments <- map["upcomingAppointments"]
        pastAppointments <- map["pastAppointments"]
//        notifications <- map["notifications"]
//        birthday <- (map["birthday"], DateTransform())
    }
    
    init() {
    }
    
    init(firstName:String, lastName:String, user:FIRUser?) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = "\(firstName) \(lastName)"
        self.firebaseUser = user
        
        let person = Person()
        person.firstName = "Mike"
        person.lastName = "Bibby"
    }
    
    required init?(map: Map) {}

}

