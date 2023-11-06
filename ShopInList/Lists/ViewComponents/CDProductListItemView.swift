//
//  ProductListItemView.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 03.09.2023.
//

import SwiftUI

struct CDProductListItemView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    var model: CDProduct
    
    @State private var isOn: Bool
    @Binding var confettiCounter: Int
    private let heightCell = 44.0
    
    init(model: CDProduct, confettiCounter: Binding<Int>) {
        self.model = model
        self.isOn = model.isSelected
        self._confettiCounter = confettiCounter
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
                CoreDataStack.shared.save()
                if isOn {
                    confettiCounter += 1
                }
#if os(iOS)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
#elseif os(watchOS)
                WKInterfaceDevice.current().play(.success)
#endif
            }
            Text(model.name!)
            if let imageData = model.image?.imageData,
                let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: heightCell, maxHeight: heightCell)
                            .cornerRadius(5)
                    }
        }
        .frame(height: heightCell)
    }
}
