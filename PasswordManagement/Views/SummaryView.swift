//
//  SummaryView.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 29/12/23.
//

import Foundation
import SwiftUI
import SwiftData
import Charts


struct ChartElement: Identifiable {
    
    let id = UUID()
    let name: String
    let access: [ChartElement]?
    let associated_LIT: LoginInfoItem?
    let Icon: String?
}



struct SummaryView: View {
    
    @Environment(\.modelContext) var context
    @Query private var items: [LoginInfoItem]
    @State var is_expanded = false
    var body: some View {
        
        let chartElements1: [ChartElement] = items.filter{$0.subscription}.compactMap { item in
            ChartElement(name: item.website, access: nil, associated_LIT: item, Icon: nil)
        }
        
        
        let chartElements2: [ChartElement] = items.filter{$0.date_of_birth}.compactMap { item in
            ChartElement(name: item.website, access: nil, associated_LIT: item, Icon: nil)
        }
        
        let chartElements3: [ChartElement] = items.filter{$0.address}.compactMap { item in
            ChartElement(name: item.website, access: nil, associated_LIT: item, Icon: nil)
        }
        
        let chartElements4: [ChartElement] = items.filter{$0.credit_card}.compactMap { item in
            ChartElement(name: item.website, access: nil, associated_LIT: item, Icon: nil)
        }
        
        let chartElements5: [ChartElement] = items.filter{$0.full_name}.compactMap { item in
            ChartElement(name: item.website, access: nil, associated_LIT: item, Icon: nil)
        }
        
        
        let data: [ChartElement] = [
            ChartElement(name: "Subscriptions", access: chartElements1, associated_LIT: nil, Icon: "calendar"),
            ChartElement(name: "Date of Birth", access: chartElements2, associated_LIT: nil, Icon: "gift"),
            ChartElement(name: "Address", access: chartElements3, associated_LIT: nil, Icon: "house"),
            ChartElement(name: "Credit Card", access: chartElements4, associated_LIT: nil, Icon: "creditcard"),
            ChartElement(name: "Full Name", access: chartElements5, associated_LIT: nil, Icon: "person")]
        
        
        
        NavigationView {
            VStack {
                Text("Summary")
                    .bold()
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding()
                
                Chart(data) {item in
                    BarMark(x: .value("Number of Websites", item.access?.count ?? 0),
                            y: .value("Category", item.name))
                    .foregroundStyle(by: .value("Name", item.name))
                    .annotation(position: .trailing) {
                        Text("\(item.access?.count ?? 0)")
                    }
                }
                .padding()
                .aspectRatio(1, contentMode: .fit)
                .chartXScale(domain: 0...items.count)
                .frame(width: 500, height: 350)
                
                
                List{
                    
                    OutlineGroup(data, children:\.access) {item in
                        HStack {
                            
                            if let icon = item.Icon {
                                        Image(systemName: icon)
                                            .foregroundColor(.blue) // Customize icon color if needed
                                    }
        
                            if var unwrapped_value = item.associated_LIT {
                                NavigationLink(destination: DetailView(variable: unwrapped_value)) {
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(unwrapped_value.website)")
                                            .font(.headline)
                                        
                                        Text("\(unwrapped_value.username)")
                                            .font(.subheadline)
                                    }
                                }
                            } else {
                                Text("\(item.name): \(item.access?.count ?? 0)")
                            }
                    
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LoginInfoItem.self, configurations: config)

    return SummaryView()
            .modelContainer(container)
}

