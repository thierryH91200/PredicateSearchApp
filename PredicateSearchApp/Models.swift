//
//  Item.swift
//  test44
//
//  Created by thierryH24 on 09/01/2026.
//

import Foundation
import SwiftData

// MARK: - Model
@Model final class EntityPerson {
    @Attribute(.unique) var id: UUID = UUID()
    var firstName: String = ""
    var lastName: String = ""
    var dateOfBirth = Date()
    var age = 0
    var department = ""
    var country = ""
    var isBool = true
    
    init(firstName: String = "", lastName: String = "", dateOfBirth: Date = Date(), age: Int = 0, department: String = "", country: String = "", isBool: Bool = true) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.age = age
        self.department = department
        self.country = country
        self.isBool = isBool
    }
}
