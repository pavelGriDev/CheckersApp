//
//  ContentView.swift
//  CheckersApp
//
//  Created by Pavel Gritskov on 11.06.25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = ContentViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text(vm.connectionStatus)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(vm.message)
                .font(.title)
            
            Spacer()
            
            Button(action: vm.sendMessageAction, label: {
                Text("Send message")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.green)
                    .clipShape(Capsule())
            })
            .bold()
            .padding(.bottom, 15)
            
            HStack {
                Button(action: vm.connectAction, label: {
                    Text("Connect")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.blue)
                        .clipShape(Capsule())
                })
                
                Button(action: vm.disconnectAction, label: {
                    Text("Disconnect")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.red)
                        .clipShape(Capsule())
                })
            }
            .foregroundStyle(.white)
        }
        .padding()
        .onAppear { vm.onAppear() }
    }
}

#Preview {
    ContentView()
}
