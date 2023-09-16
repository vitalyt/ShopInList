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
    var name: String = ""
    var order: Int = 0
    var isSelected: Bool = false
    var timestamp: Date = Date()
    @Relationship var image: ProductImage?
//    @Relationship var products: [Product]?
    @Relationship(inverse:\Product.section) var products: [Product]?
    
    init(name: String, timestamp: Date = Date()) {
        self.name = name
        self.timestamp = timestamp
    }
}
