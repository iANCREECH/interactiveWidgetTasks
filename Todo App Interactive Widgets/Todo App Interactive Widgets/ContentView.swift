//
//  ContentView.swift
//  Todo App Interactive Widgets
//
//  Created by Ian Creech on 2024/02/01.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HStack(spacing: 5) {
                            Image(systemName: "checkmark.square")
                                .fontWeight(.medium)
                                .font(.title2)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.black, .blue)
                            Text("Tasks")
                                .font(.title)
                                .bold()
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
