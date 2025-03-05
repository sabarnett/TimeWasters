//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 04/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct LeaderBoardView: View {
    @Environment(\.dismiss) private var dismiss

    let leaderBoard: LeaderBoard
    
    var leaderItems: [LeaderBoardItem] {
        leaderBoard.playerLeaderBoard
            .sorted(by: { $0.gameScore > $1.gameScore })
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            headerView()
            
            HStack {
                List {
                    LeaderBoardItemHeader()
                    ForEach(leaderItems) { leaderItem in
                        LeaderBoardItemView(leaderItem: leaderItem)
                    }
                }.frame(minHeight: 200)
            }
            
            footerView()
        }
        .padding()
    }
    
    func headerView() -> some View {
        HStack {
            Text("Leader Board")
                .font(.title)
            Spacer()
            Button(action: {
                leaderBoard.clearScores()
            }, label: {
                Image(systemName: "square.stack.3d.up.slash.fill")
            })
            .buttonStyle(.plain)
            .help("Clear the leader board scores")
        }
    }
    
    func footerView() -> some View {
        HStack {
            Spacer()
            Button(role: .cancel,
                   action: { dismiss() },
                   label: { Text("Close") })
            .buttonStyle(.borderedProminent)
            .tint(.accentColor)
        }
    }
}

#Preview {
    LeaderBoardView(leaderBoard: LeaderBoard())
}
