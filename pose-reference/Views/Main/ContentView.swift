//
//  ContentView.swift
//  pose-reference
//
//  Created by josiah on 2021-10-17.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var prefs: Settings
    @EnvironmentObject var timeObject: TimerObject
    
    //@Environment(\.presentationMode) var presentationMode
    
    @State private var startSession = false
    @State private var showNavBar = true
    
    var body: some View {
        VStack{
            if !startSession {
                HomeDetails(startSession: $startSession)
                 //   .frame(maxWidth: .infinity, maxHeight: .infinity)
                  //  .background(Color.blue)
                 //   .transition(AnyTransition.move(edge: .leading)).animation(.default)
                 
            }
            if startSession {
                PhotoButtonsView(startSession: $startSession, showNavBar: $showNavBar)
                   // .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //.background(Color.green)
                 //   .transition(AnyTransition.move(edge: .trailing)).animation(.default)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Settings())
    }
}
