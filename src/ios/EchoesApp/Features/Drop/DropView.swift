import SwiftUI

struct DropView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        VStack(spacing: EchoesSpacing.md) {
            Text("创建回响")
                .font(EchoesFont.headline)
                .foregroundStyle(EchoesColor.textPrimary)
                .padding(.top, EchoesSpacing.lg)

            modePicker
                .padding(.horizontal, EchoesSpacing.md)

            if store.dropDraft.isVoiceMode {
                voiceComposer
            } else {
                textComposer
            }

            visibilityPicker
                .padding(.horizontal, EchoesSpacing.md)

            timeLockRow
                .padding(.horizontal, EchoesSpacing.md)

            if store.dropDraft.visibility == .private {
                passcodeField
                    .padding(.horizontal, EchoesSpacing.md)
            }

            Spacer(minLength: 8)

            submitButton
                .padding(.bottom, EchoesSpacing.xl)
        }
        .background(EchoesColor.bgPrimary)
    }

    private var modePicker: some View {
        Picker("内容模式", selection: $store.dropDraft.isVoiceMode) {
            Text("语音").tag(true)
            Text("文字").tag(false)
        }
        .pickerStyle(.segmented)
        .tint(EchoesColor.gold)
    }

    private var voiceComposer: some View {
        VStack(spacing: EchoesSpacing.md) {
            Text("● REC")
                .font(EchoesFont.footnote)
                .foregroundStyle(EchoesColor.red)
                .padding(.top, EchoesSpacing.lg)

            waveform

            Text("00:00")
                .font(.system(size: 50, weight: .regular, design: .rounded))
                .foregroundStyle(EchoesColor.textPrimary)
        }
    }

    private var textComposer: some View {
        CardContainer {
            Text("文字便签")
                .font(EchoesFont.headline)
                .foregroundStyle(EchoesColor.textPrimary)

            TextField("写下你想留下的话…", text: $store.dropDraft.text, axis: .vertical)
                .lineLimit(6, reservesSpace: true)
                .font(EchoesFont.body)
                .foregroundStyle(EchoesColor.textPrimary)
                .padding(EchoesSpacing.sm)
                .background(EchoesColor.bgTertiary)
                .clipShape(RoundedRectangle(cornerRadius: EchoesRadius.md, style: .continuous))
        }
        .padding(.horizontal, EchoesSpacing.md)
    }

    private var waveform: some View {
        HStack(alignment: .center, spacing: 6) {
            ForEach(0..<24, id: \.self) { index in
                RoundedRectangle(cornerRadius: EchoesRadius.xs)
                    .fill(index.isMultiple(of: 3) ? EchoesColor.gold : EchoesColor.gold.opacity(0.6))
                    .frame(width: 4, height: CGFloat(8 + abs(12 - index) * 4))
            }
        }
        .frame(height: 96)
        .padding(.horizontal, EchoesSpacing.md)
    }

    private var visibilityPicker: some View {
        HStack(spacing: EchoesSpacing.sm) {
            pickerPill("公开", tag: EchoVisibility.public)
            pickerPill("加密", tag: EchoVisibility.private)
        }
    }

    private func pickerPill(_ title: String, tag: EchoVisibility) -> some View {
        Button {
            store.dropDraft.visibility = tag
        } label: {
            Text(title)
                .font(EchoesFont.subhead)
                .foregroundStyle(store.dropDraft.visibility == tag ? EchoesColor.gold : EchoesColor.textSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(EchoesColor.bgSecondary)
                .clipShape(RoundedRectangle(cornerRadius: EchoesRadius.md, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var timeLockRow: some View {
        HStack {
            Label("时间锁", systemImage: "clock")
                .font(EchoesFont.subhead)
                .foregroundStyle(EchoesColor.textPrimary)

            Spacer()

            Toggle("", isOn: $store.dropDraft.hasTimeLock)
                .labelsHidden()
                .tint(EchoesColor.teal)

            Text(store.dropDraft.hasTimeLock ? "开启中" : "开启后 7 天自动解锁")
                .font(EchoesFont.caption)
                .foregroundStyle(EchoesColor.textSecondary)
        }
        .padding(.horizontal, EchoesSpacing.md)
        .frame(height: 44)
        .background(EchoesColor.bgSecondary)
        .clipShape(RoundedRectangle(cornerRadius: EchoesRadius.md, style: .continuous))
    }

    private var passcodeField: some View {
        TextField("输入4位口令", text: $store.dropDraft.passcode)
            .keyboardType(.numberPad)
            .font(.system(size: 20, weight: .semibold, design: .monospaced))
            .foregroundStyle(EchoesColor.textPrimary)
            .multilineTextAlignment(.center)
            .padding(.vertical, EchoesSpacing.sm)
            .background(EchoesColor.bgSecondary)
            .clipShape(RoundedRectangle(cornerRadius: EchoesRadius.md, style: .continuous))
    }

    private var submitButton: some View {
        Button {
            store.submitDrop()
        } label: {
            Circle()
                .fill(EchoesColor.gold)
                .frame(width: 120, height: 120)
                .overlay {
                    Image(systemName: store.dropDraft.isVoiceMode ? "waveform" : "paperplane.fill")
                        .font(.system(size: 34, weight: .medium))
                        .foregroundStyle(Color.black.opacity(0.9))
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("确认埋藏")
    }
}
