//
//  Category.swift
//  Todoey
//
//  Created by Yaroslav Monastyrev on 22.03.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
