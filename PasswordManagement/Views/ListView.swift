//
//  ListView.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 19/12/23.
//

import Foundation
import SwiftUI
import SwiftData

struct ListView: View {
    @State private var new_item = false
    @Environment(\.modelContext) var context
    @StateObject var viewModel = ListViewViewModel()
    @Query private var items: [LoginInfoItem]
    @State var search: String = ""
    
    var body: some View {
        
        NavigationView {
                List {
                    ForEach(searchable_items) {item in
                        NavigationLink(destination: DetailView(variable: item)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(item.website)")
                                        .font(.headline)
                                    
                                    Text("\(item.username)")
                                        .font(.subheadline)
                                    
                                }
                                Spacer()
                                Image(systemName: item.bookmark ? "bookmark.fill" : "bookmark")
                                    .foregroundColor(.blue)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    context.delete(item)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                            .swipeActions {
                                Button() {
                                    item.bookmark.toggle()
                                } label: {
                                    Label("Bookmark", systemImage: "bookmark.fill")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                
            }
            .navigationTitle("Login Info")
            .searchable(text: $search)
            .toolbar {
                Button {
                    viewModel.new_item = true
                }
            label: {
                Image(systemName: "plus")
            }
            .sheet(isPresented: $viewModel.new_item) {
                NewItemView(new_item_inserted: $viewModel.new_item)
            }

                
            }
        }
    }
    
    var sorted_items: [LoginInfoItem] {
            let trueConditionItems = items.filter { $0.bookmark }
            let falseConditionItems = items.filter { !$0.bookmark }
            return trueConditionItems + falseConditionItems
        }
    
    var searchable_items: [LoginInfoItem] {
            if search.isEmpty {
                return sorted_items
            } else {
                return sorted_items.filter { $0.website.lowercased().contains(search.lowercased()) }
            }
        }

}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LoginInfoItem.self, configurations: config)

    return ListView()
            .modelContainer(container)
}
