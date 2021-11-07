//
//  MultipleSelectRow.swift
//  Art_Athlete
//
//  Created by josiah on 2021-11-06.
//

import SwiftUI

struct MultipleSelectRow : View {
    @EnvironmentObject var prefs: GlobalVariables
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: PhotoFolders.entity(), sortDescriptors: []
    ) var foldersData : FetchedResults<PhotoFolders>


    //Core Data
    @State var rowSelection = Set<PhotoFolders>()

    @FetchRequest(entity: PhotoFolders.entity(), sortDescriptors:[])
    var cdNumbers: FetchedResults<PhotoFolders>

    // @State var cdEditMode = EditMode.active


    var body: some View {
        NavigationView {
            //   List(foldersData, id: \.self, selection: $rowSelection){ name in //*this works*
            List(selection: $rowSelection) {
                ForEach(cdNumbers, id: \.self) { name in
                    HStack {


                        HStack {
                            Text(name.wrappedFolderName)
                        }
                        HStack {
                            if (rowSelection.contains(name) == true) {
                                Text(name.wrappedFolderName).font(.caption)
                                //    prefs.arrayOfFolders.append(name)
                                

                                //  print("Josiah, prefs.arrayOfFolders: \(prefs.arrayOfFolders)")
                            }
                        }

                    }

                }
                
                .onDelete(perform: cdOnSwipeDelete)

            }
        }
        // the next line is the modifier
        .environment(\.editMode, .constant(EditMode.active)) // *IMPORTANT* Allows checkbox to appear.
        .navigationBarTitle(Text("#: \(rowSelection.count)"))

        .navigationBarItems(leading: cdDeleteButton, trailing: cdArraySave)//, trailing: EditButton()
        //  .environment(\.editMode, self.$cdEditMode)
    }


    //•••••••••START FUNCTIONS•••••••••
    /*••••••••••••••••••••••••••••••••
     ••••••••••••••••••••••••••••••••••
     ••••••••••••••••••••••••••••••••••
     ••••••••••••••••••••••••••••••••••
     ••••••••••••••••••••••••••••••••*/
//    public func saveArrayOfFolders(name) {
//        prefs.arrayOfFolders.append(name)
//        print("Josiah, prefs.arrayOfFolders: \(prefs.arrayOfFolders)")
//    }

    private var cdArraySave: some View {
        return Button(action: cdSaveArray) {
            Image(systemName: "square.and.arrow.down")
        }.disabled(rowSelection.count <= 0)
    }

    private func cdSaveArray() {
        for selectedItem in self.rowSelection{
       // ForEach(rowSelection, id: \.self) { i in
            //self.context.delete(selectedItem)
            prefs.arrayOfFolders.append(selectedItem.wrappedFolderName)

        }
        try? self.context.save()
        rowSelection = Set<PhotoFolders>()

        print(prefs.arrayOfFolders)
    }

    // Core Data Functions
    private var cdDeleteButton: some View {
        return Button(action: cdDeleteNumbers) {
            Image(systemName: "trash")
            //            if cdEditMode == .active {
            //                Image(systemName: "trash")
            //            }
            // #####################################################################
            // Even with a commented .disable rule, the trash can deletes nothing
            // #####################################################################
        }.disabled(rowSelection.count <= 0)
    }

    private func cdDeleteNumbers() {
        for selectedItem in self.rowSelection{
            // #####################################################################
            // # Using Set<MyNumber>()
            self.context.delete(selectedItem)
            // ########  OR  ############
            // # Using Set<UUID>()
            // self.moc.delete(cdNumbers.first(where:  {$0.id == selectedItem})!)
            // #####################################################################
        }
        try? self.context.save()

        // #####################################################################
        // # Using Set<MyNumber>()
        //rowSelection = Set<PhotoFolders>()
        rowSelection = Set<PhotoFolders>()
        // ########  OR  ############
        // # Using Set<UUID>()
        // rowSelection = Set<UUID>()
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
            self.context.delete(number)
        }
        try? self.context.save()
    }





}

