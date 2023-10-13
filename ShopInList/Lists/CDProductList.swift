//
//  ProductList.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 14.09.2023.
//

import SwiftUI
import SwiftData

struct CDProductList: View {
//    @Environment(\.modelContext) private var modelContext
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var products: FetchedResults<CDProduct>
//    @Query(sort: \CDProduct.name) private var products: [CDProduct]
    
    var body: some View {
        
        NavigationSplitView {
            List {
                Section(header: Text("Products")) {
                    ForEach(products) { item in
                        NavigationLink {
                            CDEditView(model: item)
                        } label: {
                            CDProductListItemView(model: item)
                        }
                    }
                    .onDelete(perform: { offsets in
                        delete(items: Array<CDProduct>(products), offsets: offsets)
                    })
                    .onMove { offsets, index in
                        moveItems(items: Array<CDProduct>(products), offsets: offsets, index: Int64(index))
                    }
                }
            }
            .navigationTitle(products.first?.section?.name ?? "Unknown")
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                    
                }
                ToolbarItem {
                    Button(action: share) {
                        Label("Share", systemImage: "share")
                    }
                    
                }
            }
        } detail: {
            Text("Select an item")
        }
        
    }

    private func share() {
        withAnimation {
            guard let product = products.last else { return }
            let _ = CoreDataStack.shared.getShare(product)
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = CDProduct(context: managedObjectContext)
            managedObjectContext.insert(newItem)
            CoreDataStack.shared.save()
        }
    }
    
    private func delete(items: [CDProduct], offsets: IndexSet) {
        withAnimation(.easeInOut, {
            for index in offsets {
                managedObjectContext.delete(items[index])
                CoreDataStack.shared.save()
            }
        })
    }
    
    private func moveItems(items: [CDProduct], offsets: IndexSet, index: Int64) {
        withAnimation {
            var items = items
            items.move(fromOffsets: offsets, toOffset: Int(index))
            for (index, item) in items.enumerated() {
                item.order = Int64(index)
            }
        }
    }
}

//#Preview {
//    ProductListNew()
//        .modelContainer(for: Product.self, inMemory: true)
//}
//
