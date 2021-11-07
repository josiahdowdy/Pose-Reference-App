import SwiftUI


// ########################################################################################
// XCode
//   Version 11.4.1 (11E503a)
// Simulator
//   Version 11.4.1 (921.9)
//   SimulatorKit 581.9.1
//   CoreSimulator 704.12.1
// Device
//   iPhone SE (2nd generation)
// ########################################################################################



// ########################################################################################
// the CoreData entity is named MyNumber
// I don't think extending it as Identifiable has any effect but it shouldn't hurt to add it
// ########################################################################################
extension MyNumber: Identifiable {
    // ########################################################################################
    // the entity has these two fields
    // @NSManaged public var id: UUID?
    // @NSManaged public var stringValue: String?
    // ########################################################################################
}

struct ContentView: View {

    // Tab variables
    @State private var tabSelection = 0

    // Array variables
    @State var arrayNumbers = ["One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten"]
    @State var arrayEditMode = EditMode.inactive
    @State var arraySelection = Set<String>()

    // Core Data variables
    @State var cdEditMode = EditMode.inactive
    // ########################################################################################
    // Am I using the correct type ? Set<MyNumber>() : I also tried Set<UUID>() without success
    // ########################################################################################
    // # Using Set<MyNumber>()
    @State var cdSelection = Set<MyNumber>()
    // ########  OR  ############
    // # Using Set<UUID>()
    // @State var cdSelection = Set<UUID>()
    // #####################################################################
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: MyNumber.entity(), sortDescriptors:[]) var cdNumbers: FetchedResults<MyNumber>



    var body: some View {

        TabView(selection: $tabSelection){
            // Array Tab
            VStack{
                Text("Array").font(.largeTitle)
                NavigationView {

                    List(selection: $arraySelection) {
                        ForEach(arrayNumbers, id: \.self) { number in
                            Text(number)
                        }
                        .onDelete(perform: arrayOnSwipeDelete)
                    }
                    .navigationBarTitle("Selected count \(arraySelection.count)")
                    .navigationBarItems(leading: arrayDeleteButton, trailing: EditButton())
                    .environment(\.editMode, self.$arrayEditMode)
                }
            }
            .tabItem {
                VStack {
                    Image(systemName: "checkmark")
                    Text("Array")

                }
            }
            .tag(0)

            // Core Data Tab

            VStack{
                VStack{
                    Text("Core Data").font(.largeTitle)
                    Button("Add coredata numbers") {
                        for number in self.arrayNumbers {
                            let cdNumber = MyNumber(context: self.moc)
                            cdNumber.id = UUID()
                            cdNumber.stringValue = "\(number)"
                        }
                        try? self.moc.save()
                    }.disabled(cdEditMode.isEditing)
                }
                NavigationView {
                    List(selection: $cdSelection) {
                        ForEach(cdNumbers, id: \.id) { number in
                            Text(number.stringValue ?? "NULL")
                        }
                        // #####################################################################
                        // Problem #1
                        // Without the onDelete, the left selection column does not appear at all
                        // To reproduce this
                        // 1 - click "Add coredata records"
                        // 2 - Click "Edit"
                        // #####################################################################
                        // Problem #2
                        // With the onDelete, rows can be selected but $cdSelection stays empty
                        // To reproduce this
                        // 1 - click "Add coredata records"
                        // 2 - Click "Edit"
                        // 3 - Select records (notice the selection count is not updated)
                        // 4 - Even with some selected records, the trashcan stays disabled because of the disabled event
                        // 5 - Commenting out the disabled event and clicking on the trashcan should delete records but it does nothing
                        // #####################################################################
                        .onDelete(perform: cdOnSwipeDelete)
                    }
                    .navigationBarTitle("Selected count \(cdSelection.count)")
                    .navigationBarItems(leading: cdDeleteButton, trailing: EditButton())
                    .environment(\.editMode, self.$cdEditMode)
                }}
            .tabItem {
                VStack {
                    Image(systemName: "xmark")
                    Text("CoreData")
                }
            }
            .tag(1)

        }

    }
    init() {
        // Global Navigation bar customizations
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)]
    }


    // array functions
    private var arrayDeleteButton: some View {
        return Button(action: arrayDeleteNumbers) {
            if arrayEditMode == .active {
                Image(systemName: "trash")
            }
        }.disabled(arraySelection.count <= 0)
    }

    private func arrayDeleteNumbers() {
        for id in arraySelection {
            if let index = arrayNumbers.lastIndex(where: { $0 == id })  {
                arrayNumbers.remove(at: index)
            }
        }
        arraySelection = Set<String>()
    }

    // #####################################################################
    // Array selecction is not affected by the presence of the arrayOnSwipeDelete function
    // #####################################################################
    private func arrayOnSwipeDelete(with indexSet: IndexSet) {
        indexSet.forEach { index in
            arrayNumbers.remove(at: index)
        }
    }


    // Core Data Functions
    private var cdDeleteButton: some View {
        return Button(action: cdDeleteNumbers) {
            if cdEditMode == .active {
                Image(systemName: "trash")
            }
            // #####################################################################
            // Even with a commented .disable rule, the trash can deletes nothing
            // #####################################################################
        }.disabled(cdSelection.count <= 0)

    }

    private func cdDeleteNumbers() {
        for selectedItem in self.cdSelection{
            // #####################################################################
            // # Using Set<MyNumber>()
            self.moc.delete(selectedItem)
            // ########  OR  ############
            // # Using Set<UUID>()
            // self.moc.delete(cdNumbers.first(where:  {$0.id == selectedItem})!)
            // #####################################################################
        }
        try? self.moc.save()

        // #####################################################################
        // # Using Set<MyNumber>()
        cdSelection = Set<MyNumber>()
        // ########  OR  ############
        // # Using Set<UUID>()
        // cdSelection = Set<UUID>()
        // #####################################################################
    }

    // #####################################################################
    // Core data selecction is affected by the presence of the cdOnSwipeDelete function
    // IE: The selection column is shown in edit mode only if
    // this functuion is referenced by ForEach{}.onDelete()
    // #####################################################################
    private func cdOnSwipeDelete(with indexSet: IndexSet) {

        indexSet.forEach { index in
            let number = cdNumbers[index]
            self.moc.delete(number)
        }
        try? self.moc.save()
    }


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
