//
//  LoggingView.swift
//  Nostic
//
//  Created by Josh Leung on 5/4/23.
//

import SwiftUI

struct LoggingView: View {
    @StateObject private var viewModel = LoggingViewModel()

    var body: some View {
        List {
            ForEach(viewModel.log, id: \.self) { text in
                Text(text)
            }
        }
    }
}

struct LoggingView_Previews: PreviewProvider {
    static var previews: some View {
        LoggingView()
    }
}
