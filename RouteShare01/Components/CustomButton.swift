import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.buttonText)
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppColors.buttonBackground)
                .cornerRadius(10)
                .shadow(radius: 3)
        }
    }
}

#Preview {
    CustomButton(title: "Hello, World!", action: {})
        .padding()
        .background(AppColors.background)
}
