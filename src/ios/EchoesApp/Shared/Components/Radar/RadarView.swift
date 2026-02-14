import SwiftUI

struct RadarView: View {
    var showsEchoes = true
    var echoes: [EchoItem] = []
    var size: CGFloat = 300
    var centerSymbol: String? = nil

    var body: some View {
        ZStack {
            // 十字参考线
            crossReferenceLines
            
            // 雷达同心圆 - 虚线样式
            ForEach([1.0, 0.68, 0.38, 0.14], id: \.self) { ratio in
                Circle()
                    .stroke(
                        EchoesColor.teal.opacity(0.28 * ratio + 0.04),
                        style: StrokeStyle(lineWidth: 1, dash: [4, 4])
                    )
                    .frame(width: size * ratio, height: size * ratio)
            }
            
            // 扫描线效果
            ScanLineView(size: size)

            if showsEchoes {
                ForEach(Array(echoes.prefix(3).enumerated()), id: \.element.id) { index, echo in
                    EchoPointView(color: pointColor(for: echo))
                        .offset(pointOffset(index: index, radius: size / 2))
                }
            }

            // 用户位置点带辉光
            if let centerSymbol {
                Image(systemName: centerSymbol)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundStyle(EchoesColor.teal)
            } else {
                userLocationPoint
            }
        }
        .frame(width: size, height: size)
    }
    
    // MARK: - 十字参考线
    private var crossReferenceLines: some View {
        ZStack {
            // 水平参考线
            Rectangle()
                .fill(EchoesColor.teal.opacity(0.1))
                .frame(width: size, height: 1)
            
            // 垂直参考线
            Rectangle()
                .fill(EchoesColor.teal.opacity(0.1))
                .frame(width: 1, height: size)
        }
    }
    
    // MARK: - 用户位置点带辉光效果
    private var userLocationPoint: some View {
        ZStack {
            // 外层辉光 (80pt 8% opacity)
            Circle()
                .fill(EchoesColor.teal.opacity(0.08))
                .frame(width: 80, height: 80)
            
            // 内层辉光 (48pt 15% opacity)
            Circle()
                .fill(EchoesColor.teal.opacity(0.15))
                .frame(width: 48, height: 48)
            
            // 核心点
            Circle()
                .fill(EchoesColor.teal)
                .frame(width: 12, height: 12)
                .shadow(color: EchoesColor.teal.opacity(0.6), radius: 8)
        }
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

// MARK: - Scan Line Animation - 修复中心点问题
struct ScanLineView: View {
    var size: CGFloat
    @State private var rotation: Double = 0
    
    var body: some View {
        // 使用固定尺寸的 ZStack，确保旋转中心正确
        ZStack {
            // 扫描扇形区域
            ScanLineShape()
                .fill(
                    RadialGradient(
                        colors: [
                            EchoesColor.teal.opacity(0.5),
                            EchoesColor.teal.opacity(0.2),
                            EchoesColor.teal.opacity(0)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size / 2
                    )
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(rotation))
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - Scan Line Shape - 扇形扫描线
struct ScanLineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        // 创建一个从中心向右的扇形 (30度角)
        let startAngle = Angle.degrees(-15)
        let endAngle = Angle.degrees(15)
        
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        path.closeSubpath()
        
        return path
    }
}
