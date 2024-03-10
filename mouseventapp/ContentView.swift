//
//  ContentView.swift
//  mouseventapp
//
//  Created by Eren Demir on 9.03.2024.
//

import SwiftUI
import Cocoa

struct ContentView: View {
    
    @State private var isMoving = false
    @State private var timer: Timer?

    var body: some View {
        let _ = NSApplication.shared.setActivationPolicy(.prohibited)
        VStack {
            Text("Start Mouse Move")
                .font(.largeTitle)
                .padding()

            Button(action: toggleMovement) {
                Text(isMoving ? "Stop" : "Start")
                    .font(.title)
                    .padding()
                    .background(isMoving ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear(perform: setupKeyBindings)
    }

    func toggleMovement() {
        if isMoving {
            stopMovement()
        } else {
            startMovement()
        }
    }

    func startMovement() {
        isMoving = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            moveMouse()
        }
    }

    func stopMovement() {
        isMoving = false
        timer?.invalidate()
        timer = nil
    }

    func moveMouse() {
        let deltaX = Double.random(in: -10...10)
        let deltaY = Double.random(in: -10...10)

        let currentLocation = NSEvent.mouseLocation
        let newLocation = CGPoint(x: currentLocation.x + deltaX, y: currentLocation.y + deltaY)

        let mouseEvent = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: newLocation, mouseButton: .left)!
        mouseEvent.post(tap: .cghidEventTap)
    }

    func setupKeyBindings() {
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            if event.modifierFlags.contains(.command) && event.charactersIgnoringModifiers == "ç" {
                toggleMovement()
            }
        }
    }
}

#Preview {
    ContentView()
}
