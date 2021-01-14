import SwiftUI
import SwiftVideoBackground

public struct WinScreenView: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    
    public var body: some View {
        ZStack {
            VStack {
                TitleText(text: "Victory!!")
                    .padding(.top, 10)
                
                Spacer()
                
                Button(action: {playerVariables.currentView = .TitleScreenView}) {
                    Text("Home")
                }.buttonStyle(BasicButtonStyle())
                .padding(.bottom, 10)
            }
        }
    }
}
