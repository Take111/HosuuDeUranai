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
            AsyncImage(url: viewModel.todaImageUrl) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding()
                        .tint(Color.white)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
            .frame(width: 320, height: 320)
            .cornerRadius(20)
            ScrollView {
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
