import SwiftUI

struct PrimaryButton: View {
    let title: String
    var color: Color = EchoesColor.gold
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(EchoesFont.headline)
                .foregroundStyle(Color.black.opacity(0.8))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(color)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .accessibilityAddTraits(.isButton)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(EchoesFont.headline)
                .foregroundStyle(EchoesColor.gold)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .overlay(
                    Capsule()
                        .stroke(EchoesColor.gold, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }
}
