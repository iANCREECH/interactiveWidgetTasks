//
//  Todo_App_Interactive_WidgetsApp.swift
//  Todo App Interactive Widgets
//
//  Created by Ian Creech on 2024/02/01.
//

import SwiftUI
import SwiftData

@main
struct Todo_App_Interactive_WidgetsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Todo.self)
    }
}
