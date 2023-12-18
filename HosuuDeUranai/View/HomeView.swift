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
        ZStack {
            VStack {
                Text("歩数De占い")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                ScrollView {
                    Text(viewModel.todayComment)
                    AsyncImage(url: viewModel.todaImageUrl) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .frame(width: 320, height: 320)
                    .cornerRadius(20)
                }
                Spacer()
            }
            .padding()
            if viewModel.showSuccessView {
                Text("あなたの運命を占いました")
                     .padding(32)
                     .tint(Color.white)
                     .background(Color.gray)
                     .cornerRadius(10)
            }
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
                    .tint(Color.white)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    HomeView()
}
