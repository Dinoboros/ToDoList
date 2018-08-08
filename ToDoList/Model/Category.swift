//
//  Category.swift
//  ToDoList
//
//  Created by Méryl VALIER on 08/08/2018.
//  Copyright © 2018 Dinoboros. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    @objc dynamic var dateCreated: Date?
    let items = List<Item>()
}
