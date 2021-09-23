//
//  ContentView.swift
//  pose-reference
//
//  Created by jo on 2020-11-10.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    
    //@State private var document: MessageDocument = MessageDocument(message: "Import your photos")
    @State private var isImporting: Bool = false
    
    var body: some View {
        VStack {
            GroupBox {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isImporting = false
                        
                        //fix broken picker sheet
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isImporting = true
                        }
                    }, label: {
                        Text("Select Photos")
                    })
                    
                    
                    Spacer()
                }
            }
        }
        .padding()
        /*
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [UTType.plainText, UTType.png, UTType.image, UTType.jpeg, UTType.pdf], 
            allowsMultipleSelection: true, //false
            onCompletion: { result in
                    if let urls = try? result.get() {
                      // you can do with the file urls here
                        
                    }
                  }
        ) */
       
    }
    
}
