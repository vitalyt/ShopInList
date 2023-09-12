//
//  ContentView.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 01.09.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    static let sortDescriptors: [SortDescriptor<Product>] = [SortDescriptor(\Product.order, order: .forward), SortDescriptor(\Product.timestamp, order: .reverse)]
    @Query(filter:#Predicate<Product> { !$0.isSelected }, sort: sortDescriptors) private var items: [Product]
    @Query(filter:#Predicate<Product> { $0.isSelected }, sort: sortDescriptors) private var selectedItems: [Product]
    
    var body: some View {
        NavigationSplitView {
            List {
                Section(header: Text("Products")) {
                    ForEach(items) { item in
                        NavigationLink {
                            EditView(model: item)
                        } label: {
                            ProductListItemView(model: item)
                        }
                    }
                    .onDelete(perform: { offsets in
                        delete(items: items, offsets: offsets)
                    })
                    .onMove { offsets, index in
                        moveItems(items: items, offsets: offsets, index: index)
                    }
                }
                Section(header: Text("Selected Products")) {
                    ForEach(selectedItems) { item in
                        NavigationLink {
                            EditView(model: item)
                        } label: {
                            ProductListItemView(model: item)
                        }
                    }
                    .onDelete(perform: { offsets in
                        delete(items: selectedItems, offsets: offsets)
                    })
                    .onMove { offsets, index in
                        moveItems(items: selectedItems, offsets: offsets, index: index)
                    }
                    
                }
            }
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
            .navigationTitle("Products")
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Product(name: "QQQ product")
            modelContext.insert(newItem)
        }
    }

    private func delete(items: [Product], offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func moveItems(items: [Product], offsets: IndexSet, index: Int) {
        withAnimation {
            var items = items
            items.move(fromOffsets: offsets, toOffset: index)
            for (index, item) in items.enumerated() {
                item.order = index
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Product.self, inMemory: true)
}
