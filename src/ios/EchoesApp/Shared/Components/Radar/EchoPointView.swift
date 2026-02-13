import SwiftUI

struct EchoPointView: View {
    var color: Color

    var body: some View {
        ZStack {
            Circle().fill(color.opacity(0.1)).frame(width: 48, height: 48)
            Circle().fill(color.opacity(0.3)).frame(width: 24, height: 24)
            Circle().fill(color).frame(width: 12, height: 12)
        }
    }
}
