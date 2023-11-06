//
//  SectionList.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 04.09.2023.
//

import SwiftUI
import SwiftData

struct CDSectionList: View {
    var model: CDProduct
    let didSelect: ((_ item: CDProductSection) -> Void)?
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.dismiss) private var dismiss
    
    static let sortDescriptors: [SortDescriptor<CDProductSection>] = [SortDescriptor(\CDProductSection.order, order: .forward), SortDescriptor(\CDProductSection.timestamp, order: .reverse)]
    @FetchRequest(sortDescriptors: sortDescriptors) private var items: FetchedResults<CDProductSection>
    
    init(model: CDProduct, didSelect: ((_ item: CDProductSection) -> Void)? = nil) {
        self.model = model
        self.didSelect = didSelect
    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink {
                    CDProductSectionEditView(model: item)
                } label: {
                    let isSelected = self.model.section == item
                    CDProductSectionListItemView(model: item, editable: true, isSelected: isSelected) { item in
                        self.didSelect?(item)
                        self.dismiss()
                    }
                }
            }
#if os(iOS)
            .onDelete(perform: { offsets in
                delete(items: Array(items), offsets: offsets)
            })
            .onMove { offsets, index in
                moveItems(items: Array(items), offsets: offsets, index: Int64(index))
            }
#endif
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
            let newItem = CDProductSection(context: managedObjectContext)
            newItem.name = "Vegetables"
            managedObjectContext.insert(newItem)
            CoreDataStack.shared.save()
        }
    }

    private func doneAction() {
        withAnimation {
            let selectedSections = items.filter({ $0.isSelected })
            model.section = selectedSections.first
            selectedSections.forEach({ $0.isSelected = false })
            CoreDataStack.shared.save()
            dismiss()
        }
    }
    
    private func delete(items: [CDProductSection], offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                managedObjectContext.delete(items[index])
            }
        }
    }
    
    private func moveItems(items: [CDProductSection], offsets: IndexSet, index: Int64) {
        withAnimation {
            var items = items
            items.move(fromOffsets: offsets, toOffset: Int(index))
            for (index, item) in items.enumerated() {
                item.order = Int64(index)
            }
        }
    }
}


