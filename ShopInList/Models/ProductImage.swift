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
    
    init(imageData: Data?) {
        self.imageData = imageData
    }
}
