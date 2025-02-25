//
//  BottomTabBar.swift
//  RouteShare01
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-24.
//

import SwiftUI

struct BottomTabBar: View {
    @Binding var selectedTab: Int

    let icons = ["house.fill", "magnifyingglass", "plus.circle.fill", "person.fill"]

    var body: some View {
        HStack {
            ForEach(0..<icons.count, id: \.self) { index in
                Button(action: {
                    selectedTab = index
                }) {
                    if selectedTab == index {
                        Image(systemName: icons[index])
                            .font(.system(size: 24))
                            // Use white for selected tab icons
                            .foregroundColor(AppColors.buttonText)
                            .padding()
                            .background(AppColors.buttonBackground)
                            .clipShape(Circle())
                            .shadow(color: AppColors.buttonBackground.opacity(0.6), radius: 5, x: 0, y: 3)
                    } else {
                        Image(systemName: icons[index])
                            .font(.system(size: 24))
                            // Use brown content text with reduced opacity for unselected icons
                            .foregroundColor(AppColors.contentText.opacity(0.6))
                            .padding()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(AppColors.background)
    }
}
