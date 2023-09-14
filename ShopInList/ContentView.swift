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
    static let sortDescriptorsForSections: [SortDescriptor<ProductSection>] = [SortDescriptor(\ProductSection.order, order: .forward), SortDescriptor(\ProductSection.timestamp, order: .reverse)]
    @State private var selectedItem = 0
    
    @Query(sort: sortDescriptorsForSections) private var productSections: [ProductSection]
    @Query(filter:#Predicate<Product> { $0.section == nil }, sort: sortDescriptors) private var productsWithoutSection: [Product]
    
    var body: some View {
        NavigationSplitView {
            TabView(selection: $selectedItem) {
                ForEach(0..<productSections.count, id: \.self) { index in
                    ProductList(products: productSections[index].products).tag(index)
                }
                ProductList(products: productsWithoutSection).tag(productSections.count)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
//            .navigationTitle("Products")
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
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Product(name: "QQQ product")
            if selectedItem < productSections.count {            
                newItem.section = productSections[selectedItem]
            }
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
