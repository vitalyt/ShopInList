//
//  TodoWidget.swift
//  TodoWidget
//
//  Created by Apps4World on 9/21/23.
//

import WidgetKit
import SwiftUI

struct ToDoProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<TaskEntry> {
      let entry = TaskEntry(date: Date(), task: configuration.taskEntity.task)

      return Timeline(entries: [entry], policy: .never)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}



struct TodoWidgetEntryView : View {
    var entry: ToDoProvider.Entry
    let todoItems: [ProductItem] = DataManager().todoItems
//    let todoItems: [ProductItem] = [ProductItem(task: "sdf"), ProductItem(task: "sdf22")]
    
    var body: some View {
        VStack {
            ForEach(0..<todoItems.count, id: \.self) { index in
                Button(intent: TodoIntent(item: todoItems[index].taskName)) {
                    Label(todoItems[index].taskName, systemImage: "circle\(todoItems[index].isCompleted ? ".fill" : "")")
                        .frame(maxWidth: .infinity, alignment: .leading).contentShape(Rectangle())
                }
            }.lineLimit(1)
            Spacer()
        }
    }
}




struct TodoWidget: Widget {
    let kind: String = "TodoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ToDoProvider()) { entry in
            if #available(iOS 17.0, *) {
                TodoWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TodoWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    TodoWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
