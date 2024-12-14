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
            .padding([.leading, .top, .trailing], 12)

            VStack(alignment: .leading, spacing: 8) {
                LabeledContent("Appliation support from") {
                    Link(Constants.homeAddress,
                         destination: Constants.homeUrl )
                }
                
                LabeledContent("Sound files from") {
                    Link("zapsplat.com",
                         destination: URL(string: "https://www.zapsplat.com")!)
                }
                
                LabeledContent("Home page images supplied by") {
                    Link("pixabay.com",
                         destination: URL(string: "https://pixabay.com")!)
                }
                
                LabeledContent("Some game ideas from Paul Hudson") {
                    Link("Hacking With Swift+",
                         destination: URL(string: "https://www.hackingwithswift.com/plus")!)
                }
            }
            .padding([.leading, .trailing], 20)

            HStack {
                Spacer()
                Text(Bundle.main.copyright)
                    .font(.system(size: 12, weight: .thin))
                    .multilineTextAlignment(.center)
                    .padding(.top, 32)
                    .padding(.bottom, 8)
                    .padding(.trailing, 12)
            }
        }
        .frame(width: 480)
    }
}

#Preview {
    AboutView()
}
