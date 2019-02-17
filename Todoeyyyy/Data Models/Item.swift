//
//  Model.swift
//  Todoeyyyy
//
//  Created by Mayank Gautam on 17/02/19.
//  Copyright © 2019 Mayank Gautam. All rights reserved.
//

import Foundation

class Item {
    var title: String = ""
    var isComplete = false
    
    init(_ title: String) {
        self.title = title
    }
}
