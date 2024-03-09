//
//  ContentView.swift
//  mouseventapp
//
//  Created by Eren Demir on 9.03.2024.
//

import SwiftUI
import Cocoa
var timer: Timer?
var combinationKeys = Set<UInt16>()
struct ContentView: View {
    
    func moveMouse(to point: CGPoint) {
        let moveEvent = CGEvent(
            mouseEventSource: nil,
            mouseType: .mouseMoved,
            mouseCursorPosition: point,
            mouseButton: .left
        )
        moveEvent?.post(tap: .cghidEventTap)
    }
    
    func timerInitial() {
        timer =  Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            moveMouse(to: CGPoint(x: Int.random(in: 1...1024), y: Int.random(in: 1...720)))
        }
    }
    
    func listenForEvents() {
        NSApplication.shared.hide(nil)
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            keyDown(event: event)
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: .keyUp) { event in
            keyUp(event: event)
        }
    }
    
    func keyDown(event: NSEvent) {
        combinationKeys.insert(event.keyCode)
        checkCombination()
    }
    
    func keyUp(event: NSEvent) {
        combinationKeys.remove(event.keyCode)
    }
    
    func checkCombination() {
        let sKeyCode: UInt16 = 1
        let pKeyCode: UInt16 = 35
        let tKeyCode: UInt16 = 17
        let backspaceKeyCode: UInt16 = 51
        if combinationKeys.contains(sKeyCode) && combinationKeys.contains(tKeyCode) && combinationKeys.contains(backspaceKeyCode) {
            timerInitial()
        }else if combinationKeys.contains(sKeyCode) && combinationKeys.contains(pKeyCode) && combinationKeys.contains(backspaceKeyCode) {
            timer?.invalidate()
            timer = nil
            combinationKeys = []
        }
    }
    
    var body: some View {
        let _ = NSApplication.shared.setActivationPolicy(.prohibited)
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear{
            listenForEvents()
        }
    }
}

#Preview {
    ContentView()
}
