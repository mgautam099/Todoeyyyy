//
//  Category.swift
//  Todoeyyyy
//
//  Created by Mayank Gautam on 19/02/19.
//  Copyright © 2019 Mayank Gautam. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var color: String = "7A81FF"
    let items = List<Item>()
}

