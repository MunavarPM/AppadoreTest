//
//  CustomRoundedShape.swift
//  Appadore
//
//  Created by Munavar on 17/07/2025.
//

import SwiftUI

struct CustomRoundedShape: Shape {
    var topLeft: CGFloat?
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let topLeft: CGFloat = topLeft ?? 10
        let topRight: CGFloat = 10
        let bottomRight: CGFloat = 10
        let bottomLeft: CGFloat = 0

        path.move(to: CGPoint(x: rect.minX + topLeft, y: rect.minY))

        // Top edge
        path.addLine(to: CGPoint(x: rect.maxX - topRight, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - topRight, y: rect.minY + topRight),
                    radius: topRight,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)

        // Right edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
        path.addArc(center: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight),
                    radius: bottomRight,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)

        // Bottom edge
        path.addLine(to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY))

        // Bottom-left corner (no radius)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))

        // Top-left corner
        path.addArc(center: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft),
                    radius: topLeft,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)

        return path
    }
}

#Preview {
    CustomRoundedShape()
        .fill(Color.black)
        .frame(width: 150, height: 80)
        .shadow(radius: 5)
}
