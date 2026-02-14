import SwiftUI

struct CardContainer<Content: View>: View {
    var padding: CGFloat = EchoesSpacing.md
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: EchoesSpacing.sm) {
            content
        }
        .padding(padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EchoesColor.bgSecondary)
        .overlay(
            RoundedRectangle(cornerRadius: EchoesRadius.md, style: .continuous)
                .stroke(EchoesColor.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: EchoesRadius.md, style: .continuous))
        .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
    }
}