//
//  ContentView.swift
//  pose-reference
//
//  Created by jo on 2020-11-10.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentViewBackup: View {
    
    @State private var document: MessageDocument = MessageDocument(message: "Import your photos")
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    
    var body: some View {
        VStack {
            GroupBox(label: Text("Message:")) {
                TextEditor(text: $document.message)
            }
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
                        Text("Import")
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        isExporting = false
                        
                        //fix broken picker sheet
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isExporting = true
                        }
                        
                    }, label: {
                        Text("Export")
                    })
                    
                    Spacer()
                }
            }
        }
        .padding()
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [UTType.plainText, UTType.png, UTType.image, UTType.jpeg, UTType.pdf],
            allowsMultipleSelection: true //false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                
                //trying to get access to url contents
                if (CFURLStartAccessingSecurityScopedResource(selectedFile as CFURL)) {
                    
                    guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                    
                    document.message = message
                        
                    //done accessing the url
                    CFURLStopAccessingSecurityScopedResource(selectedFile as CFURL)
                }
                else {
                    print("Permission error!")
                }
            } catch {
                // Handle failure.
                print(error.localizedDescription)
            }
        }
        .fileExporter(
            isPresented: $isExporting,
            document: document,
            contentType: UTType.plainText,
            defaultFilename: "Message"
        ) { result in
            if case .success = result {
                // Handle success.
            } else {
                // Handle failure.
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
    }
    
}
