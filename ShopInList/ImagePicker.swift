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
//        NavigationView {
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
//        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode)
    var presentationMode

    @Binding var image: Image?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?

        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>) {
            _presentationMode = presentationMode
            _image = image
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = Image(uiImage: uiImage)
            presentationMode.dismiss()

        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImagePicherView(model: Product(name: "QQQ"))
        }
    }
}
