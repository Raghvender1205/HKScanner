//
//  FeedbackView.swift
//
//
//  Created by Raghvender on 12/12/23.
//

import Foundation
import RealityKit
import SwiftUI

struct FeedbackView: View {
    @ObservedObject var messageList: TimedMessageList

    var body: some View {
        VStack {
            if let activeMessage = messageList.activeMessage {
                Text("\(activeMessage.message)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .environment(\.colorScheme, .dark)
                    .transition(.opacity)
            }
        }
    }
}
