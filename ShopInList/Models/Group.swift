//
//  Group.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 01.09.2023.
//

import Foundation
import SwiftData

@Model
final class Group {
    let name: String = ""
    var isSelected: Bool = false
    var sections: [ProductSection] = []
    
    init(name: String) {
        self.name = name
    }
}
