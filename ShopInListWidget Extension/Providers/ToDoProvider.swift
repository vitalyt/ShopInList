//
//  ToDoProvider.swift
//  ShopInListWidget ExtensionExtension
//
//  Created by Vitalii Todorovych on 29.02.2024.
//

import Foundation
import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let items: [ProductItem]
}

struct ToDoProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), items: [ProductItem(task: "😀")])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), items: [ProductItem(task: "😀")])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []
        let itemsPerScreen = 3
        let count = 5
        let todoItems: [ProductItem] = DataManager().fetchItems(fetchLimit: itemsPerScreen * count)
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< count {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            var items = [ProductItem]()
            for itemOffset in 0 ..< itemsPerScreen {
                let index = hourOffset * itemsPerScreen + itemOffset
                guard todoItems.count > index else {
                    continue
                }
                items.append(todoItems[index])
            }
            
            let entry = SimpleEntry(date: entryDate, items: items)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
