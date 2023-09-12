//
//  ProductListItemView.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 03.09.2023.
//

import SwiftUI

struct ProductListItemView: View {
    @Environment(\.modelContext) private var modelContext
    var model: Product
    
    @State private var isOn: Bool
    
    init(model: Product) {
        self.model = model
        isOn = model.isSelected
    }
    
    var body: some View {
        HStack {
            Toggle(isOn: $isOn) {
                Label { } icon: {
                    Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                        .accessibility(label: Text(isOn ? "Checked" : "Unchecked"))
                        .imageScale(.large)
                }
            }
            .toggleStyle(.button)
            .buttonStyle(.plain)
            .onChange(of: isOn) {
                model.isSelected = isOn
            }
            Text(model.name)
            if let imageData = model.image?.imageData,
                let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .cornerRadius(5)
                            .padding()
                    }
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListItemView(model: Product(name: "Test product name"))
            .modelContainer(for: Product.self, inMemory: true)
    }
}

