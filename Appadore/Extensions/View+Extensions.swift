//
//  View+Extensions.swift
//  Appadore
//
//  Created by Munavar on 17/07/2025.
//

import SwiftUI

extension View {
    func stroke(color: Color, width: CGFloat = 0.5) -> some View {
        modifier(StrokeModifier(strokeSize: width, strokeColor: color))
    }
}
