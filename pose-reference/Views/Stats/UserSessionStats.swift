//
//  UserSessionStats.swift
//  pose-reference
//
//  Created by josiah on 2021-10-22.
//

import SwiftUI

struct UserSessionStats: View {
    @EnvironmentObject var prefs: GlobalVariables
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: UserEntity.entity(), sortDescriptors: []) //, predicate: NSPredicate(format: "status != %@", Status.completed.rawValue)
    var userSessions : FetchedResults<UserEntity>
    
    @State private var startSession = true
    
    
    //---------BEGIN VIEW----------------
    var body: some View { // ?? Date), style: .time
        List {
            ForEach(userSessions) { userSession in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(userSession.dateString): \(userSession.posePhotoLength) second poses - \(userSession.posesToday) poses drawn today.") //\(userSession.date): 
                            .font(.headline)
                        //Text("\(HomeScreen(startSession: $startSession).hope.posesToday)") .font(.subheadline)
                    }
                    
                    
                    Spacer()
                    /*
                     Button(action: {print("Update order")}) {
                     Text(userSession.sessionStatus == .drawing ? "Drawing" : "Studying")
                     .foregroundColor(.blue)
                     } */
                }
                .frame(height: 50)
            }
            .onDelete(perform: deleteItems)
            
        }
        .listStyle(PlainListStyle())
        
    }//----------------------------END VIEW----------------------------------------------------------------
    
    
    // --------------------------START VARIABLES------------------------------------------------
    func newSession(){
        //Create the id for the session. Each session has its own row in the data table.
        let newSession = UserEntity(context: viewContext)
        newSession.posePhotoLength = 4//Int16(prefs.time[prefs.selectorIndexTime])
        
        let myFormatter = DateFormatter()
        myFormatter.timeStyle = .short
        let dateString = myFormatter.string(from: Date())
        
        newSession.dateString = dateString
        //newSession.date = "hi"//dateString //.formatted(date: .abbreviated, time: .shortened)
        newSession.posesToday = 44//Int16(prefs.userSessionPoseCount)
        
        //Save the new session.
        do {
            try viewContext.save()
            print("\n New session saved.\n")
            print("\n POOOOOOOOOOOP.\n")
        } catch {
            print("Error in save data: \(error.localizedDescription)")
        }
        
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { userSessions[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}




struct UserSessionStats_Previews: PreviewProvider {
    static var previews: some View {
        UserSessionStats()
    }
}

