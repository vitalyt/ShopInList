//
//  TodoIntent.swift
//  TodoList
//
//  Created by Apps4World on 9/21/23.
//

import Foundation
import AppIntents
import WidgetKit

struct TodoIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Complete Task"
    static var description: IntentDescription = IntentDescription("Complete selected task")
    
    @Parameter(title: "TodoItem")
    var item: String
    
    init() { }
    init(item: String) {
        self.item = item
    }
    
    func perform() async throws -> some IntentResult {
        DataManager.updateStatus(forTask: item)
        return .result()
    }
}
