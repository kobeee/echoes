import SwiftUI

struct PasscodeSheet: View {
    @EnvironmentObject private var store: AppStore
    let echoID: UUID
    let onComplete: (Bool) -> Void
    
    @State private var digits: [Int] = []
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: EchoesSpacing.md) {
            HStack {
                Button {
                    onComplete(false)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(EchoesColor.textPrimary)
                }
                Spacer()
                Text("输入口令")
                    .font(EchoesFont.headline)
                    .foregroundStyle(EchoesColor.textPrimary)
                Spacer()
                Color.clear.frame(width: 24)
            }
            .padding(.top, EchoesSpacing.md)

            Spacer(minLength: 12)

            Image(systemName: "lock.square")
                .font(.system(size: 48, weight: .regular))
                .foregroundStyle(EchoesColor.purple)

            Text("这个回响已加密")
                .font(EchoesFont.title)
                .foregroundStyle(EchoesColor.textPrimary)

            Text("请输入 4 位数字口令")
                .font(EchoesFont.subhead)
                .foregroundStyle(EchoesColor.textSecondary)

            HStack(spacing: 12) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(index < digits.count ? EchoesColor.gold : EchoesColor.bgTertiary)
                        .frame(width: 14, height: 14)
                }
            }
            .padding(.top, EchoesSpacing.sm)

            if let errorMessage {
                Text(errorMessage)
                    .font(EchoesFont.footnote)
                    .foregroundStyle(EchoesColor.red)
            }

            Spacer(minLength: 8)

            keypad

            Button("删除") {
                guard !digits.isEmpty else { return }
                digits.removeLast()
                errorMessage = nil
            }
            .font(EchoesFont.subhead)
            .foregroundStyle(EchoesColor.textSecondary)
            .padding(.bottom, EchoesSpacing.md)
        }
        .padding(.horizontal, EchoesSpacing.md)
        .background(EchoesColor.bgPrimary)
    }

    private var keypad: some View {
        VStack(spacing: EchoesSpacing.md) {
            keypadRow([1, 2, 3])
            keypadRow([4, 5, 6])
            keypadRow([7, 8, 9])
            keypadRow([0])
        }
    }

    private func keypadRow(_ values: [Int]) -> some View {
        HStack(spacing: EchoesSpacing.xl) {
            if values.count == 1 {
                Spacer()
            }
            ForEach(values, id: \.self) { value in
                Button {
                    appendDigit(value)
                } label: {
                    Text("\(value)")
                        .font(.system(size: 34, weight: .regular, design: .rounded))
                        .foregroundStyle(EchoesColor.textPrimary)
                        .frame(width: 64, height: 64)
                }
                .buttonStyle(.plain)
            }
            if values.count == 1 {
                Spacer()
            }
        }
    }

    private func appendDigit(_ digit: Int) {
        guard digits.count < 4 else { return }
        digits.append(digit)
        guard digits.count == 4 else { return }

        let passcode = digits.map(String.init).joined()
        if let echo = store.echoes.first(where: { $0.id == echoID }),
           echo.passcode == passcode {
            onComplete(true)
        } else {
            Haptics.error()
            errorMessage = "口令错误，请重试"
            digits = []
        }
    }
}
