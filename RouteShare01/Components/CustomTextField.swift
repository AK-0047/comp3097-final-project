import SwiftUI

struct CustomTextField: View {
    var icon: String = "pencil"
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(AppColors.background)
                .shadow(radius: 3)
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.contentText, lineWidth: 1)

            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(AppColors.contentText.opacity(0.6))
                    .padding(.leading, 40)  // Space for icon
            }

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
        .frame(height: 50)
    }
}
