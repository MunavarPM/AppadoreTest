//
//  GameOverView.swift
//  Appadore
//
//  Created by Munavar on 17/07/2025.
//

import SwiftUI

struct GameOverView: View {
    let score: Int
    let onRestart: () -> Void
    var body: some View {
        VStack {
            Text("GAME OVER")
                .font(.largeTitle)
                .bold()
                .padding(30)
            Text("SCORE: \(score)/15")
                .font(.title)
                .padding(.bottom)
            
            Button(action: {
                onRestart()
            }) {
                Text("Play Again")
                    .foregroundColor(.white)
                    .frame(width: 150, height: 45)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding(.bottom)
        }
    }
}

