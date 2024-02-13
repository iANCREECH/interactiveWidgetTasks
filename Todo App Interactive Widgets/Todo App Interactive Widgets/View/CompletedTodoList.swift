//
//  CompletedTodoList.swift
//  Todo App Interactive Widgets
//
//  Created by Ian Creech on 2024/02/01.
//

import SwiftUI
import SwiftData

struct CompletedTodoList: View {
    @Query private var completedList: [Todo]
    @Binding var showAll: Bool
    
    // Max amount of recent tasks to be shown
    let maxRecents = 5
    
    init(showAll: Binding<Bool>) {
        let predicate = #Predicate<Todo> { $0.isCompleted }
        let sort = [SortDescriptor(\Todo.lastUpdated, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        if !showAll.wrappedValue {
            descriptor.fetchLimit = 5
        }
        
        _completedList = Query(descriptor, animation: .snappy)
        _showAll = showAll
    }

    var body: some View {
        Section {
            ForEach(completedList) {
                TodoRowView(todo: $0)
            }
        } header: {
            HStack {
                Text("Completed tasks")
                
                Spacer(minLength: 0)
                
                if showAll && !completedList.isEmpty {
                    Button {
                        showAll = false
                    } label: {
                         Image(systemName: "chevron.up")
                    }
                }
            }
        } footer: {
            if completedList.count > 5 && !showAll && !completedList.isEmpty {
                HStack {
                    Text("Showing recent \(5) tasks")
                        .foregroundStyle(.gray)
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        showAll = true
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.subheadline)
                            .bold()
                    }
                }
                .font(.caption)
            }
        }
    }
    
    var completedSectionHeader: String {
        let count = completedList.count
        return count == 0 ? "Completed tasks" : "Completed tasks: (\(count))"
    }
}

#Preview {
    ContentView()
}
