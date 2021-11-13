//
//  CardView.swift
//  pose-reference
//
//  Created by josiah on 2021-10-20.
//

import SwiftUI

struct CardView: View {
    
    @State var testData: UserData
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        
      //  NavigationLink(destination: DetailView(memory: memory)) {
            
            VStack(alignment: .leading,spacing: 10){
                
                Text(testData.date ?? Date(),style: .date)
                Text("Pose Count: \(testData.countPoses)")
                
                Text("Oct. 29, 2021") //testData.) // ?? ""
                    .font(.title3)
                    .fontWeight(.bold)
                
                /*
                Text(memory.timestamp ?? Date(),style: .date)
                Text("Pose Count: \(memory.userPoseCount)")

                Text(memory.title ?? "")
                    .font(.title3)
                    .fontWeight(.bold)
                */
                
            }
            .foregroundColor(.primary)
            .padding()
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(scheme == .dark ? Color.gray.opacity(0.6) : Color.white)
            .cornerRadius(10)
            .frame(maxWidth: .infinity,alignment: .leading)
       // }
    }
}
