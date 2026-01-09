//
//  Profile.swift
//  Pixem
//
//  Created by Andrew Younan on 8/1/2026.
//

import Foundation
import SwiftData

final class Profile {
    // Identification
    public var name: String
    public var age: Int
    public var verified: Bool?
    
    // Contacts
    private var email: String
    private var mobile: String
    
    // Status
    private var loggedIn: Bool
    private var jobs: [Job]
    
    init(name: String, age: Int, verified: Bool? = nil, email: String, mobile: String, loggedIn: Bool, jobs: [Job]) {
        self.name = name
        self.age = age
        self.verified = verified
        self.email = email
        self.mobile = mobile
        self.loggedIn = loggedIn
        self.jobs = jobs
    }
}
