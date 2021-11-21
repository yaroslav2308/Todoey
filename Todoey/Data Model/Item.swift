//
//  Item.swift
//  Todoey
//
//  Created by Yaroslav Monastyrev on 18.11.2021.
//

import Foundation

class Item: Encodable {
    var title: String = "New Item"
    var done: Bool = false
}
