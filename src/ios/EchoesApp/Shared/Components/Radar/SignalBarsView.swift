import SwiftUI

struct SignalBarsView: View {
    var level: Int

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(1...5, id: \.self) { idx in
                RoundedRectangle(cornerRadius: 2)
                    .fill(idx <= level ? (level >= 4 ? EchoesColor.gold : EchoesColor.teal) : EchoesColor.bgTertiary)
                    .frame(width: 6, height: CGFloat(6 + idx * 6))
            }
        }
        .frame(height: 36)
    }
}
