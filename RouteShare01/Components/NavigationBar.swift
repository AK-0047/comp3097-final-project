//
//  NavigationBar.swift
//  RouteShare01
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-24.
//

import SwiftUI

struct NavigationBar: View {
    var onSearch: () -> Void
    var onPostTrip: () -> Void

    var body: some View {
        HStack {
            // App Title with brown content text
            Text("RouteShare")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(AppColors.contentText)

            Spacer()

            // Search Button with SF Symbol icon
            Button(action: onSearch) {
                HStack(spacing: 4) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.buttonText)
                    Text("Search")
                        .foregroundColor(AppColors.buttonText)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(AppColors.buttonBackground)
                .cornerRadius(8)
                .shadow(radius: 2)
            }

            // Post Trip Button with SF Symbol icon
            Button(action: onPostTrip) {
                HStack(spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(AppColors.buttonText)
                    Text("Post Trip")
                        .foregroundColor(AppColors.buttonText)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(AppColors.buttonBackground)
                .cornerRadius(8)
                .shadow(radius: 2)
            }
        }
        .padding()
        .background(AppColors.background)
    }
}
