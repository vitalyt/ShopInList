//
//  AppIntent.swift
//  ShopInListWidget Extension
//
//  Created by Vitalii Todorovych on 09.12.2023.
//

import WidgetKit
import AppIntents

import SwiftUI
import SwiftData

//class Counter {
//    @Environment(\.managedObjectContext) private var managedObjectContext
//    @FetchRequest(sortDescriptors: []) private var products: FetchedResults<CDProduct>
//    
//    private static let sharedDefaults: UserDefaults = UserDefaults(suiteName: "group.examples.sjc")!
//    
//     func incrementCount() {
//        let item = products.first
//        item?.isSelected = true
////        var count = sharedDefaults.integer(forKey: "count")
////        count += 1
////        sharedDefaults.set(count, forKey: "count")
//    }
//    
//    static func currentCount() -> Int {
//        sharedDefaults.integer(forKey: "count")
//    }
//}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Progress Task"
    static var description = IntentDescription("Select the task to progress.")

    init() {}

    init(taskEntity: TaskEntity) {
      self.taskEntity = taskEntity
    }

    @Parameter(title: "Task")
    var taskEntity: TaskEntity

    func perform() async throws -> some IntentResult {
//      print(taskEntity)
//        Task {
//            await Counter().incrementCount()
//        }
      return .result()
    }
}

struct TaskEntity: AppEntity {
  var task: TaskItem
  var id: String { task.id }

  static var typeDisplayRepresentation: TypeDisplayRepresentation = "Task"
  static var defaultQuery = TaskQuery()

  var displayRepresentation: DisplayRepresentation {
    DisplayRepresentation(title: "\(task.id)")
  }
}

struct TaskItem: Identifiable, Codable {
    let id: String
}

struct TaskQuery: EntityQuery {
  private var storedTasks: [TaskEntity] {
    [TaskEntity(task: TaskItem(id: "qqq1")), TaskEntity(task: TaskItem(id: "qqqqqq"))]
  }

  func entities(for identifiers: [TaskEntity.ID]) async throws -> [TaskEntity] {
    return storedTasks.filter { identifiers.contains($0.id) }
  }

  func suggestedEntities() async throws -> [TaskEntity] {
    return storedTasks
  }

  func defaultResult() async -> TaskEntity? {
    return nil// try? await suggestedEntities().first ?? TaskEntity(task: TaskItem(id: "default"))
  }
}
