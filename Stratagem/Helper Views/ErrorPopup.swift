import SwiftUI

struct ErrorPopup: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    
    var body: some View {
        VisualEffectView(effect: UIBlurEffect(style: .dark))
        
        ZStack {
            Color.gray
            VStack {
                Text("ERROR")
                Spacer()
                Text(playerVariables.errorMessage)
                Spacer()
                Button(action: {
                    // Close popup
                    playerVariables.errorMessage = ""
                }, label: {
                    Text("OK")
                })
            }.padding()
        }
        .frame(width: 300, height: 200)
        .cornerRadius(20).shadow(radius: 10)
    }
}

struct ErrorPopup_Previews: PreviewProvider {
    static var previews: some View {
        //ErrorPopup(errorMessage: "Firebase failed to load, please restart the game", showPopup: false)
        EmptyView()
    }
}
