//
//  ContentView.swift
//  Drawing-project-9
//
//  Created by Ifang Lee on 10/17/21.
//

import SwiftUI

/**
 1. Create an Arrow shape made from a rectangle and a triangle – having it point straight up is fine.
 2. Make the line thickness of your Arrow shape animatable.
 https://www.hackingwithswift.com/books/ios-swiftui/animating-bindings
 3. Create a ColorCyclingRectangle shape that is the rectangular cousin of ColorCyclingCircle, allowing us to control the position of the gradient using a property.
 */
struct ContentView: View {
    @State private var colorCycle = 0.0
    var points:[(point: UnitPoint, name: String)] = [
        (.top, "top"),
        (.bottom, "bottom"),
        (.center, "center"),
        (.topLeading,"topLeading"),
        (.topTrailing,"topTrailing"),
        (.bottomTrailing,"bottomTrailing"),
        (.bottomLeading, "bottomLeading"),
        (.leading, "leading")
    ]
    @State private var startPoint: UnitPoint = .top
    @State private var endPoint: UnitPoint = .bottom

    @State private var arrowLineWidth = 25.0

    var body: some View {
        VStack {
            Arrow(insetAmount: arrowLineWidth)
                .rotation(.degrees(90))
                .stroke(Color.orange, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .frame(width: 100, height: 100)

            // animate binding
            Slider(value: $arrowLineWidth.animation(
                Animation.easeInOut(duration: 5)
            ), in: 1...50)
                .padding()

            ColorCyclingRectangle(amount: self.colorCycle, startPoint: startPoint, endPoint: endPoint)
                .frame(width: 100, height: 70)
                .padding()

            Text("Choose Color")
            Slider(value: $colorCycle)
                .padding()

            Text("Choose Gradient start point")
            Picker(selection: $startPoint, label: Text("Gradient start point")) {
                ForEach(points, id: \.self.name) {
                    Text("\($0.name)")
                }
            }

            Text("Choose Gradient end point")
            Picker(selection: $endPoint, label: Text("Gradient end point")) {
                ForEach(points, id: \.1) {
                    Text("\($0.name)")
                }
            }
        }
    }

}

struct Arrow: Shape {
    var insetAmount: CGFloat
    var animatableData: CGFloat {
        get { insetAmount }
        set { self.insetAmount = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY - rect.height / 2))
        path.addLine(to: CGPoint(x: rect.minX - rect.width / 2 - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX + rect.width / 2 + insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY - rect.height / 2))

        path.addRect(rect)

        return path
    }
}

struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100
    var startPoint: UnitPoint = .top
    var endPoint: UnitPoint = .bottom

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.3)
                    ]), startPoint: self.startPoint, endPoint: self.endPoint), lineWidth: 50)
            }
        }
        .drawingGroup()
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
