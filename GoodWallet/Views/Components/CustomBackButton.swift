import SwiftUI

struct CustomBackButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(action: { dismiss() }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.title30)
            }
            .foregroundColor(Color.customAccentColor)
        }
    }
}

#Preview {
    CustomBackButton()
} 
