//
//  MainView.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 01.09.2023.
//

import SwiftUI
import SwiftData

struct CDMainView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @State private var selectedItem = 0
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\CDProductSection.order, order: .forward), SortDescriptor(\CDProductSection.timestamp, order: .reverse)]) private var productSections: FetchedResults<CDProductSection>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) private var productsWithoutSection: FetchedResults<CDProduct>
    
    var body: some View {
        NavigationSplitView {
            TabView(selection: $selectedItem) {
                ForEach(0..<productSections.count, id: \.self) { index in
                    CDProductList(predicate: NSPredicate(format: "section == %@", productSections[index])).tag(index)
                }
                CDProductList(predicate: NSPredicate(format: "section == nil")).tag(productSections.count)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .automatic))
//            .navigationTitle("Products")
#if os(iOS)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
#endif
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = CDProduct(context: managedObjectContext)
            if selectedItem < productSections.count {
                newItem.section = productSections[selectedItem]
            }
            managedObjectContext.insert(newItem)
            CoreDataStack.shared.save()
        }
    }
}

