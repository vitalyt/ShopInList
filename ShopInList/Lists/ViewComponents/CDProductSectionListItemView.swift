//
//  ProductSectionListItemView.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 04.09.2023.
//

import SwiftUI

struct CDProductSectionListItemView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    var model: CDProductSection
    let didSelect: ((_ item: CDProductSection) -> Void)?
    
    @State private var isEditable: Bool
    @State private var isOn: Bool
    
    init(model: CDProductSection, editable: Bool = false, isSelected: Bool = false, didSelect: ((_ item: CDProductSection) -> Void)? = nil) {
        self.model = model
        self.didSelect = didSelect
        
        isOn = isSelected
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
                    self.didSelect?(model)
                }
            }
            Text(model.name ?? "")
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


