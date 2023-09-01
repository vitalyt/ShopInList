//
//  Item.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 01.09.2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
