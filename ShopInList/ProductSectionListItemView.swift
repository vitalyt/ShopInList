//
//  ProductSectionListItemView.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 04.09.2023.
//

import SwiftUI

struct ProductSectionListItemView: View {
    @Environment(\.modelContext) private var modelContext
    var model: ProductSection
    
    @State private var isEditable: Bool
    @State private var isOn: Bool
    
    init(model: ProductSection, editable: Bool = false) {
        self.model = model
        isOn = model.isSelected
        isEditable = editable
    }
    
    var body: some View {
        HStack {
            if isEditable {
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

struct ProductSectionListItemView_Previews: PreviewProvider {
    static var previews: some View {
        
        ProductSectionListItemView(model: ProductSection(name: "Test product name"))
            .modelContainer(for: ProductSection.self, inMemory: true)
    }
}


