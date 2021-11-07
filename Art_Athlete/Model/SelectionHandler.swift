////
////  SelectionHandler.swift
////  Art_Athlete
////
////  Created by josiah on 2021-11-06.
////
//import CoreData
//
//class SelectionHandler {
//
//    func clearSelection(in context: NSManagedObjectContext) {
//        for item in currentSelected(in: context) {
//            item.isSelected = false
//        }
//    }
//
//    func selectProduct(_ product: Product) {
//        guard let context = product.managedObjectContext else {
//            assertionFailure("broken !")
//            return
//        }
//
//        clearSelection(in: context)
//        product.isSelected = true
//    }
//
//    func currentSelected(in context: NSManagedObjectContext) -> [Product] {
//        let request = NSFetchRequest<Product>(entityName: Product.entity().name!)
//        let predicate = NSPredicate(format: "isSelected == YES")
//        request.predicate = predicate
//
//        do {
//            let result = try context.fetch(request)
//            return result
//        } catch  {
//            print("fetch error =",error)
//            return []
//        }
//
//    }
//
//}
