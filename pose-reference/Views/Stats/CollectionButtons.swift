//Jan 21, 2021
/*
import SwiftUI

struct CollectionButtons: View {
    //Variables 
    @EnvironmentObject var prefs: GlobalVariables
    
    @State private var dance = false
    @State private var darkPortraits = false
    
    var body: some View {
        Group {
            VStack {
                HStack{
                    Button("Collections") { //prefs.darkPortrait
                        prefs.collection.toggle()
                        prefs.sPose = ""
                    }
                    .padding(10)
                    .background(prefs.collection ? Color.white : Color.black)
                    .cornerRadius(15)
                    .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(prefs.collection ? .white : .gray)    
                            )
                    
                    if (prefs.collection) {
                        Button("Dark Portrait ") { //prefs.darkPortrait
                            darkPortraits.toggle()
                            prefs.darkPortrait.toggle()
                          
                            //prefs.darkPortrait.toggle()
                            if (darkPortraits){
                                prefs.collectionID = "162326"
                                dance = false
                            } else {
                                prefs.collectionID = ""
                            }
                            
                        }.padding(10)
                        .background(prefs.darkPortrait ? Color.green : Color.black)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 2)
                                .foregroundColor(darkPortraits ? .green : .gray)
                        )
                        
                    }
                    
                    if (prefs.collection) {
                        Button("Dance"){
                            //Actions
                            dance.toggle()
                            
                            if (dance){
                                prefs.collectionID = "2083507"
                                darkPortraits = false
                            } else {
                                prefs.collectionID = ""
                            }
                        }.buttonStyle(buttonOutline())
                        
                    }
                    
                    if (prefs.collection) {
                        Button("Moody"){
                            //Actions
                            dance.toggle()
                            
                            if (dance){
                                prefs.collectionID = "762960"
                                darkPortraits = false
                            } else {
                                prefs.collectionID = ""
                            }
                        }.buttonStyle(buttonOutline())
                        
                    }
                    
                    
                }
                
                HStack{
                    if (prefs.collection) {
                        Button("Windows"){
                            //Actions
                            dance.toggle()
                            
                            if (dance){
                                prefs.collectionID = "1198107"
                                darkPortraits = false
                            } else {
                                prefs.collectionID = ""
                            }
                        }.buttonStyle(buttonOutline())
                       
                    }
                    
                    if (prefs.collection) {
                        Button("Sad"){
                            //Actions
                            dance.toggle()
                            
                            if (dance){
                                prefs.collectionID = "2079070"
                                darkPortraits = false
                            } else {
                                prefs.collectionID = ""
                            }
                        }.buttonStyle(buttonOutline())
                        
                    }
                    
                    if (prefs.collection) {
                        Button("Couples"){
                            dance.toggle()
                            
                            if (dance){
                                prefs.collectionID = "369679"
                                darkPortraits = false
                            } else { prefs.collectionID = "" }
                        }.buttonStyle(buttonOutline())
                    }
                    
                    if (prefs.collection) {
                        Button("Skies"){
                            dance.toggle()
                            
                            if (dance){
                                prefs.collectionID = "4896810"
                                darkPortraits = false
                            } else { prefs.collectionID = "" }
                        }.buttonStyle(buttonOutline())
                    }
            }
            }
        }
    }
}

struct ButtonOnOffStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
    }
}

struct buttonOutline: ButtonStyle {
    @EnvironmentObject var prefs: GlobalVariables
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(10)
            //.background(prefs.darkPortrait ? Color.green : Color.black)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 2)
                    //.foregroundColor(prefs.darkPortrait ? .green : .gray)
            )
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}

struct bounceButtonStyle: ButtonStyle {
    @EnvironmentObject var prefs: GlobalVariables
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}


*/
