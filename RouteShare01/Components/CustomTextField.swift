import SwiftUI

struct CustomTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            // 1) Add a background + stroke to the ZStack, not the HStack
            RoundedRectangle(cornerRadius: 10)
                .fill(AppColors.background)
                .shadow(radius: 3)
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.contentText, lineWidth: 1)

            // 2) Place the placeholder on top of the background
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(AppColors.contentText.opacity(0.6))
                    .padding(.leading, 40)  // Space for icon
            }

            // 3) The actual text field & icon
            HStack {
                Image(systemName: icon)
                    .foregroundColor(AppColors.contentText)

                if isSecure {
                    SecureField("", text: $text)
                        .foregroundColor(AppColors.contentText)
                } else {
                    TextField("", text: $text)
                        .foregroundColor(AppColors.contentText)
                }
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)
        }
        .frame(height: 50)  // Optional fixed height
    }
}
