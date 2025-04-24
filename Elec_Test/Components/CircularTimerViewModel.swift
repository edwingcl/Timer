//
//  CircularTimerViewModel.swift
//  iosApp
//
//  Created by Mohamed Alwakil on 2022-10-18.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import Combine
import AVFoundation

typealias ProgressTimer = Publishers.Autoconnect<Timer.TimerPublisher>

class CircularTimerViewModel: ObservableObject {

    struct Time {
        let hours: Int
        let minutes: Int
        let seconds: Int

        var interval: TimeInterval {
            TimeInterval(hours * 3600 + minutes * 60 + seconds)
        }
    }

    @Published var progress: CGFloat = 0
    @Published var timerInterval: TimeInterval
    @Published var isRunning = false

    //let timer: ProgressTimer
    private let timeStep = 0.25
    private var stepProgress: CGFloat
    private var cancellable: Cancellable?
    private var audioPlayer: AVAudioPlayer?

    init(interval: TimeInterval, progress: CGFloat) {

        self.progress = progress
        self.stepProgress = timeStep / CGFloat(interval)
        self.timerInterval = interval * (1 - progress)
    }
    
    func startTimer() {
        cancellable = Timer.publish(every: timeStep, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] _ in

                guard let self = self
                else { return 1.0 }

                if self.progress >= 1.0 || self.timerInterval <= 0 {
                    self.cancellable?.cancel()
                    self.playSound()
                    
                    return 1.0
                } else {
                    self.isRunning = true
                    self.timerInterval -= self.timeStep
                    print("progress \(self.progress)")
                    return self.progress + self.stepProgress
                }
            }
            .assign(to: \.progress, on: self)
    }
    
    func pauseTimer() {
        self.cancellable?.cancel()
    }
    
    func reset(to interval: TimeInterval? = nil, progress: CGFloat = 0.0) {
        cancellable?.cancel()
        self.progress = progress
        
        let actualInterval = interval ?? self.timerInterval / (1 - progress)
        self.timerInterval = actualInterval * (1 - progress)
        self.stepProgress = CGFloat(timeStep / actualInterval)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.startTimer()
        }
    }
    
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "timer-completion-sound", withExtension: "wav") else {
            print("Audio file not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }

    func textFromTimeInterval() -> String {
        if timerInterval <= 0 {
            return "Completed"
        }
        
        let time = Int(timerInterval)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3_600)

        if hours != 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes != 0 {
            return "\(minutes)m"
        } else {
            return "\(seconds)s"
        }
    }

    private func hoursString(hours: Int) -> String{
        return "\(hours) hr"
    }
    
    private func minutesString(minutes: Int) -> String {
        return "\(minutes) min"
    }
    
    private func shortMinutesString(minutes: Int) -> String {
        return "\(minutes)m"
    }
    
    private func shortSecondsString(seconds: Int) -> String {
        return "\(seconds)s"
    }
    
//    private func hoursString(hours: Int) -> String {
//        languageService.getResourceString(resourceKey: StringKey().timerHours, params: [hours.toString].toKotlin())
//    }
//
//    private func minutesString(minutes: Int) -> String {
//        languageService.getResourceString(resourceKey: StringKey().timerMinutes, params: [minutes.toString].toKotlin())
//    }
//
//    private func shortMinutesString(minutes: Int) -> String {
//        languageService.getResourceString(resourceKey: StringKey().timeMinutesShort, params: [minutes.toString].toKotlin())
//    }
//
//    private func shortSecondsString(seconds: Int) -> String {
//        languageService.getResourceString(resourceKey: StringKey().timeSecondsShort, params: [seconds.toString].toKotlin()).trimmingCharacters(in: .whitespaces)
//    }
}
