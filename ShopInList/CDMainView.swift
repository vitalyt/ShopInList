//
//  MainView.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 01.09.2023.
//

import SwiftUI
import SwiftData
import CoreData

struct CDMainView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @State private var selectedItem = 0
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\CDProductSection.order, order: .forward), SortDescriptor(\CDProductSection.timestamp, order: .reverse)]) private var productSections: FetchedResults<CDProductSection>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) private var productsWithoutSection: FetchedResults<CDProduct>
    
//    init() {
//        
//    }
    
//    func deleteAllItems() {
//        let fetchRequest: NSFetchRequest<CDProductImage> = CDProductImage.fetchRequest()
//        
//    }
    
//    func fetchAllItems() {
//        let json = """
//{\"Baking\":[\"Bread\"],\"Snakes\":[\"Popcorn\",\"Cheeps S\"],\"Drinks\":[\"Juice banana\",\"Wine S\",\"Coffee (BUSHIDO, Paulig, EGOISTE)\",\"Milk\",\"Hdhdhdhdh\",\"Cola\",\"Beer\",\"Water\",\"Water S\",\"Wine R\",\"Wine W\",\"Whiskey\"],\"Fruits\":[\"Grapes\",\"Apricots\",\"Blueberries\",\"Mandarin\",\"Melon\",\"Apple G\",\"Kiwi\",\"Lime\",\"Passionfruit\",\"Lemon\",\"Orange\",\"Apple R\",\"Raspberries\",\"Mango\",\"Grapes R\",\"Peach\"],\"Meat | Fish\":[\"Minced P\",\"Chicken Breast\",\"Jamon\",\"Chicken Wings\",\"Fish S\",\"Minced B\",\"Fish\",\"Shrimps\",\"Eggs\",\"Bacon\",\"Beef Fillet\",\"Chicken Portions\",\"Leg of Lamb\",\"Mindset Beff\",\"Pork Ribs\",\"Sausages \",\"Steaks\",\"Bastourma\"],\"Vegetables\":[\"Avocado\",\"Potato S\",\"Basil\",\"Parsley\",\"Beetroot\",\"Carrots\",\"Dill\",\"Cucumber\",\"Eggplant\",\"Tomatoes\",\"Radish\",\"Rocket\",\"Sweet corn\",\"Zucchini\",\"Beans\",\"Broccoli\",\"Brussel sprouts\",\"Cabbage, Chinese\",\"Sprague\",\"Salat\",\"Mushrooms\",\"Cauliflower\",\"Cherry\",\"Marrows\",\"Pepper R\",\"Onion R\",\"Sweet Potato\",\"Tomato\",\"Onion\",\"Garlic\",\"Potato\",\"Banana\",\"Watermelon\"],\"Dairy\":[\"Camber\",\"Mozzarella \",\"Brie\",\"Parmesan\",\"Feta\",\"Halloumi\",\"Cheddar \",\"Natural Yoghurt \",\"Stilton Cheese \",\"Chees\"]}
//"""
//        func convertToDictionary(text: String) -> [String: [String]]? {
//            if let data = text.data(using: .utf8) {
//                do {
//                    return try JSONSerialization.jsonObject(with: data, options: []) as? [String: [String]]
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//            return nil
//        }
//        
//        let dic = convertToDictionary(text: json)!
//        let context = managedObjectContext
//        
//        dic.keys.forEach({ key in
//            let values = dic[key]!
//            
//            let newSectionItem = CDProductSection(context: context)
//            newSectionItem.name = key
//            context.insert(newSectionItem)
//            
//            values.forEach { item in
//                let newItem = CDProduct(context: context)
//                
//                newItem.name = item
//                newItem.timestamp = Date()
//                newItem.section = newSectionItem
//                
//                context.insert(newItem)
//            }
//        })
//        
//        CoreDataStack.shared.save()
//    }
//
//    func deleteAllItems() {
//        let fetchRequest: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
////        fetchRequest.fetchLimit = 3
//        fetchRequest.predicate = NSPredicate(format: "section == nil")
//        fetchRequest.sortDescriptors = [//NSSortDescriptor(key: "section", ascending: true),
//                                        NSSortDescriptor(key: "order", ascending: true),
////                                        NSSortDescriptor(key: "timestamp", ascending: false),
//        ]
//        if let results = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(fetchRequest) {
//            print("results count \(results.count)")
//            results.forEach { item in
//                print(item)
//                print(item.section)
//                CoreDataStack.shared.persistentContainer.viewContext.delete(item)
//            }
//            
//            let r = try? CoreDataStack.shared.persistentContainer.viewContext.save()
//            print(r)
//        }
//    }
    
    
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
//        deleteAllItems()
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

