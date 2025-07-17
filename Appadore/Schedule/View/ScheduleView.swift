//
//  ScheduleView.swift
//  Appadore
//
//  Created by Munavar on 17/07/2025.
//

import SwiftUI
import Foundation

struct ScheduleView: View {
    var timer: Int?
    @State private var hour: String = "0"
    @State private var minute: String = "0"
    @State private var second: String = "0"
    @State private var isNavigatiToTimerView = false
    
    @EnvironmentObject var appManagerVM: AppManager
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.standard.primary)
                        .frame(height: 80)
                    
                    ZStack {
                        VStack(spacing: 0) {
                            FlagsChallengeHeader(timer: appManagerVM.questionTimeRemaining)
                            
                            if appManagerVM.isGameScheduled == false {
                                VStack {
                                    Text("SCHEDULE")
                                        .font(.system(size: 20, weight: .black))
                                        .foregroundStyle(Color.black)
                                        .padding(.top, 12)
                                        .padding(.bottom, 8)
                                        .frame(maxWidth: .infinity)
                                        .multilineTextAlignment(.center)
                                        .background(
                                            Color.clear
                                        )
                                    HStack(spacing: 24) {
                                        VStack {
                                            Text("Hour")
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundStyle(Color.gray)
                                            
                                            TextField("0", text: $hour)
                                                .keyboardType(.numberPad)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 48, height: 48)
                                                .background(Color.gray.opacity(0.12))
                                                .cornerRadius(8)
                                                .font(
                                                    .system(
                                                        size: 22,
                                                        weight: .bold,
                                                        design: .monospaced
                                                    )
                                                )
                                        }
                                        VStack {
                                            Text("Minute")
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundStyle(Color.gray)
                                            TextField("0", text: $minute)
                                                .keyboardType(.numberPad)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 48, height: 48)
                                                .background(Color.gray.opacity(0.12))
                                                .cornerRadius(8)
                                                .font(
                                                    .system(
                                                        size: 22,
                                                        weight: .bold,
                                                        design: .monospaced
                                                    )
                                                )
                                        }
                                        VStack {
                                            Text("Second")
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundStyle(Color.gray)
                                            TextField("0", text: $second)
                                                .keyboardType(.numberPad)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 48, height: 48)
                                                .background(Color.gray.opacity(0.12))
                                                .cornerRadius(8)
                                                .font(
                                                    .system(
                                                        size: 22,
                                                        weight: .bold,
                                                        design: .monospaced
                                                    )
                                                )
                                        }
                                    }
                                    .padding(.top, 8)
                                    .padding(.bottom, 20)
                                    Button(action: {
                                        let hourInt = Int(hour) ?? 0
                                        let minuteInt = Int(minute) ?? 0
                                        let secondInt = Int(second) ?? 0
                                        let total = ScheduleStorage.shared.saveSchedule(hour: hourInt, minute: minuteInt, second: secondInt)
                                        appManagerVM.questionTimeRemaining = total
                                        appManagerVM.startCountdown()
                                    }) {
                                        Text("Save")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundStyle(.white)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 30)
                                            .background(Color.standard.primary)
                                            .cornerRadius(8)
                                    }
                                    .padding(.horizontal, 40)
                                    .padding(.bottom, 20)
                                }
                            } else if appManagerVM.isGameOver {
                                GameOverView(score: appManagerVM.totalScore, onRestart: {
                                    appManagerVM.resetGame()
                                })
                            } else if appManagerVM.isCountdownRunning {
                                VStack(spacing: 8) {
                                    Text("CHALLENGE")
                                        .font(.system(size: 18, weight: .semibold))
                                    Text("WILL START IN")
                                        .font(.system(size: 18, weight: .semibold))
                                        .padding(.top)
                                    RollingView(isCount: $appManagerVM.countdownRemaining)
                                }
                                .padding(.vertical, 16)
                            } else if let question = appManagerVM.currentQuestion {
                                TimerView(question: question)
                                    .environmentObject(appManagerVM)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.standard.lightGray.opacity(0.3))
                            .shadow(
                                color: .black.opacity(0.08),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                            .padding(.top, 12)
                    )
                    .padding(.horizontal, 8)
                }
            }
            .background(Color(.white).ignoresSafeArea())
            .ignoresSafeArea(edges: .top)
            .scrollIndicators(.hidden)
        }
        .onAppear {
            appManagerVM.loadQuestions()
            appManagerVM.restoreGameState()
            appManagerVM.startQuestionTimer()
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


struct RollingView: View {
    @Binding var isCount: Int
    @State private var rotationAngle: Double = 0.0
    
    var body: some View {
        VStack {
            Text("\(isCount)")
                .font(.largeTitle)
                .padding()
        }
    }
}
