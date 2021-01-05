import SwiftUI
import SpriteKit
import SwiftVideoBackground

public struct CityView: View {
    
    public var body: some View {
        SpriteView(scene: Global.gameVars.cityScene)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView()
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
