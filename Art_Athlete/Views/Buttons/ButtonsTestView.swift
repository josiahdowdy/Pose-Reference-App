//
//  ButtonsTestView.swift
//  pose-reference
//
//  Created by josiah on 2021-10-29.
//

import SwiftUI

struct ButtonsTestView: View {
    @Environment(\.managedObjectContext) var context

    var userData : FetchedResults<UserData>
    
    
    var body: some View {
        LazyHStack {
            Button(action: {
                userData[0].countPoses += 1
            }, label: {
                Text("Increase poses")
            })
            
            Button(action: {
                // userData[0].userName = "bob"
                //userData
                let newRow = UserData(context: context)
                newRow.date = Date()
                //newRow.userName = ("henry".appending(String(userData[0].countPoses))) //
                //newRow.countPoses = 0
            }, label: {
                Text("New row.")
            })
            
            Button(action: {
                PersistenceController.shared.save() //Save data.
            }, label: {
                Text("Save Data")
            })
        }
    }
}

/*
struct ButtonsTestView_Previews: PreviewProvider {
    
    static var previews: some View {
        ButtonsTestView(userData: userData)
    }
} */
