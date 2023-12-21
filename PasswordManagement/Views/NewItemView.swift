//
//  NewItemView.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 20/12/23.
//

import Foundation
import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State var value = 0.0
    var body: some View {
        ScrollView {
            VStack (spacing: 2){
                Text("New Login Info")
                    .bold()
                    .font(.system(size: 30))
                    .padding()
                // Website
                
                FormView(title: "Website", variable: $viewModel.website, secure: false)
                
                FormView(title: "Username", variable: $viewModel.username, secure: false)
                
                FormView(title: "Password", variable: $viewModel.password, secure: true)
                
                
                Text("Subscription")
                    .bold()
                    .padding()
                
                Picker("Select", selection: $viewModel.subscription) {
                    Text("Yes").tag(true)
                    Text("No").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .frame(maxWidth: 320)
                
                
                if viewModel.subscription {
                    Text("Select End Date")
                        .bold()
                        .padding()
                    DatePicker("", selection: $viewModel.subscription_date, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                        .padding(.horizontal)
                        .frame(width: 100)
                        
                }
                
                FormView(title: "Name", variable: $viewModel.name, secure: false)
                
                FormView(title: "Last Name", variable: $viewModel.last_name, secure: false)
                
                FormView(title: "Address", variable: $viewModel.address, secure: false)
                
                LoginButtonView(title: "Save", 
                                background: .pink) {
                    viewModel.save()
                }
                .padding(20)
            }
            
        }
    }
}

#Preview {
    NewItemView()
}
