//
//  ShopInListWidget_Extension.swift
//  ShopInListWidget Extension
//
//  Created by Vitalii Todorovych on 09.12.2023.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> TaskEntry {
      return TaskEntry(date: Date(), task: TaskItem(id: "Sample Task"))
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> TaskEntry {
      return TaskEntry(date: Date(), task: configuration.taskEntity.task)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<TaskEntry> {
      let entry = TaskEntry(date: Date(), task: configuration.taskEntity.task)

      return Timeline(entries: [entry], policy: .never)
    }
}

struct TaskEntry: TimelineEntry {
  let date: Date
  let task: TaskItem
//  let tasks: [TaskItem]
}

struct ShopInListWidget_ExtensionEntryView : View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\CDProduct.order, order: .forward), SortDescriptor(\CDProduct.timestamp, order: .reverse)], predicate: NSPredicate(format: "isSelected == false")) private var products: FetchedResults<CDProduct>
    
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
//            Button(intent: ConfigurationAppIntent(taskEntity: TaskEntity(task: entry.task))) {
//                Text(entry.task.id)
//            }
            ForEach(0..<min(products.count, 6), id: \.self) { index in
                let item: CDProduct = products[index]
                let text = (item.isSelected ? "✅" : "") + (item.name ?? "")
                Text(text)
//                let configuration = ConfigurationAppIntent(favoriteEmoji: "sd")
//                configuration.favoriteEmoji = "🤩"
//                Button(intent: configuration) {
//                    Text(text)
//                }
            }
        }
    }
}

struct ShopInListWidget_Extension: Widget {
    let kind: String = "ShopInListWidget_Extension"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, 
                               intent: ConfigurationAppIntent.self, 
                               provider: Provider()
        ) { entry in
            ShopInListWidget_ExtensionEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .environment(\.managedObjectContext, CoreDataStack.shared.context)
//                .modelContainer(for: ProductSection.self, inMemory: true)
        }
    }
}


#Preview(as: .systemSmall) {
    ShopInListWidget_Extension()
} timeline: {
  TaskEntry(date: .now, task: TaskItem(id: "1111"))
  TaskEntry(date: .now, task: TaskItem(id: "2222"))
}
