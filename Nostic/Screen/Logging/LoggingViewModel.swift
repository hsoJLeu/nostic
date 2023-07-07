//
//  LoggingViewModel.swift
//  Nostic
//
//  Created by Josh Leung on 5/4/23.
//

import Combine

class LoggingViewModel: ObservableObject {
    var logService: LogService = LogService()
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var log: [String] = ["Hello world"]
    
    init() {
        displayInformation()
    }
    
    func displayInformation() {
        logService.$currentInformation.sink(receiveValue: { value in
            self.log.append(value)
        }).store(in: &cancellables)
    }
}
