//
//  ContentView.swift
//  Drawing-project-9
//
//  Created by Ifang Lee on 10/17/21.
//

import SwiftUI

struct ContentView: View {
    @State private var insetAmount: CGFloat = 50

    @State private var rows = 4
    @State private var columns = 4
    @State private var color = Color.green

    var body: some View {
        VStack {
            Checkerboard(rows: rows, columns: columns)
                .foregroundColor(color)
                .onTapGesture {
                    withAnimation(.linear(duration: 3)) {
                        self.rows = 8
                        self.columns = 8
                        self.color = .pink
                    }
                }

            Trapezoid(insetAmount: insetAmount)
                .frame(width: 300, height: 150)
                .onTapGesture {
                    withAnimation {
                        self.insetAmount = CGFloat.random(in: 10...90)

                    }
                }
        }

    }
}

// animatableData
struct Trapezoid: Shape {
    var insetAmount: CGFloat
    // required data for animation
    var animatableData: CGFloat {
        get {insetAmount}
        set {
            self.insetAmount = newValue
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))

        return path
    }
}

//AnimatablePair
struct Checkerboard: Shape {
    var rows: Int
    var columns: Int

    // animatable data of 2
    public var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(Double(rows), Double(columns))
        }

        set {
            self.rows = Int(newValue.first)
            self.columns = Int(newValue.second)
        }
    }
    // animatable data of 4:
//    AnimatablePair<CGFloat, AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>>
// newValue.second.second.first

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // figure out how big each row/column needs to be
        let rowSize = rect.height / CGFloat(rows)
        let columnSize = rect.width / CGFloat(columns)

        // loop over all rows and columns, making alternating squares colored
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    // this square should be colored; add a rectangle here
                    let startX = columnSize * CGFloat(column)
                    let startY = rowSize * CGFloat(row)

                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)

                    path.addRect(rect)
                }
            }
        }
        return path
    }


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
