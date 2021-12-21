//
//  iCloudDelete.swift
//  Art_Athlete
//
//  Created by josiah on 2021-12-21.
//

import CloudKit

class iCloudDelete {

    private let cloudDB: CKDatabase
    private var recordIDsToDelete = [CKRecord.ID]()
    private var onAllQueriesCompleted : (()->())?

    public var resultsLimit = 10 // default is 100

    init(cloudDB: CKDatabase){
        self.cloudDB = cloudDB
    }

    func delete(query: CKQuery, onComplete: @escaping ()->Void) {
        onAllQueriesCompleted = onComplete
        add(queryOperation: CKQueryOperation(query: query))
    }

    private func add(queryOperation: CKQueryOperation) {
        queryOperation.resultsLimit = resultsLimit
        queryOperation.queryCompletionBlock = queryDeleteCompletionBlock
        queryOperation.recordFetchedBlock = recordFetched
        cloudDB.add(queryOperation)
    }

    private func queryDeleteCompletionBlock(cursor: CKQueryOperation.Cursor?, error: Error?) {
        print("-----------------------")
        delete(ids: recordIDsToDelete) {
            self.recordIDsToDelete.removeAll()

            if let cursor = cursor {
                self.add(queryOperation: CKQueryOperation(cursor: cursor))
            } else {
                self.onAllQueriesCompleted?()
            }
        }
    }

    private func recordFetched(record: CKRecord) {
        print("RECORD fetched: \(record.recordID.recordName)")
        recordIDsToDelete.append(record.recordID)
    }

    private func delete(ids: [CKRecord.ID], onComplete: @escaping ()->Void) {
        let delete = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: ids)
        delete.completionBlock = {
            onComplete()
        }
        cloudDB.add(delete)
    }
}
