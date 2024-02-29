//
//  TodoItem.swift
//  TodoList
//
//  Created by Apps4World on 12/18/21.
//

import UIKit
import SwiftUI

/// A simple model to keep track of tasks
class ProductItem: NSObject, ObservableObject, Identifiable {
    var taskName: String
    @Published var isCompleted: Bool = false
    
    init(task: String) {
        taskName = task
    }
}
