import SwiftUI

struct ProfileHeaderView: View {
    @ObservedObject var userDataModel: UserDataModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Profile Image
            if let profileImage = userDataModel.getUserImage(forUser: userDataModel.currentUser) {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color(hex: "B69D53"), lineWidth: 2)
                    )
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .foregroundColor(Color(hex: "B69D53"))
            }
            
            // User information
            VStack(alignment: .leading, spacing: 4) {
                Text(userDataModel.getUserName(forUser: userDataModel.currentUser))
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(userDataModel.getUserHandle(forUser: userDataModel.currentUser))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
}
