//
//  TodoWidget.swift
//  TodoWidget
//
//  Created by Apps4World on 9/21/23.
//

import WidgetKit
import SwiftUI

struct TodoWidgetEntryView : View {
    var entry: ToDoProvider.Entry
    let todoItems: [ProductItem] = DataManager().todoItems

    var body: some View {
        VStack {
            ForEach(0..<entry.items.count, id: \.self) { index in
                Button(intent: TodoIntent(item: entry.items[index].taskName)) {
                    Label(entry.items[index].taskName, systemImage: "circle\(entry.items[index].isCompleted ? ".fill" : "")")
                        .frame(maxWidth: .infinity, alignment: .leading).contentShape(Rectangle())
                }
            }.lineLimit(1)
            Spacer()
//            ForEach(0..<todoItems.count, id: \.self) { index in
//                Button(intent: TodoIntent(item: todoItems[index].taskName)) {
//                    Label(todoItems[index].taskName, systemImage: "circle\(todoItems[index].isCompleted ? ".fill" : "")")
//                        .frame(maxWidth: .infinity, alignment: .leading).contentShape(Rectangle())
//                }
//            }.lineLimit(1)
//            Spacer()
        }
    }
}
