//
//  LogService.swift
//  Nostic
//
//  Created by Josh Leung on 5/4/23.
//

import Foundation
import Combine

class LogService: ObservableObject {
    @Published var currentInformation: String = ""
    @Published var store: [String: String]  = [:]
    
    init() {
        subscribeToStream(publisher: CBClient.instance.$currentValuesPublisher)
    }
    
    func subscribeToStream(publisher: Published<[String]?>.Publisher) {
        _ = publisher.sink { value in
            guard let value = value else { return }
            self.currentInformation = value.last ?? "Unable to read"
        }
    }
}
