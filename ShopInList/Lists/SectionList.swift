//
//  SectionList.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 04.09.2023.
//

import SwiftUI
import SwiftData

struct SectionList: View {
    var model: Product
    let didSelect: ((_ item: ProductSection) -> Void)?
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    static let sortDescriptors: [SortDescriptor<ProductSection>] = [SortDescriptor(\ProductSection.timestamp, order: .reverse)]
    @Query(sort: sortDescriptors) private var items: [ProductSection]
    
    init(model: Product, didSelect: ((_ item: ProductSection) -> Void)? = nil) {
        self.model = model
        self.didSelect = didSelect
    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink {
                    ProductSectionEditView(model: item)
                } label: {
                    let isSelected = self.model.section == item
                    ProductSectionListItemView(model: item, editable: true, isSelected: isSelected) { item in
                        self.didSelect?(item)
                        self.dismiss()
                    }
                }
            }
            .onDelete(perform: { offsets in
                delete(items: items, offsets: offsets)
            })
        }
        .toolbar {
#if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: doneAction) {
                    Label("Done", systemImage: "done")
                }
            }
#endif
            ToolbarItem() {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .navigationTitle("Sections")
    }

    private func addItem() {
        withAnimation {
            let newItem = ProductSection(name: "Vegetables")
            modelContext.insert(newItem)
        }
    }

    private func doneAction() {
        withAnimation {
            let selectedSections = items.filter({ $0.isSelected })
            model.section = selectedSections.first
            selectedSections.forEach({ $0.isSelected = false })
            dismiss()
        }
    }
    
    private func delete(items: [ProductSection], offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    SectionList(model: Product(name: "Test"))
        .modelContainer(for: ProductSection.self, inMemory: true)
}

