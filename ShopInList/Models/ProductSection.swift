//
//  Section.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 01.09.2023.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class ProductSection {
    var name: String
    var isSelected: Bool = false
    var image: ProductImage? = nil
    var timestamp: Date
    var products: [Product] = []
    
    init(name: String, timestamp: Date = Date()) {
        self.name = name
        self.timestamp = timestamp
    }
}
