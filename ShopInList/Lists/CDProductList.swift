//
//  ProductList.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 14.09.2023.
//

import SwiftUI
import SwiftData
import CoreData

struct CDProductList: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest private var products: FetchedResults<CDProduct>
    @State private var showingAlert = false
    
    @State private var confettiCounter: Int = 0
    
    private static let sortDescriptors: [SortDescriptor<CDProduct>] = [SortDescriptor(\CDProduct.order, order: .forward), SortDescriptor(\CDProduct.timestamp, order: .reverse)]
    
    init(predicate: NSPredicate?) {
        self._products = FetchRequest<CDProduct>(sortDescriptors: Self.sortDescriptors, predicate: predicate)
//        fetchAllItems()
    }
    
    func fetchAllItems() {
//        let fetchRequest: NSFetchRequest<CDProductImage> = CDProductImage.fetchRequest()
//        fetchRequest.sortDescriptors = [//NSSortDescriptor(key: "section", ascending: true),
////                                        NSSortDescriptor(key: "order", ascending: true),
//                                        NSSortDescriptor(key: "product", ascending: true),
////                                        NSSortDescriptor(key: "timestamp", ascending: false),
//        ]
//        if let results = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(fetchRequest) {
//            print(results.compactMap({ print("-->\($0.product?.name)") }))
//            
//            results.forEach { section in
//                if section.product == nil {
//                    CoreDataStack.shared.persistentContainer.viewContext.delete(section)
//                    try? CoreDataStack.shared.persistentContainer.viewContext.save()
//                }
//            }
//        }
        
        
        
        
//        var data = Double()
//        if let results = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(fetchRequest) {
//            print(results.compactMap({ print("-->\($0.section!.name!)->\($0.name!)->\($0.order)") }))
//            let items = results.compactMap({ entity in
//                
////                if let sectionName = entity.section!.name {
////                    print("-->\(sectionName)->\(entity.name!)->\(entity.order)")
////                } else {
////                    print("--> WRONG\(entity.name)")
////                }
//                
//                
//                data = data + Double(entity.image?.imageData?.count ?? 0)
//                let bcf = ByteCountFormatter()
//                bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
//                bcf.countStyle = .file
//                let byteCount = Int64(Double(entity.image?.imageData?.count ?? 0))
//                let string = bcf.string(fromByteCount: byteCount)
//                
//                if Float(byteCount) / 1000000 > 0.2 {
//                    print("---->\(entity.name) == \(string)")
//                    if let image = entity.image {
//                   //     CoreDataStack.shared.persistentContainer.viewContext.delete(image)
//                    }
//                }
//                print("formatted result: \(string)")
//                return entity
//            })
//            print(data)
//            print("There were \(data) bytes")
//                   let bcf = ByteCountFormatter()
//                   bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
//                   bcf.countStyle = .file
//                   let string = bcf.string(fromByteCount: Int64(data))
//                   print("formatted result: \(string)")
//        }
//        do {
////            try CoreDataStack.shared.persistentContainer.viewContext.save()
//        } catch let error {
//            print(error)
//        }
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
                        CDProductListItemView(model: item, confettiCounter: $confettiCounter)
                    }
                }
#if os(iOS)
                .onMove { offsets, index in
                    moveItems(items: items, offsets: offsets, index: Int64(index))
                }
#endif
            }
            Section(header: Text("Done")) {
                ForEach(selectedItems) { item in
                    NavigationLink {
                        CDEditView(model: item)
                    } label: {
                        CDProductListItemView(model: item, confettiCounter: $confettiCounter)
                    }
                }
#if os(iOS)
                .onMove { offsets, index in
                    moveItems(items: selectedItems, offsets: offsets, index: Int64(index))
                }
#endif
            }
        }
#if os(iOS)
        .confettiCannon(counter: $confettiCounter, num: 75, confettis: [.text("💵"), .text("💶"), .text("💷"), .text("💴")], radius: 500)
#elseif os(watchOS)
        .confettiCannon(counter: $confettiCounter, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
#endif
        .navigationTitle(products.first?.section?.name ?? "Unknown")
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
