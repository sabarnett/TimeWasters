//
// -----------------------------------------
// Original project: GamesController
// Original package: GamesController
// Created on: 10/09/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(nsImage: NSImage(named: "AppIcon")!)
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(Bundle.main.appName)")
                        .font(.system(size: 20, weight: .bold))
                        .textSelection(.enabled)
                    
                    Text("Ver: \(Bundle.main.appVersionLong) (\(Bundle.main.appBuild)) ")
                        .textSelection(.enabled)
                }
            }
            
            Link(Constants.homeAddress,
                 destination: Constants.homeUrl )
            
            Text(Bundle.main.copyright)
                .font(.system(size: 10, weight: .thin))
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .frame(minWidth: 500, minHeight: 200)
    }
}

#Preview {
    AboutView()
}
