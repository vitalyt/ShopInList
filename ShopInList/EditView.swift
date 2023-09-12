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
        
//        model.sections.forEach({ $0.isSelected = true })
    }
    
    var body: some View {
            VStack {
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
                
                List {
                    NavigationLink {
                        SectionList(model: model).modelContext(model.modelContext!)
                    } label: {
                        Text("+")
                    }
                    ForEach(model.sections) { item in
                        NavigationLink {
                            ProductSectionEditView(model: item)
                        } label: {
                            ProductSectionListItemView(model: item)
                        }
                    }
                    .onDelete(perform: { offsets in
                        self.deleteSection(offsets: offsets)
                    })
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .navigationBarBackButtonHidden(false)
            .navigationTitle(model.name)
        }
    
    private func deleteSection(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                model.sections[index].isSelected = false
                model.sections.remove(at: index)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(model: Product(name: "Test product name"))
    }
}

