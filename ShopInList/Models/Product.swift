//
//  Product.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 01.09.2023.
//

import Foundation
import SwiftData

@Model
final class Product {
    var name: String
    var order: Int = 0
    var timestamp: Date
    var count: UInt = 1
    var isSelected: Bool = false
    var price: Double? = nil
    var image: ProductImage? = nil
    var section: ProductSection?
    
    init(name: String, timestamp: Date = Date()) {
        self.name = name
        self.timestamp = timestamp
    }
}
