//
//  ProductSectionEditView.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 04.09.2023.
//

import PhotosUI
import SwiftUI

struct CDProductSectionEditView: View {
    var model: CDProductSection
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @Environment(\.dismiss) private var dismiss
    @State private var productName = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var isShowPicker: Bool = false
    
    init(model: CDProductSection) {
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
                            let productImage = CDProductImage(context: managedObjectContext)
                            productImage.imageData = data
                            model.image = productImage
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
                TextField(model.name ?? "", text: $productName, onCommit: {
                    model.name = productName
                    dismiss()
                })
            }
        }
#if os(iOS)
        .textFieldStyle(RoundedBorderTextFieldStyle())
#endif
        .padding()
        .navigationBarBackButtonHidden(false)
        .navigationTitle(model.name ?? "")
    }
}
