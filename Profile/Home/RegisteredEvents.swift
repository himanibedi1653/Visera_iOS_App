//
//  HomeView.swift
//  Visera
//
//  Created by student2 on 10/03/25.
//

import Foundation
import SwiftUI

struct RegisteredEventsView: View {
    @ObservedObject var userDataModel = UserDataModel.shared
    @State private var selectedIndex = 0 // Track current index
    @Binding var navigateToEventsTab: Bool

    var registeredEvents: [Event] {
        EventsDetailModel.shared.getRegisteredEvents(forUser: userDataModel.currentUser)
            .sorted {
                guard let date1 = convertToDate($0.eventDate ?? "0"),
                      let date2 = convertToDate($1.eventDate ?? "0") else { return false }
                return date1 < date2
            }
    }

    var upcomingEvents: [Event] {
        registeredEvents.filter { event in
            if let eventDate = convertToDate(event.eventDate ?? "0") {
                return eventDate > Date() // Only show upcoming events
            }
            return false
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Registered Events")
                .font(.title)
                .bold()

            if upcomingEvents.isEmpty {
                EmptyEventStateView(navigateToEventsTab: $navigateToEventsTab)
            } else {
                VStack {
                    TabView(selection: $selectedIndex) {
                        ForEach(upcomingEvents.indices, id: \ .self) { index in
                            HomeEventCard(event: upcomingEvents[index])
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .padding(.horizontal, 10)
                                .tag(index)
                        }
                    }
                    .frame(height: 180)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default dots

                    // Custom Small Dots Indicator
                    HStack(spacing: 10) {
                        let total = upcomingEvents.count
                        let maxVisibleDots = min(3, total) // Show up to 3 dots max

                        let startIndex = max(0, min(selectedIndex - maxVisibleDots / 2, total - maxVisibleDots))

                        ForEach(startIndex..<startIndex + maxVisibleDots, id: \ .self) { index in
                            Circle()
                                .frame(width: index == selectedIndex ? 12 : 8, height: index == selectedIndex ? 12 : 8)
                                .foregroundColor(index == selectedIndex ? Color(hex: "B69D53") : .gray.opacity(0.5))
                                .animation(.easeInOut(duration: 0.3), value: selectedIndex)
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
        .padding()
    }

    // Function to Convert String to Date
    func convertToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Adjust format based on actual data
        return formatter.date(from: dateString)
    }
}

// Empty State View
struct EmptyEventStateView: View {
    @Binding var navigateToEventsTab: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Image(systemName: "calendar.badge.plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(Color(hex: "B69D53").opacity(0.7))
            
            Text("No Upcoming Events")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Explore and register for exciting events to see them appear here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                navigateToEventsTab = true // Trigger navigation to Events tab
            }) {
                Text("Browse Events")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(hex: "B69D53"))
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
import SwiftUI

struct HomeEventCard: View {
    let event: Event
    @State private var countdownText: String = ""
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                // Event Image
                ZStack {
                    if let image = event.portraitImage.cgImage {
                        Image(uiImage: event.portraitImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 140)
                            .background(Color.white)
                            .cornerRadius(15)
                            .clipped()
                            .padding(.leading, 10)
                    } else {
                        ZStack {
                            Color.gray.opacity(0.3)
                                .cornerRadius(15)

                            VStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white.opacity(0.8))

                                Text("No Image")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                        }
                        .frame(width: 100, height: 140)
                        .cornerRadius(15)
                        .background(Color.white)
                        .padding(.leading, 10)
                    }
                }
                .frame(width: 100, height: 140)

                // Event Details
                VStack(alignment: .leading, spacing: 8) {
                    Text(event.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(2)

                    // Event Date with Calendar Icon
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Color(hex: "B69D53")) // Calendar icon color

                        Text(event.eventDate ?? "No Date")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }

                    // Location with Icon
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(Color(hex: "B69D53")) // Matched with calendar icon

                        Text(event.location ?? "Unknown Location")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }

                    // Countdown Timer
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(Color(hex: "B69D53"))

                        Text(countdownText)
                            .foregroundColor(Color(hex: "B69D53"))
                            .fontWeight(.medium)
                    }
                    .font(.system(size: 16))
                }
                .padding(.vertical, 12)
                .padding(.leading, 20)

                Spacer()
            }
            .padding(.horizontal, 10)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 160)
            .background(Color.white)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(hex: "B69D53"), lineWidth: 3)
            )
        }
        .onAppear {
            updateCountdown()
            startTimer()
        }
    }

    // Function to start a timer that updates the countdown every second
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateCountdown()
        }
    }

    // Function to calculate countdown
    private func updateCountdown() {
        countdownText = getCountdown(to: event.eventDate ?? "0") ?? "Event Started"
    }

    private func getCountdown(to dateString: String) -> String? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let possibleFormats = [
            "yyyy-MM-dd",
            "yyyy-MM-dd HH:mm",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "dd-MM-yyyy HH:mm",
        ]

        for format in possibleFormats {
            formatter.dateFormat = format
            if let eventDate = formatter.date(from: dateString) {
                let remainingTime = eventDate.timeIntervalSinceNow
                if remainingTime > 0 {
                    let days = Int(remainingTime) / 86400
                    let hours = (Int(remainingTime) % 86400) / 3600
                    let minutes = (Int(remainingTime) % 3600) / 60
                    let seconds = Int(remainingTime) % 60
                    return "\(days)d \(hours)h \(minutes)m \(seconds)s"
                } else {
                    return nil // Event started, so it should be removed
                }
            }
        }
        return "Invalid Date"
    }
}
