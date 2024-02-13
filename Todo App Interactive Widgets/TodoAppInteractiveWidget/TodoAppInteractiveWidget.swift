//
//  TodoAppInteractiveWidget.swift
//  TodoAppInteractiveWidget
//
//  Created by Ian Creech on 2024/02/03.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: .now)
        entries.append(entry)
        

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    
}

struct TodoAppInteractiveWidgetEntryView : View {
    var entry: Provider.Entry
    
    // This query will only fetch three active tasks at once
    @Query(todoDescriptor, animation: .snappy) private var activeList: [Todo]

    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 5) {
                Image(systemName: "checkmark.square")
                    .fontWeight(.medium)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.black, .blue)
                Text("Tasks")
                    .bold()
                Spacer(minLength: 0)
                
                Text("\(activeList.count)")
                    .font(.caption)
            }
            
            ForEach(activeList) { todo in
                HStack(spacing: 10) {
                    Button(intent: ToggleButton(id: todo.taskID)) {
                        Image(systemName: "square")
                            .foregroundStyle(todo.priorityLevel.color)
                            .font(.headline)
                    }
                    .tint(.clear)
//                    .font(.caption)
                    
                    
                    Text(todo.task)
                        .font(.caption)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                    Text(todo.priorityLevel.priortyIndicator)
                        .font(.caption)
                        .foregroundStyle(todo.priorityLevel.color)
                }
                .transition(.push(from: .bottom))
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if activeList.isEmpty {
                Text("All done")
                    .foregroundStyle(.secondary)
                    .font(.callout)
                    .transition(.push(from: .bottom))
            }
        }
    }
    
    static var todoDescriptor: FetchDescriptor<Todo> {
        let predicate = #Predicate<Todo> { !$0.isCompleted }
        let sort = [SortDescriptor(\Todo.lastUpdated, order: .reverse)]
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 3
        return descriptor
    }
}

struct TodoAppInteractiveWidget: Widget {
    let kind: String = "TodoAppInteractiveWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoAppInteractiveWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
            
                // Data container
                .modelContainer(for: Todo.self)
        }
        .supportedFamilies([.systemMedium, .systemLarge])
        .configurationDisplayName("Tasks")
        .description("This is your list of tasks.")
    }
}

#Preview(as: .systemSmall) {
    TodoAppInteractiveWidget()
} timeline: {
    SimpleEntry(date: .now)
}

struct ToggleButton: AppIntent {
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggles Task's State")
    
    @Parameter(title: "Task ID") var id: String
    
    init() {
        
    }
    
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        let context = try ModelContext(.init(for: Todo.self)) // update
        
        // Retrieve
        let descriptor = FetchDescriptor(predicate: #Predicate<Todo> { $0.taskID == id })
        if let todo = try context.fetch(descriptor).first {
            todo.isCompleted = true
            todo.lastUpdated = .now
            try context.save()
            
        }
        return .result()
    }
}
