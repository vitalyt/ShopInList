//
//  Mall.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 01.09.2023.
//

import Foundation
import SwiftData

@Model
final class Mall {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}
