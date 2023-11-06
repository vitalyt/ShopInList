//
//  ProductList.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 14.09.2023.
//

import SwiftUI
import SwiftData

struct CDProductList: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest private var products: FetchedResults<CDProduct>
    @State private var showingAlert = false
    
    private static let sortDescriptors: [SortDescriptor<CDProduct>] = [SortDescriptor(\CDProduct.order, order: .forward), SortDescriptor(\CDProduct.timestamp, order: .reverse)]
    
    init(predicate: NSPredicate?) {
        self._products = FetchRequest<CDProduct>(sortDescriptors: Self.sortDescriptors, predicate: predicate)
    }
    
    var body: some View {
        let items = products.filter({ !$0.isSelected }).sorted(using: Self.sortDescriptors)
        let selectedItems = products.filter({ $0.isSelected }).sorted(using: Self.sortDescriptors)
        
        List() {
            Section( header: Text("Products")) {
                ForEach(items) { item in
                    NavigationLink {
                        CDEditView(model: item)
                    } label: {
                        CDProductListItemView(model: item)
                    }
#if os(iOS)
                    .swipeActions(edge: .trailing) {
                        deleteButton(item: item)
                    }
                    .alert(isPresented:$showingAlert) {
                        deleteAlert(item: item)
                    }
#endif
                }
#if os(iOS)
                .onDelete(perform: { offsets in
                    delete(items: selectedItems, offsets: offsets)
                })
                .onMove { offsets, index in
                    moveItems(items: selectedItems, offsets: offsets, index: Int64(index))
                }
#endif
            }
            Section(header: Text("Selected Products")) {
                ForEach(selectedItems) { item in
                    NavigationLink {
#if os(iOS)
                        CDEditView(model: item)
#endif
                    } label: {
                        CDProductListItemView(model: item)
                    }
#if os(iOS)
                    .swipeActions(edge: .trailing) {
                        deleteButton(item: item)
                    }
                    .alert(isPresented:$showingAlert) {
                        deleteAlert(item: item)
                    }
#endif
                }
#if os(iOS)
                .onDelete(perform: { offsets in
                    delete(items: selectedItems, offsets: offsets)
                })
                .onMove { offsets, index in
                    moveItems(items: selectedItems, offsets: offsets, index: Int64(index))
                }
#endif
            }
        }.navigationTitle(products.first?.section?.name ?? "Unknown")
    }

    private func getShare() {
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
                delete(item: items[index])
            }
        })
    }
    
    private func delete(item: CDProduct) {
        withAnimation(.easeInOut, {
            managedObjectContext.delete(item)
            CoreDataStack.shared.save()
        })
    }
    
    private func deleteButton(item: CDProduct) -> Button <Label<Text, Image>> {
        Button(role: .destructive, action: {
            if item.section != nil {
                showingAlert = true
            } else {
                delete(item: item)
            }
        } ) {
            Label("Delete!", systemImage: "trash")
        }
    }
    
    private func deleteAlert(item: CDProduct) -> Alert {
        Alert(
            title: Text("Are you sure you want to delete this?"),
            primaryButton: .destructive(Text("Delete")) {
                delete(item: item)
            },
            secondaryButton: .cancel()
        )
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
