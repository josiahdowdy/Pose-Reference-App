//
//  ContentView.swift
//  pose-reference
//
//  Created by josiah on 2021-10-17.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var prefs: GlobalVariables
    @EnvironmentObject var timeObject: TimerObject
    //@EnvironmentObject var memory: Memory
    //@EnvironmentObject var userEntity: UserEntity
    
    @Environment(\.managedObjectContext) var context //viewContext
    @FetchRequest(entity: UserEntity.entity(), sortDescriptors: [])
    var userObject: FetchedResults<UserEntity>
        //, predicate: NSPredicate(format: "status != %@", Status.completed.rawValue)
    
    
    
    //@Environment(\.presentationMode) var presentationMode
    
    @State private var startSession = false
    
    var body: some View {
        VStack{
            if !startSession {
                HomeScreen(startSession: $startSession) //user: userObject, 
                
                
                 //   .frame(maxWidth: .infinity, maxHeight: .infinity)
                  //  .background(Color.blue)
                 //   .transition(AnyTransition.move(edge: .leading)).animation(.default)
                 
            }
            if startSession {
                DrawingView(startSession: $startSession)
                   // .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //.background(Color.green)
                 //   .transition(AnyTransition.move(edge: .trailing)).animation(.default)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       // ContentView()
            //.environmentObject(GlobalVariables())
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(GlobalVariables())
    }
}
 
