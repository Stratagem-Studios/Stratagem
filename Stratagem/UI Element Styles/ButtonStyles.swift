//
//  ButtonStyles.swift
//  Stratagem
//
//  Created by 64004080 on 11/2/20.
//

import SwiftUI

public struct BasicButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.custom("Montserrat-Bold", size: 20))
            .background(Color("ButtonBackground"))
            .foregroundColor(Color.white)
            .padding()
            .frame(height: 40)
            .background(Color("ButtonBackground"))
            .cornerRadius(5)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                   .stroke(Color.white, lineWidth: 1)
            )
        //.scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}

struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {
            print("pressed button")
        }) {
            Text("PLAY")
        }.buttonStyle(BasicButtonStyle())
        .previewLayout(PreviewLayout.sizeThatFits)
        .padding()
        .background(Color.gray)
        .previewDisplayName("Basic Button")
    }
}
