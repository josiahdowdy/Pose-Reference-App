////
////  AddButton.swift
////  Art_Athlete
////
////  Created by josiah on 2021-11-13.
////
//
//import SwiftUI
//import Files
//import UniformTypeIdentifiers
//
//
//
//struct AddButton: View {
//
//    // MARK: - Properties
//    @Binding var editMode: EditMode
//    // @Binding var alertShowing: Bool
//    @State var isImporting: Bool
//
//    // MARK: - UI Elements
//    var body: some View {
//
//        Button(action: {
//            isImporting = false
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                isImporting = true
//            }
//        }, label: {
//            Image(systemName: "folder.badge.plus")
//        })
////     //   if editMode == .inactive {
////            return AnyView(Button(action: {
////            withAnimation {
////                print("displaying file importer.")
////                isImporting = false
////
////                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
////                    isImporting = true
////                }
////
////            }
////
////
////
////
////               // withAnimation {
////                    //                        if alertShowing {
////                    //                            alertShowing = false
////                    //                        } else {
////                    //                            alertShowing = true
////                    //                        }
////               // }
////                print("isImporting: ", isImporting)
////            }) {
////                Image(systemName: "plus.circle.fill")
////            })
////        } else {
////            return AnyView(EmptyView())
////        }
//    }
//
//}
