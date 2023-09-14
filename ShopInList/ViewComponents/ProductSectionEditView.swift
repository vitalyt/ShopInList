//
//  ProductSectionEditView.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 04.09.2023.
//

import PhotosUI
import SwiftUI

struct ProductSectionEditView: View {
    var model: ProductSection
    
    @Environment(\.dismiss) private var dismiss
    @State private var productName = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var isShowPicker: Bool = false
    
    init(model: ProductSection) {
        self.model = model
        self.selectedImageData = model.image?.imageData
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
                PhotosPicker(selection: $selectedItem) {
                    Image(systemName: "photo")
                        .font(.headline)
                    Text("IMPORT").font(.headline)
                }
                .onChange(of: selectedItem) {
                    Task {
                        // Retrive selected asset in the form of Data
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                            model.image = ProductImage(imageData: data)
                        }
                    }
                }
            if let imageData = model.image?.imageData,
                let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                            .cornerRadius(10)
                    }
            HStack {
                Text("Name:")
                TextField(model.name, text: $productName, onCommit: {
                    model.name = productName
                    dismiss()
                })
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .navigationBarBackButtonHidden(false)
        .navigationTitle(model.name)
    }
}

struct ProductSectionEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProductSectionEditView(model: ProductSection(name: "Test product name"))
    }
}


