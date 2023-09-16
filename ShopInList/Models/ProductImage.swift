//
//  ProductImage.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 03.09.2023.
//

import Foundation
import SwiftData

@Model
final class ProductImage {
    @Attribute(.externalStorage) var imageData: Data?
    @Relationship(inverse:\Product.image) var product: Product?
    @Relationship(inverse:\ProductSection.image) var productSection: ProductSection?
//    @Relationship var productSection: ProductSection?
    
    init(imageData: Data?) {
        self.imageData = imageData
    }
}
