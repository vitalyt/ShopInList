//
//  ShopInListApp.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 01.09.2023.
//

import SwiftUI
import SwiftData

@main
struct ShopInListApp: App {
#if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
#endif
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Product.self, ProductSection.self, ProductImage.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            CDMainView()
            //            CDProductList()
        }
        .environment(\.managedObjectContext, CoreDataStack.shared.context)
        //        .modelContainer(sharedModelContainer)
    }
}
