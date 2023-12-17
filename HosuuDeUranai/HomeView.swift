//
//  HomeView.swift
//  HosuuDeUranai
//
//  Created by 竹ノ内愛斗 on 2023/12/17.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack {
            Text("歩数De占い")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            if viewModel.todayComment.isEmpty {
                Text("今日の結果はまだないよ!\n夜9時に占うね")
            } else {
                Text(viewModel.todayComment)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
