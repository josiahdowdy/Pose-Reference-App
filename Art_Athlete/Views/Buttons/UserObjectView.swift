import SwiftUI

struct UserObjectView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var itemName: String = ""
    @ObservedObject var userObject: UserObject
    
    var body: some View {
        VStack {
            TextField("Item Name", text: $itemName)
            Button(action: {
                self.userObject.name = self.itemName
                do {
                    try self.managedObjectContext.save()
                } catch {
                    print("Josiah3: \(error)")
                }
                
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
            }
        }
        .onAppear(perform: {
            self.itemName = self.userObject.name ?? "nin"
        })
    }
}
