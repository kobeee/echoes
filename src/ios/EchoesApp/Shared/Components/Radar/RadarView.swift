import SwiftUI

struct RadarView: View {
    var showsEchoes = true
    var echoes: [EchoItem] = []
    var size: CGFloat = 300
    var centerSymbol: String? = nil

    var body: some View {
        ZStack {
            ForEach([1.0, 0.68, 0.38, 0.14], id: \.self) { ratio in
                Circle()
                    .stroke(EchoesColor.teal.opacity(0.28 * ratio + 0.04), lineWidth: 1)
                    .frame(width: size * ratio, height: size * ratio)
            }

            if showsEchoes {
                ForEach(Array(echoes.prefix(3).enumerated()), id: \.element.id) { index, echo in
                    EchoPointView(color: pointColor(for: echo))
                        .offset(pointOffset(index: index, radius: size / 2))
                }
            }

            if let centerSymbol {
                Image(systemName: centerSymbol)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundStyle(EchoesColor.teal)
            } else {
                Circle()
                    .fill(EchoesColor.teal)
                    .frame(width: 10, height: 10)
                    .shadow(color: EchoesColor.teal.opacity(0.6), radius: 8)
            }
        }
        .frame(width: size, height: size)
    }

    private func pointOffset(index: Int, radius: CGFloat) -> CGSize {
        switch index {
        case 0: return CGSize(width: radius * 0.48, height: -radius * 0.36)
        case 1: return CGSize(width: -radius * 0.44, height: radius * 0.36)
        default: return CGSize(width: radius * 0.34, height: radius * 0.12)
        }
    }

    private func pointColor(for echo: EchoItem) -> Color {
        if echo.visibility == .private { return EchoesColor.purple }
        if echo.isTimeLocked { return EchoesColor.teal }
        return EchoesColor.gold
    }
}
