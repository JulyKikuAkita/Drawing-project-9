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

    var body: some View {
        VStack {
            ColorCyclingRectangle(amount: self.colorCycle, startPoint: startPoint, endPoint: endPoint)
                .frame(width: 300, height: 300)
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
