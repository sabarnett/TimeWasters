//
// -----------------------------------------
// Original project: WordCraft
// Original package: WordCraft
// Created on: 11/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct MessagePopoverView : View {
    
    @Environment(\.presentationMode) var mode
    var message: WordValidationError
    
    var body: some View {
        VStack {
            Text(message.word)
                .font(.system(size: 18, weight: .bold))
                
            Text(message.errorMessage)
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 400, height: 60)
        .fontDesign(.rounded)
        .foregroundStyle(Color.white)
        .background(Color.red.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        
        .onReceive(Timer.publish(every: 3.0, on: .current, in: .default).autoconnect()) { _ in
                self.mode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    MessagePopoverView(message: WordValidationError(word: "Wombats", errorMessage: "Wombats Rule Ok"))
}
