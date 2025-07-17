import SwiftUI

struct RollingView: View {
    @Binding var value: Int
    var font: Font = .system(size: 48, weight: .bold, design: .monospaced)
    var textColor: Color = .black
    var animation: Animation = .spring(response: 0.4, dampingFraction: 0.7)
    var digitSpacing: CGFloat = 0
    
    @State private var previousValue: Int = 0
    
    var body: some View {
        HStack(spacing: digitSpacing) {
            ForEach(digits(for: value).indices, id: \ .self) { idx in
                RollingDigitView(
                    value: digits(for: value)[idx],
                    previousValue: digits(for: previousValue, padTo: digits(for: value).count)[idx],
                    font: font,
                    textColor: textColor,
                    animation: animation
                )
            }
        }
        .onChange(of: value) { oldValue, newValue in
            previousValue = oldValue
        }
        .onAppear {
            previousValue = value
        }
    }
    
    private func digits(for number: Int, padTo: Int? = nil) -> [Int] {
        let string = String(number)
        let digits = string.compactMap { $0.wholeNumberValue }
        if let padTo, digits.count < padTo {
            return Array(repeating: 0, count: padTo - digits.count) + digits
        }
        return digits
    }
}

private struct RollingDigitView: View {
    let value: Int
    let previousValue: Int
    var font: Font
    var textColor: Color
    var animation: Animation
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                ForEach(0..<10) { digit in
                    Text("\(digit)")
                        .font(font)
                        .foregroundColor(textColor)
                        .frame(width: geo.size.width, height: geo.size.height / 1.1)
                }
            }
            .offset(y: -CGFloat(value) * geo.size.height / 1.1)
            .animation(animation, value: value)
        }
        .frame(width: 32, height: 48)
        .clipped()
    }
}

#Preview {
    StatefulPreviewWrapper(7) { RollingView(value: $0) }
}

// Helper for preview
struct StatefulPreviewWrapper<Value: MutablePropertyWrapper & DynamicProperty, Content: View>: View where Value.Value: Equatable {
    @State private var value: Value.Value
    var content: (Binding<Value.Value>) -> Content
    init(_ initialValue: Value.Value, @ViewBuilder content: @escaping (Binding<Value.Value>) -> Content) {
        _value = State(initialValue: initialValue)
        self.content = content
    }
    var body: some View {
        content($value)
    }
} 