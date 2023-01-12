//
//  ContentView.swift
//  WebsocketTest
//
//  Created by 董 亜飛 on 2023/01/12.
//

import SwiftUI
import SocketIO

struct ContentView: View {
    let manager = SocketManager(socketURL: URL(string:"http://localhost:8080/")!, config: [.log(true), .compress])
    @State var socket: SocketIOClient!
    @State var dataList: [String] = []
    
    var body: some View {
        VStack(spacing: 16) {
            List {
                ForEach(dataList, id: \.self) { data in
                    Text(data)
                }
            }
            .listStyle(.plain)
            
            Button("Tap") { socket.emit("from_client", "button pushed!!") }
            Button("Connect") { socket.connect() }
            Button("Disconnect") { socket.disconnect() }
        }
        .padding()
        .onAppear {
            socket = manager.defaultSocket
            
            socket.on(clientEvent: .connect) { data, ack in
                print("Socket connected")
            }
            
            socket.on(clientEvent: .disconnect) { data, ack in
                print("Socket disconnected")
            }
            
            socket.on("from_server") { data, ack in
                if let message = data as? [String] {
                    print(message[0])
                    dataList.insert(message[0], at: 0)
                }
            }
            
            socket.connect()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
