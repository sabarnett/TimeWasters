//
// -----------------------------------------
// Original project: Othello
// Original package: Othello
// Created on: 31/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct LeaderBoardView: View {
    @Environment(\.dismiss) private var dismiss

    let leaderBoard: LeaderBoard
    let initialTab: LeaderBoardScoreFor
    
    @State var gameLevel: LeaderBoardScoreFor = .player
    
    var leaderItems: [LeaderBoardItem] {
        let leaders = leaderBoard.leaderBoard.playerLeaderBoard + leaderBoard.leaderBoard.computerLeaderBoard
        
        return leaders.sorted(by: { $0.gameScore > $1.gameScore })
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Leader Board").font(.title)
            HStack {
                List {
                    LeaderBoardItemHeader()
                    ForEach(leaderItems) { leaderItem in
                        LeaderBoardItemView(leaderItem: leaderItem)
                    }
                }.frame(minHeight: 200)
            }
            
            HStack {
                Spacer()
                Button(role: .cancel,
                       action: { dismiss() },
                       label: { Text("Close") })
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
            }
        }
        .padding()
        .onAppear {
            gameLevel = initialTab
        }
    }
}

struct LeaderBoardItemHeader: View {
    var body: some View {
        HStack {
            Text("Date")
                .font(.headline)
                .frame(minWidth: 160, maxWidth: 160, alignment: .leading)
            Text("Player")
                .font(.headline)
            Spacer()
            Text("Score")
                .font(.headline)
        }.foregroundStyle(.orange.opacity(0.85))
    }
}

struct LeaderBoardItemView: View {
    var leaderItem: LeaderBoardItem
    let dateFormatter: DateFormatter
    
    init(leaderItem: LeaderBoardItem) {
        self.leaderItem = leaderItem
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
    }
    
    var body: some View {
        HStack {
            Text(dateFormatter.string(from: leaderItem.gameDate))
                .frame(minWidth: 160, maxWidth: 160, alignment: .leading)
            Text(leaderItem.playerName)
            Spacer()
            Text("\(leaderItem.gameScore)")
        }
    }
}

#Preview {
    LeaderBoardView(leaderBoard: LeaderBoard(),
                    initialTab: .player)
}
