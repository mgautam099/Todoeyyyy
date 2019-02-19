//
//  Item.swift
//  Todoeyyyy
//
//  Created by Mayank Gautam on 19/02/19.
//  Copyright © 2019 Mayank Gautam. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
