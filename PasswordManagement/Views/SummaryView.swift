import Foundation
import SwiftUI
import SwiftData
import Charts

struct ChartElement: Identifiable {
    
    let id = UUID()
    let name: String
    let access: [ChartElement]?
    let associated_KI: KeychainItem?
    let Icon: String?
    let customColor: Color
    
    init(name: String, access: [ChartElement]? = nil, associated_KI: KeychainItem? = nil, Icon: String? = nil, customColor: Color) {
            self.name = name
            self.access = access
            self.associated_KI = associated_KI
            self.Icon = Icon
            self.customColor = customColor
        }
}

struct SummaryView: View {
    
    @Environment(\.modelContext) var context
    @Query private var items: [LoginInfoItem]
    @State var is_expanded = false
    @StateObject var Keychain = KeychainManager()
    @State var keychain_elements: [KeychainItem] = []
    
    var body: some View {
        let keychain_elements = items.compactMap { get_keychain_info(for: $0.id) }
        
        let chartElements1 = keychain_elements.filter{$0.subscription}.compactMap { item in
                    ChartElement(name: item.website, access: nil, associated_KI: item, Icon: nil, customColor: shade1)
        }
        let chartElements2 = keychain_elements.filter{$0.date_of_birth}.compactMap { item in
            ChartElement(name: item.website, access: nil, associated_KI: item, Icon: nil, customColor: shade2)
        }
        let chartElements3 = keychain_elements.filter{$0.address}.compactMap { item in
            ChartElement(name: item.website, access: nil, associated_KI: item, Icon: nil, customColor: shade3)
        }
        let chartElements4 = keychain_elements.filter{$0.credit_card}.compactMap { item in
            ChartElement(name: item.website, access: nil, associated_KI: item, Icon: nil, customColor: shade4)
        }
        let chartElements5 = keychain_elements.filter{$0.full_name}.compactMap { item in
            ChartElement(name: item.website, access: nil, associated_KI: item, Icon: nil, customColor: shade5)
        }
        
        
        let data: [ChartElement] = [
            ChartElement(name: "Subscriptions", access: chartElements1, associated_KI: nil, Icon: "calendar", customColor: shade1),
            ChartElement(name: "Date of Birth", access: chartElements2, associated_KI: nil, Icon: "gift", customColor: shade2),
            ChartElement(name: "Address", access: chartElements3, associated_KI: nil, Icon: "house", customColor: shade3),
            ChartElement(name: "Credit Card", access: chartElements4, associated_KI: nil, Icon: "creditcard", customColor: shade4),
            ChartElement(name: "Full Name", access: chartElements5, associated_KI: nil, Icon: "person", customColor: shade5)
        ]
        
        NavigationView {
            VStack {
                Text("Summary").font(.title.weight(.semibold))
                    .foregroundColor(shade2)
                    .padding()
                
                Chart(data) { item in
                    BarMark(
                        x: .value("Number of Websites", item.access?.count ?? 0),
                        y: .value("Category", item.name)
                    )
                    .foregroundStyle(item.customColor)
                    .annotation(position: .trailing) {
                        Text("\(item.access?.count ?? 0)")
                            .font(.caption)
                            .bold()
                            .foregroundColor(item.customColor)
                    }
                }
                .padding()
                .frame(maxWidth: 500)
                .aspectRatio(1, contentMode: .fit)
                .chartXScale(domain: 0...items.count)
                .frame(width: 500, height: 350)

                HStack {
                    ForEach(data, id: \.name) { item in
                        HStack {
                            Circle()
                                .fill(item.customColor)
                                .frame(width: 10, height: 10)
                            Text(item.name)
                                .font(.system(size: 10))
                        }
                    }
                }
                .padding(.horizontal)
                
                List{
                    
                    OutlineGroup(data, children:\.access) {item in
                        HStack {
                            
                            if let icon = item.Icon {
                                        Image(systemName: icon)
                                            .foregroundColor(.blue)
                                    }
        
                            if let unwrapped_value = item.associated_KI {
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(unwrapped_value.website)")
                                            .font(.headline)
                                        
                                        Text("\(unwrapped_value.username)")
                                            .font(.subheadline)
                                }
                            } else {
                                Text("\(item.name): \(item.access?.count ?? 0)")
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .background(Color.white)
            }
        }
         
    }
    func get_keychain_info(for id: String) -> KeychainItem? {
            return Keychain.get(id: id)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LoginInfoItem.self, configurations: config)

    return SummaryView()
            .modelContainer(container)
}

