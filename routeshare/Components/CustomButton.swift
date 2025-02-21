//
//  CustomButton.swift
//  routeshare
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-21.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var backgroundColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .cornerRadius(8)
                .padding(.horizontal)
        }
    }
}
