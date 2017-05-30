//
//  ViewController.swift
//  BarberShop
//
//  Created by Nitin Karki on 4/4/17.
//  Copyright © 2017 Nitin Karki. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    
    var authListenHandler:FIRAuthStateDidChangeListenerHandle?
    
    var ref: FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        
    PersonDataManager.sharedInstance.createUser(firstName: "Nitin",
                                                lastName: "Karki",
                                                email: "bob@gmail.com",
                                                password: "mole24",
                                                successHandler: { (createdUser) in
                                                    print("User created successfully")
    },
                                                failureHandler: { (error) in
                                                    print("** SIGN UP ERROR ** --> \(error.localizedDescription)")})
        
        
        
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let handler = authListenHandler {
            FIRAuth.auth()?.removeStateDidChangeListener(handler)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        signInStateChanged()
        
        
//        PersonDataManager.sharedInstance.loginUser(email: "john_smith@gmail.com",
//                                                   password: "mole24",
//                                                   successHandler: { (newUser) in
//                                                    print("User logged in")
//        },
//                                                   failureHandler:{ (error) in
//                                                    print("** SIGN IN ERROR ** --> \(error.localizedDescription)")})

        
        
    }
    
    func signInStateChanged() {
        
        authListenHandler = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            
            // The sign in state has changed...
            print("******************************   The sign in state has changed    ******************************")
        }
    }
    


    
    @IBAction func buttonOne(_ sender: UIButton) {
        
        let customer = Person(firstName: "Nitin", lastName: "Karki", user: PersonDataManager.sharedInstance.currentUser?.firebaseUser)
        let cutter = Person(firstName: "Dawn", lastName: "Smith", user: nil)
        
        let appointment = Appointment(haircutter: cutter, customer: customer, date: Date())

        AppointmentDataManager.sharedInstance.addAppointment(appointment: appointment, successHandler: {
            
            print("appointment made!")
            
        }, failureHandler: {(error) in
            
            print("\(error.localizedDescription)")
        })

        
    }
    
    
    @IBAction func buttonTwo(_ sender: UIButton) {
        
        let today = Date()
        let myFormatter = DateFormatter()
        myFormatter.dateStyle = .full
        myFormatter.timeStyle = .short
        
        // e.g. Monday, April 17, 2017 at 9:34 PM
        let dateString =  myFormatter.string(from: today)
        
        AppointmentDataManager.sharedInstance.removeAppointment(appointmentDateString: dateString, successHandler: {
            print("appointment deleted!")
            
        }, failureHandler: {(error) in
            
            print("\(error.localizedDescription)")
            
        })
    }
    
    @IBAction func buttonThree(_ sender: UIButton) {
        
        AppointmentDataManager.sharedInstance.getAllAppointments { (appointments) in
            
            if let allAppts = appointments as [Appointment]? {
                
                for appointment in allAppts {
                    
                    print("\(appointment.dateString)")
                    
                }
                
            }
        }
    }
    
    @IBAction func buttonFour(_ sender: UIButton) {
    }
}

