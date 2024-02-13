//
//  Home.swift
//  Todo App Interactive Widgets
//
//  Created by Ian Creech on 2024/02/01.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Query(filter: #Predicate<Todo> { !$0.isCompleted }, sort: [SortDescriptor(\Todo.lastUpdated, order: .reverse)], animation: .snappy) private var activeList: [Todo]
    
    @Environment(\.modelContext) private var context
    @State private var showAll: Bool = false
    
    var body: some View {
        List {
            Section(activeSectionTitle) {
                ForEach(activeList) {
                    TodoRowView(todo: $0)
                }
            }
            
            CompletedTodoList(showAll: $showAll)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    let todo = Todo(task: "", priorityLevel: .normal)
                    
                    context.insert(todo)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    var activeSectionTitle: String {
        let count = activeList.count
        return count == 0 ? "Active tasks" : "Active tasks: (\(count))"
    }
}

#Preview {
//    HomeView()
    ContentView()
}
