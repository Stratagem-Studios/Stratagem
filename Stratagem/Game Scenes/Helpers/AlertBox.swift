import Foundation
import SwiftUI

struct AlertBoxView: View {
    let screenSize = UIScreen.main.bounds
    @ObservedObject var alertBox = AlertBox()
    
    public var body: some View {
        ZStack{
            Rectangle()
                .fill(alertBox.rectFillColor)
            Text(alertBox.msg)
        }.offset(CGSize(width: alertBox.xPos, height:0))
        .gesture(
            DragGesture()
                .onChanged {_ in alertBox.xPos = -UIScreen.main.bounds.width/8}
        )
    }
    
    func addAlert(msg: String, rectColor: Color ){
        alertBox.msg = msg
        alertBox.rectFillColor = rectColor
        alertBox.xPos = screenSize.width/8
    }
}

class AlertBox : ObservableObject {
    @Published var xPos: CGFloat = -UIScreen.main.bounds.width/8
    @Published var msg = "eee"
    @Published var rectFillColor = Color.blue
}
