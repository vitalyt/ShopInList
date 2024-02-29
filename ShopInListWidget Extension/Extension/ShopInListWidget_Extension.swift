//
//  ShopInListWidget_Extension.swift
//  ShopInListWidget Extension
//
//  Created by Vitalii Todorovych on 09.12.2023.
//

import WidgetKit
import SwiftUI
import SwiftData

struct ShopInListWidget_Extension: Widget {
    let kind: String = "ShopInListWidget_Extension"
    let todoItems: [ProductItem] = DataManager().todoItems

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
