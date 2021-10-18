//
//  ContentView.swift
//  Drawing-project-9
//
//  Created by Ifang Lee on 10/17/21.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Use path to draw a triangle")
                    Path { path in
                        path.move(to: CGPoint(x: 200, y: 100))
                        path.addLine(to: CGPoint(x: 100, y: 300))
                        path.addLine(to: CGPoint(x: 300, y: 300))
                        path.addLine(to: CGPoint(x: 200, y: 100))
                    }
                    .stroke(Color.blue.opacity(0.3), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                }

                VStack {
                    Text("Use shape to draw a triangle")
                    Triangle()
                        .stroke(Color.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .frame(width: 100, height: 100)

                }
            }

            Text("Use shape to draw a arc")
            Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: false)
                .strokeBorder(Color.gray, lineWidth: 10)
                .frame(width: 200, height: 200)

            HStack {
                Circle()
                    .stroke(Color.green, lineWidth: 20) //border cut out by screen

                Circle()
                    .strokeBorder(Color.blue, lineWidth: 20)
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

/**
 0 degrees is not straight upwards, but instead directly to the right.
 Shapes measure their coordinates from the bottom-left corner rather than the top-left corner, which means SwiftUI goes the other way around from one angle to the other.

 we can fix above behavior by subtract 90 degrees from start/end angles
 // need to conform to InsettableShape protocol to use strokeBorder
 */
struct Arc: InsettableShape { //InsettableShape builds upon Shape, so no need to conform both
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool

    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment

        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)

        return path
    }

    // required by InsettableShape
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
