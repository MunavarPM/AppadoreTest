//
//  TimerView.swift
//  Appadore
//
//  Created by Munavar on 17/07/2025.
//

import SwiftUI

struct TimerView: View {
    
    @EnvironmentObject var appManager: AppManager
    let question: FlagQuestion
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var timer: Int?
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack {
                    HStack(alignment: .center) {
                        Text("\(1)")
                            .font(.system(size: 14))
                            .padding(10)
                            .foregroundStyle(Color.white)
                            .background(Color.standard.primary)
                            .clipShape(Circle())
                            .background(
                                CustomRoundedShape(topLeft: 0)
                                    .fill(Color.black.opacity(0.9))
                                    .frame(width: 40, height: 40)
                            )
                        Spacer()
                        Text("GUESS THE COUNTRY FROM THE FLAG ?")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.top, 10)
                        
                    HStack(alignment: .center){
                        Spacer()
                        Image(question.countryCode)
                            .resizable()
                            .frame(width: 70, height: 50)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(5)
                        Spacer()
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(question.countries) { option in
                                VStack(spacing: 5){
                                    Button(action: {
                                        appManager.selectAnswer(option.id)
                                    }) {
                                        Text(option.countryName)
                                            .lineLimit(1)
                                            .font(
                                                .system(
                                                    size: 12,
                                                    weight: .regular
                                                )
                                            )
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 5)
                                            .background(
                                                buttonBackground(option: option)
                                            )
                                            .foregroundColor(
                                                buttonTextColor(option: option)
                                            )
                                            .overlay(
                                                RoundedRectangle(
                                                    cornerRadius: 8
                                                )
                                                .stroke(
                                                    borderColor(option: option),
                                                    lineWidth: 1
                                                )
                                            )
                                            .cornerRadius(8)
                                    }
                                    .disabled(appManager.showingAnswer)
                                    if appManager.showingAnswer {
                                        if option.id == question.answerID {
                                            Text("CORRECT")
                                                .font(.system(size: 6))
                                                .foregroundColor(.green)
                                        } else if option.id == appManager.selectedAnswer {
                                            Text("WRONG")
                                                .font(.system(size: 6))
                                                .foregroundColor(.red)
                                        } else {
                                            EmptyView()
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 16)
                }
                .padding(.bottom, 24)
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
            .scrollIndicators(.hidden)
            
            .ignoresSafeArea(edges: .top)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    private func buttonBackground(option: CountryOption) -> Color {
        if appManager.showingAnswer {
            if option.id == question.answerID {
                return Color.green.opacity(0.1)
            } else if option.id == appManager.selectedAnswer {
                return Color.red.opacity(0.1)
            }
        }
        return Color.white
    }
    
    private func buttonTextColor(option: CountryOption) -> Color {
        if appManager.showingAnswer {
            if option.id == question.answerID {
                return .green
            } else if option.id == appManager.selectedAnswer {
                return .red
            }
        }
        return .black
    }
    
    private func borderColor(option: CountryOption) -> Color {
        if appManager.showingAnswer {
            if option.id == question.answerID {
                return .green
            } else if option.id == appManager.selectedAnswer {
                return .red
            }
        }
        return Color.gray.opacity(0.4)
    }
}


