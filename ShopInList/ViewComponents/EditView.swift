//
//  EditView.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 03.09.2023.
//

import PhotosUI
import SwiftUI
import SwiftData

struct EditView: View {
    var model: Product
    
    @Environment(\.dismiss) private var dismiss
    @State private var productName = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var isShowPicker: Bool = false
    
    @State private var isShowingDetailView = false
    
    init(model: Product) {
        self.model = model
        self.selectedImageData = model.image?.imageData
        print("-->\(model)")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageData = model.image?.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 250)
                    .cornerRadius(10)
            }
            
            PhotosPicker(selection: $selectedItem) {
                Image(systemName: "photo")
                    .font(.headline)
                Text("Change Image").font(.headline)
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
            
            HStack {
                Text("Name:")
                TextField(model.name, text: $productName, onCommit: {
                    model.name = productName
                })
            }
            
            HStack {
                Text("Section:")
                NavigationLink {
                    SectionList(model: model, didSelect: { section in
                        self.model.section = section
                    }).modelContext(model.modelContext!)
                } label: {
                    Text(model.section?.name ?? "------")
                }
            }
        }
#if os(iOS)
        .textFieldStyle(RoundedBorderTextFieldStyle())
#endif
        .padding()
        .navigationBarBackButtonHidden(false)
        .navigationTitle(model.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(model: Product(name: "Test product name"))
    }
}

