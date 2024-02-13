//
//  TodoRowView.swift
//  Todo App Interactive Widgets
//
//  Created by Ian Creech on 2024/02/01.
//

import SwiftUI
import WidgetKit

struct TodoRowView: View {
    @Bindable var todo: Todo
    
    @FocusState private var isActive: Bool
    @Environment (\.modelContext) private var context
    @Environment (\.scenePhase) private var phase
    
    var body: some View {
        HStack(spacing: 8) {
            if !isActive && !todo.task.isEmpty {
                Button {
                    todo.isCompleted.toggle()
                    todo.lastUpdated = .now
                    WidgetCenter.shared.reloadAllTimelines()
                } label: {
                    Image(systemName: todo.isCompleted ? "checkmark.square.fill" : "square")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.isCompleted ? .gray : todo.priorityLevel.color)
                        .contentTransition(.symbolEffect(.replace))
                }
            }
            
            TextField("Task name", text: $todo.task)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .gray : .primary)
                .focused($isActive)
            
            if !isActive && !todo.task.isEmpty {
                Menu {
                    ForEach(PriorityLevel.allCases, id: \.rawValue) { priority in
                        Button {
                            todo.priorityLevel = priority
                        } label: {
                            HStack {
                                Text(priority.rawValue)
                                
                                if todo.priorityLevel == priority { Image(systemName: "checkmark") }
                            }
                        }
                    }
                } label: {
                    Text(todo.priorityLevel.priortyIndicator)
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.isCompleted ? .secondary : todo.priorityLevel.color)
                }
            }
        }
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .animation(.snappy, value: isActive)
        .onAppear {
            isActive = todo.task.isEmpty
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
            Button("", systemImage: "trash") {
                context.delete(todo)
                WidgetCenter.shared.reloadAllTimelines()
            }
            .tint(.red)
        })
        .onSubmit(of: .text) {
            if todo.task.isEmpty {
                context.delete(todo)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && todo.task.isEmpty {
                context.delete(todo)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .task {
            todo.isCompleted = todo.isCompleted
        }
    }
}

#Preview {
    ContentView()
}
