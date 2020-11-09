import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var gameVariables: GameVariables
    
    var body: some View {
        switch gameVariables.currentView {
        case "TitleScreenView":
            TitleScreenView()
        case "JoinGameView":
            JoinGameView()
        case "CityView":
            CityView()
        default:
            EmptyView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GameVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
