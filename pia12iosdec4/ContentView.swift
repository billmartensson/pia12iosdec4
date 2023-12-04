//
//  ContentView.swift
//  pia12iosdec4
//
//  Created by BillU on 2023-12-04.
//

import SwiftUI

import UserNotifications

struct ContentView: View {
    
    @State var mynumber = 0
    
    @AppStorage("tapCount") private var tapCount = 0
    
    
    @State var showMessage = false
    
    @State var timernumber = 0
    
    @State var funtext = ""
    
    var body: some View {
        VStack {
            
            Text("More text to translate", comment: "The top text")
            
            Text(funtext)
            
            Text(String(mynumber))
            Button(action: {
                addnumber()
                funtext = String(localized: "Very funny")
            }, label: {
                Text("More number")
            })
            
            Button("Tap count: \(tapCount)") {
                tapCount += 1
            }
            
            Button(action: {
                showMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showMessage = false
                }
                
            }, label: {
                Text("Show")
                    .padding()
            })
            
            if showMessage {
                Text("This is message")
            }
            
            Text(String(timernumber))
                .font(.largeTitle)
            
            
            Button("Request Permission") {
                notifRequest()
            }
            .padding()
            
            Button("Schedule Notification") {
                notifSchedule()
            }
            .padding()
        }
        .padding()
        .onAppear() {
            let defaults = UserDefaults.standard
            let loadnumber = defaults.integer(forKey: "thenumber")
            
            mynumber = loadnumber
            
            timernumber = defaults.integer(forKey: "timer")
            
            var timertime = defaults.double(forKey: "timertime")
            if timertime != 0 {
                var extratime = Date().timeIntervalSince1970 - timertime
                
                timernumber = timernumber + Int(extratime)
                
            }
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                
                timernumber = timernumber + 1
                
                defaults.set(timernumber, forKey: "timer")
                
                defaults.set(Date().timeIntervalSince1970, forKey: "timertime")
                
            }
            
        }
    }
    
    func addnumber() {
        mynumber = mynumber + 1
        
        let defaults = UserDefaults.standard
        defaults.setValue(mynumber, forKey: "thenumber")
    }
    
    func notifRequest() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func notifSchedule() {
        let content = UNMutableNotificationContent()
        content.title = "Feed the cat"
        content.subtitle = "It looks hungry"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    
    
    
    func saveStuff() {
        let defaults = UserDefaults.standard
        defaults.setValue("Torsten", forKey: "name")
        defaults.setValue(3, forKey: "age")
    }
    
    func loadStuff() {
        let defaults = UserDefaults.standard
        
        var name = defaults.string(forKey: "name")
    }
}

#Preview {
    ContentView()
}
