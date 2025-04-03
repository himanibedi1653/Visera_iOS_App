//
//  AboutRowView.swift
//  Profile
//
//  Created by Himani Bedi on 21/03/25.
//

import SwiftUI

struct AboutRowView: View {
    let icon: String
    let fieldName: String
    @Binding var notificationsEnabled: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "B69D53"))
                .frame(width: 30)
            
            Text(fieldName)
                .foregroundColor(.primary)
            
            Spacer()
            
            if fieldName == "Notifications" {
                Toggle("", isOn: $notificationsEnabled)
                    .labelsHidden()
            }
        }
        .padding(.vertical, 4)
    }
}
