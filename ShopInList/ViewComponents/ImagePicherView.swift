//
//  ImagePicker.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 03.09.2023.
//

import SwiftUI

struct ImagePicherView: View {
    var model: Product
    
    @State var isShowPicker: Bool = false
    @State var image: Image? = Image("placeholder")

    init(model: Product) {
        self.model = model
        let image = {
            if let imageData = model.image?.imageData, let uiImage = UIImage(data: imageData) {
                return Image(uiImage: uiImage)
            }
            return Image(systemName: "photo")
        }()
        self.image = image
    }
    
    var body: some View {
        ZStack {
            VStack {
                image?
                    .resizable()
                    .scaledToFit()
                    .frame(height: 320)
                Button(action: {
                    withAnimation {
                        self.isShowPicker.toggle()
                    }
                }) {
                    Image(systemName: "photo")
                        .font(.headline)
                    Text("IMPORT").font(.headline)
                }.foregroundColor(.black)
                Spacer()
            }
        }
        .sheet(isPresented: $isShowPicker) {
            ImagePicker(image: self.$image)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImagePicherView(model: Product(name: "QQQ"))
        }
    }
}
