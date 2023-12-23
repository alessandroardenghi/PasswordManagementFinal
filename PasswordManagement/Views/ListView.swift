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
    
    var body: some View {
        
        NavigationView {
            VStack {
                List {
                    ForEach(items) {item in
                        NavigationLink(destination: DetailView(variable: item)) {
                            VStack(alignment: .leading) {
                                Text("\(item.website)")
                                    .font(.headline)
                                    
                                Text("\(item.username)")
                                    .font(.subheadline)
                                    
                            }
                        }
                    }
                    .onDelete {indexes in
                        for index in indexes {
                            delete_items(item: items[index])
                        }
                    }
                    
                }
                
            }
            .navigationTitle("Login Info")
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
    
    func delete_items(item: LoginInfoItem) {
        context.delete(item)
    }

}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LoginInfoItem.self, configurations: config)

    return ListView()
            .modelContainer(container)
}
