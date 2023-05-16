//
//  Query+EXT.swift
//  FirbaseBootcamp
//
//  Created by kevin on 2023/5/16.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Query {
    
    //    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
    //        let snapshot = try await self.getDocuments()
    //
    //        return try snapshot.documents.map({ document in
    //            try document.data(as: T.self)
    //        })
    //
    ////        var products: [T] = []
    ////
    ////        for document in snapshot.documents {
    ////            let product = try document.data(as: T.self)
    ////            products.append(product)
    ////        }
    //    }
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        return try await getDocumentsWithSnapshot(as: type).products
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (products: [T], lastDocument: DocumentSnapshot?) where T: Decodable {
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        return (products, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T: Decodable {
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No document")
                return
            }
            
            let products: [T] = documents.compactMap({try? $0.data(as: T.self)})
            publisher.send(products)
            
        }
        return (publisher.eraseToAnyPublisher(), listener)
    
    }
}

