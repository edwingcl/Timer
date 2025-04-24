//
//  CustomCircularProgressBar.swift
//  iosApp
//
//  Created by Mohamed Alwakil on 20220926.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import Foundation
import Combine
/**
 # ``CircularTimer`` is a circle shaped progress bar.
  ``Time``  the Total time in hours, minutes, seconds
  ``progress``  progress percentage 0.0 to 1.0 ex. 0.3 mean 70% of time will load.

 # Example of usage:
 ```swift

 progress start from 0.0 and finish 1.0

 CustomCircularProgressBar(
 time: CustomCircularProgressBar.Time(hours: 0, minutes: 1, seconds: 0),
 progress: 0.0
 )
 } ```
 */

struct CircularTimer: View {
    @StateObject private var viewModel: CircularTimerViewModel
    private let strokeWidth = CGFloat(12)

    init(time: CircularTimerViewModel.Time, progress: CGFloat) {
        self._viewModel = StateObject(wrappedValue: CircularTimerViewModel(interval: time.interval, progress: progress))
    }

    let originalInterval = CircularTimerViewModel.Time(hours: 0, minutes: 0, seconds: 30).interval
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                
                HStack{
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(lineWidth: strokeWidth)
                            .foregroundColor(Color(hex: 0xFF323333))

                        Circle()
                            .trim(from: 0, to: viewModel.progress)
                            .stroke(style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
                            .foregroundColor(Color(hex: 0xFF4f758b))
                    }
                    .frame(width: proxy.size.width * 0.7, alignment: .center)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: viewModel.progress)
                    .overlay(
                        Text(viewModel.textFromTimeInterval())
                            .font(.largeTitle)
                            .bold()
                            .monospaced()
                            .animation(.easeInOut, value: viewModel.progress)
                    )
                    
                    Spacer()
                }
                
                HStack{
                    if viewModel.textFromTimeInterval() != "Completed"{
                        Button(action:{
                            if viewModel.isRunning{
                                viewModel.pauseTimer()
                            }else{
                                viewModel.startTimer()
                            }
                            
                            withAnimation{
                                viewModel.isRunning.toggle()
                            }
                        }){
                            Text(viewModel.isRunning ? "Pause" : "Play")
                                .font(.headline)
                                .bold()
                                .foregroundStyle(.white)
                                .padding(12)
                                .padding(.horizontal)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .background(
                                    Capsule()
                                        .fill(.orange)
                                )
                        }.buttonStyle(.plain)
                    }
                    
                    Button(action:{
                        viewModel.reset(to: originalInterval, progress: 0.0)
                    }){
                        Text("Restart Timer")
                            .font(.headline)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(12)
                            .padding(.horizontal)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(
                                Capsule()
                                    .fill(Color(hex: 0xFF4f758b))
                            )
                    }.buttonStyle(.plain)
                }.padding(.top)
                .padding()
                
                Spacer()
            }
        }.onAppear(){
            viewModel.startTimer()
        }
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

struct CircularTimer_Previews: PreviewProvider {

    static var previews: some View {

        CircularTimer(time: CircularTimerViewModel.Time(hours: 0, minutes: 0, seconds: 30),
                      progress: 0.0)
    }
}
