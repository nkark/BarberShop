//
//  PersonDataManager.swift
//  BarberShop
//
//  Created by Nitin Karki on 4/4/17.
//  Copyright © 2017 Nitin Karki. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import ObjectMapper

final class PersonDataManager {
    
    static let sharedInstance: PersonDataManager = PersonDataManager()
    var allPeople:[Person] = []
    var ref: FIRDatabaseReference!
    
    var currentUser:Person?
    
    
    // Can't init is singleton
    private init() {
        self.getAllPeople(withCompletion: { _ in })
    }
    

    
    func createUser(firstName:String,
                    lastName:String,
                    email:String,
                    password:String,
                    successHandler:@escaping (_ newUser: Person) -> Void,
                    failureHandler:@escaping (_ error: Error) -> Void) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let createdUser = user {
                let newUser = Person(firstName: firstName, lastName: lastName, user: createdUser)
                self.currentUser = newUser
                
                self.ref = FIRDatabase.database().reference()
                
                // convert object to json dict
                let jsonNewUser = newUser.toJSON()
                
                // since adding new user, ensures fresh fetch subsequent call for all people
                self.allPeople.removeAll()
                
                // add new user to database
                self.ref.child("People").child("\(newUser.username)").setValue(["User Info": jsonNewUser], withCompletionBlock: { (error, _) in
                    if let err = error {
                        failureHandler(err)
                    } else {
                        successHandler(newUser)
                    }
                })
            } else {
                if let signUpError = error {
                    failureHandler(signUpError)
                }
            }
        }
    }
    
    
    func loginUser(email:String,
                   password:String,
                   successHandler:@escaping (_ newUser: Person) -> Void,
                   failureHandler:@escaping (_ error: Error) -> Void) {
    
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let loggedInUser = user {
                let signedInUser = Person(firstName: "Nitin", lastName: "Karki", user: loggedInUser)
                self.currentUser = signedInUser

                successHandler(signedInUser)
            } else {
                if let loginError = error {
                    failureHandler(loginError)
                }
            }
        }
    }
    
    func getAllPeople(withCompletion: @escaping (_ allPeople:[Person]) -> Void) {
        
        // Return local or go fetch remote
        if (self.allPeople.count > 0) {
            withCompletion(self.allPeople)
        } else {
            self.allPeople.removeAll()
        }
        
        // Create reference to database
        let ref = FIRDatabase.database().reference()
        
        ref.child("All_People").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            if let allPeopleDict = value as? [String: NSDictionary] {
                
                for (_, personDict) in allPeopleDict {
                    for (_, singlePersonDict) in personDict {
                        
                        if let singlePerson = singlePersonDict as? [String : Any] {
                            if let person = Person(JSON: singlePerson) {
                                self.allPeople.append(person)
                            }
                        }
                    }
                }
                
                withCompletion(self.allPeople)
            }
        })
    }
    
    
}
