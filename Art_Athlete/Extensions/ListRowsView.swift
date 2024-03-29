//
//  ListRowsExtension.swift
//  pose-reference
//
//  Created by josiah on 2021-10-28.
//

import SwiftUI

struct ListRowsView: View {
    @Environment(\.managedObjectContext) var context

    var userData : FetchedResults<UserData>
    
    var body: some View {
        List {
            ForEach(userData, id:\.self) { user in
                //let mydate = 1 // convertDateFormatter(date: String(user.date))
                if #available(iOS 15.0, *) {
                    Text("\(user.date!.formatted(.dateTime.day().month().hour().minute())) - \(user.countPoses)") //\(mydate) -
                        .contextMenu {
                            Button("Delete"){
                                context.delete(user)
                                try? context.save()
                            }
                        }
                } else {
                    // Fallback on earlier versions
                    Text("\(user.countPoses)") //\(mydate) -
                        .contextMenu {
                            Button("Delete"){
                                context.delete(user)
                                try? context.save()
                            }
                        }
                }
            }
        }
    }
    
    
}

