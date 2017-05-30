//
//  AppointmentDataManager.swift
//  BarberShop
//
//  Created by Nitin Karki on 4/19/17.
//  Copyright © 2017 Nitin Karki. All rights reserved.
//

import UIKit
import FirebaseDatabase

final class AppointmentDataManager {
    
    static let sharedInstance: AppointmentDataManager = AppointmentDataManager()
    var allAppointments:[Appointment] = []
    var firebaseRef: FIRDatabaseReference!
    
    // Can't init is singleton
    private init() {}
    
    func addAppointment(appointment:Appointment,
                        successHandler:@escaping () -> Void,
                        failureHandler:@escaping (_ error: Error) -> Void) {

        // since adding new appt, ensures fresh fetch subsequent call for all appts
        self.allAppointments.removeAll()
        
        self.firebaseRef = FIRDatabase.database().reference()
        
        // convert object to json dict
        let jsonAppointment = appointment.toJSON()
        
        // add new user to database
        self.firebaseRef.child("Appointments").child("\(appointment.dateString)").setValue(["Appointment": jsonAppointment]) { (error, _) in
            if let err = error {
                failureHandler(err)
            } else {
                successHandler()
            }
        }
    }
    
    func removeAppointment(appointmentDateString:String,
                        successHandler:@escaping () -> Void,
                        failureHandler:@escaping (_ error: Error) -> Void) {
        
        // since removing appt, ensures fresh fetch subsequent call for all appts
        self.allAppointments.removeAll()
        
        self.firebaseRef = FIRDatabase.database().reference()
        
        // remove appointment from database
        self.firebaseRef.child("Appointments").child("\(appointmentDateString)").removeValue { (error, _) in
            if let err = error {
                failureHandler(err)
            } else {
                successHandler()
            }
        }
    }
    
    func getAllAppointments(withCompletion: @escaping (_ allAppointments:[Appointment]) -> Void) {
        
        // Return local or go fetch remote
        if (self.allAppointments.count > 0) {
            withCompletion(self.allAppointments)
        } else {
            self.allAppointments.removeAll()
        }
        
        // Create reference to database
        let ref = FIRDatabase.database().reference()
        
        ref.child("Appointments").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            if let allAppointmentsDict = value as? [String: NSDictionary] {
                
                for (_, appointmentDict) in allAppointmentsDict {
                    for (_, singleAppointmentDict) in appointmentDict {
                        
                        if let singleAppointment = singleAppointmentDict as? [String : Any] {
                            if let appointment = Appointment(JSON: singleAppointment) {
                                self.allAppointments.append(appointment)
                            }
                        }
                    }
                }
                
                withCompletion(self.allAppointments)
            }
        })
    }
    
    

}
