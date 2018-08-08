//
//  Item.swift
//  ToDoList
//
//  Created by Méryl VALIER on 08/08/2018.
//  Copyright © 2018 Dinoboros. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var status: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
