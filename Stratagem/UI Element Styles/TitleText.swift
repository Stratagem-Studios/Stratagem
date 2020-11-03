//
//  TitleText.swift
//  Stratagem
//
//  Created by 64004080 on 11/3/20.
//

import SwiftUI

public struct TitleText: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(.custom("Montserrat-Bold", size: 20))
            .background(Color("TitleBackground"))
            .foregroundColor(Color.white)
            .padding()
            .frame(height: 40)
            .background(Color("TitleBackground"))
            .cornerRadius(5)
            .foregroundColor(.white)
    }
}

struct TitleText_Previews: PreviewProvider {
    static var previews: some View {
        TitleText("Hello, World!")
        .previewLayout(PreviewLayout.sizeThatFits)
        .padding()
    }
}
