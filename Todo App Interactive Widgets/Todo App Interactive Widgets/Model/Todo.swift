//
//  Todo.swift
//  Todo App Interactive Widgets
//
//  Created by Ian Creech on 2024/02/01.
//

import SwiftUI
import SwiftData

@Model
class Todo {
    private(set) var taskID: String = UUID().uuidString
    var task: String
    var isCompleted: Bool = false
    var priorityLevel: PriorityLevel = PriorityLevel.normal
    var lastUpdated: Date = Date.now
    
    init(task: String, priorityLevel: PriorityLevel) {
        self.task = task
        self.priorityLevel = priorityLevel
    }
}

// Priority level
enum PriorityLevel: String, CaseIterable, Codable {
    case normal = "Normal"
    case medium = "Medium"
    case high = "High"
    
    // Colors for Priority level
    var color: Color {
        switch self {
        case .normal:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
    
    var priortyIndicator: String {
        switch self {
        case .normal:
            return "!"
        case .medium:
            return "!!"
        case .high:
            return "!!!"
        }
    }
    
}
