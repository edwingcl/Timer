//
//  ContentView.swift
//  Elec_Test
//
//  Created by Jameel Shammr on 28/10/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CircularTimer(time: CircularTimerViewModel.Time(hours: 0, minutes: 0, seconds: 30), progress: 0.0)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
