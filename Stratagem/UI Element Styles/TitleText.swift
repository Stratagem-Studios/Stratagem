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

public struct TitleTextWithBorder: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        TitleText(text)
            .overlay(RoundedRectangle(cornerRadius: 5)
            .stroke(Color.white, lineWidth: 1)
        )
    }
}

public struct SmallTitleText: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(.custom("Montserrat-Bold", size: 15))
            .background(Color("TitleBackground"))
            .foregroundColor(Color.white)
            .padding()
            .frame(height: 25)
            .background(Color("TitleBackground"))
            .cornerRadius(5)
            .foregroundColor(.white)
    }
}

public struct SmallTitleTextWithBorder: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        SmallTitleText(text)
            .overlay(RoundedRectangle(cornerRadius: 5)
            .stroke(Color.white, lineWidth: 1)
        )
    }
}

struct TitleText_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TitleText("Hello, World!")
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color.gray)
                .previewDisplayName("Title Text")
            
            TitleTextWithBorder("Hello, World!")
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color.gray)
                .previewDisplayName("Title Text with Border")
            
            SmallTitleText("Hello, World!")
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color.gray)
                .previewDisplayName("Small Title Text")
            
            SmallTitleTextWithBorder("Hello, World!")
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color.gray)
                .previewDisplayName("Small Title Text with Border")
        }
    }
}
