//
//  ShopInListWidget_ExtensionLiveActivity.swift
//  ShopInListWidget Extension
//
//  Created by Vitalii Todorovych on 09.12.2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ShopInListWidget_ExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ShopInListWidget_ExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ShopInListWidget_ExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ShopInListWidget_ExtensionAttributes {
    fileprivate static var preview: ShopInListWidget_ExtensionAttributes {
        ShopInListWidget_ExtensionAttributes(name: "World")
    }
}

extension ShopInListWidget_ExtensionAttributes.ContentState {
    fileprivate static var smiley: ShopInListWidget_ExtensionAttributes.ContentState {
        ShopInListWidget_ExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ShopInListWidget_ExtensionAttributes.ContentState {
         ShopInListWidget_ExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ShopInListWidget_ExtensionAttributes.preview) {
   ShopInListWidget_ExtensionLiveActivity()
} contentStates: {
    ShopInListWidget_ExtensionAttributes.ContentState.smiley
    ShopInListWidget_ExtensionAttributes.ContentState.starEyes
}
