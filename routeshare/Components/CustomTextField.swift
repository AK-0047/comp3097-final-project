//
//  TextFieldModifier.swift
//  routeshare
//
//  Created by Anshul Dharmendra Kamboya on 2025-02-21.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
            } else {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }
}
