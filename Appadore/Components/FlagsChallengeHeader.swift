//
//  FlagsChallengeHeader.swift
//  Appadore
//
//  Created by Munavar on 17/07/2025.
//

import SwiftUI

struct FlagsChallengeHeader: View {
    var timer: Int?
    var body: some View {
        HStack {
            ZStack {
                CustomRoundedShape()
                    .fill(Color.black)

                RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
                .fill(
                    LinearGradient(
                        gradient: Gradient(
                            stops: [
                                .init(
                                    color: .clear,
                                    location: 0.0
                                ),
                                .init(
                                    color: Color.white
                                        .opacity(0.35),
                                    location: 0.48
                                ),
                                .init(
                                    color: Color.white
                                        .opacity(0.3),
                                    location: 0.5
                                ),
                                .init(
                                    color: Color.white
                                        .opacity(0.35),
                                    location: 0.52
                                ),
                                .init(
                                    color: .clear,
                                    location: 1.0
                                )
                            ]
                        ),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .blur(radius: 2)
                Text(formatTime(timer ?? 0))
                    .font(
                        .system(
                            size: 18,
                            weight: .bold,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(.white)
                    .shadow(
                        color: .black.opacity(0.7),
                        radius: 2,
                        x: 0,
                        y: 1
                    )
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
            }
            .frame(width: 95, height: 65)
            Spacer()
            ZStack {
                Text("FLAGS CHALLENGE")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .stroke(color: .black)
                Text("FLAGS CHALLENGE")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.standard.primary)
            }
            Spacer()
        }
        .padding(.top, 12)
        .overlay(alignment: .bottom) {
            Divider()
                .background(Color.black.opacity(0.15))
                .frame(height: 1)
        }
        
            
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
#Preview {
    ScheduleView()
}
