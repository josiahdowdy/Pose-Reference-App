//
//  SessionStats.swift
//  pose-reference
//
//  Created by josiah on 2021-10-19.
//

/*
import SwiftUI

struct SessionStats: View {
    //------------Database iCloud-------------------------------------------------------------
    @Binding var close: Bool
    //@Binding var memory: Memory? //Database name.
    //@Binding var memory: Memory?
    @Environment(\.managedObjectContext) var context
    
    
    
    @State var title = ""
    @State var content = ""
    @State var date: Date = Date()
    
    @State var isImage = false
    @State var showImagePicker = false
    @State var imageData : Data = Data(count: 0)
    
    @State var alertMsg = ""
    @State var showAlert = false
    
    
    var body: some View {
        NavigationView {
            List{
                Section {
                    TextField("Finally Saw Her....", text: $title)
                } header: {
                    Text("Memorable Title")
                }
                
                /*
                 if memory == nil{
                 
                 Section {
                 
                 DatePicker("", selection: $date)
                 .labelsHidden()
                 
                 } header: {
                 
                 Text("Moment Happened")
                 }
                 } */
                
                Section {
                    if isImage{
                        Button {
                            showImagePicker.toggle()
                        } label: {
                            ZStack{
                                if imageData.isEmpty{
                                    Image(systemName: "plus")
                                        .font(.largeTitle)
                                        .foregroundColor(.primary)
                                }
                                else{
                                    Image(uiImage: UIImage(data: imageData)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                            }
                            .frame(height: 200)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .padding(.top,8)
                        }
                        .frame(maxWidth: .infinity,alignment: .center)
                        
                    }
                    
                } header: {
                    Toggle(isOn: $isImage) {
                        Text("Memorable Pic?")
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Section {
                    TextEditor(text: $content)
                        .background(
                            Text("When I Met her....")
                                .foregroundColor(.gray)
                                .opacity(content == "" ? 0.7 : 0)
                                .offset(x: 2)
                            
                            ,alignment: .leading
                        )
                } header: {
                    
                    Text("Describe the Moment")
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Save Your Day")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button("Close"){
                        close.toggle()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button("Store"){
                        saveData()
                    }
                    //.disabled(checkDisabled())
                }
            }
        }
        
    }
    
    //------------FUNCTIONS----------------
    func saveData(){
 */
        /*
         if memory != nil{
         
         memory?.title = title
         memory?.content = content
         //memory?.image = imageData
         }
         else{
         let memory = Memory(context: context)
         memory.title = title
         memory.timestamp = date
         memory.content = content
         //memory.image = imageData
         }
         
         do{
         try context.save()
         close.toggle()
         }
         catch{
         alertMsg = error.localizedDescription
         showAlert.toggle()
         } */
/*
    }
}
*/
/*
 struct SessionStats_Previews: PreviewProvider {
 static var previews: some View {
 SessionStats()
 }
 }
 */
