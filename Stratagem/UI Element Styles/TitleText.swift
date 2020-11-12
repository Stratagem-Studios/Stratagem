//
//  TitleText.swift
//  Stratagem
//
//  Created by 64004080 on 11/3/20.
//

import SwiftUI

public struct TitleText: View {
    let text: String
    var backgroundColor: Color = Color("TitleBackground")
    var iconName: String? = nil
    
    public var body: some View {
        HStack {
            if let iconName = iconName {
                Image(iconName)
                    .resizable()
                    .frame(width: 32, height: 32)
            }
            Text(text)
                .font(.custom("Montserrat-Bold", size: 20))
                .background(backgroundColor)
                .foregroundColor(Color.white)
        }
        .padding()
        .frame(height: 40)
        .background(backgroundColor)
        .cornerRadius(5)
        .foregroundColor(.white)
    }
}

public struct TitleTextWithBorder: View {
    let text: String
    var backgroundColor: Color = Color("TitleBackground")
    var iconName: String? = nil
    
    public var body: some View {
        TitleText(text: text, backgroundColor: backgroundColor, iconName: iconName)
            .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.white, lineWidth: 1)
            )
    }
}

public struct SmallTitleText: View {
    let text: String
    var iconName: String? = nil
    
    public var body: some View {
        HStack {
            if let iconName = iconName {
                Image(iconName)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            Text(text)
                .font(.custom("Montserrat-Bold", size: 15))
                .background(Color("TitleBackground"))
                .foregroundColor(Color.white)
        }
        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
        .frame(height: 25)
        .background(Color("TitleBackground"))
        .cornerRadius(5)
        .foregroundColor(.white)
    }
}

public struct SmallTitleTextWithBorder: View {
    let text: String
    var iconName: String? = nil
    
    public var body: some View {
        SmallTitleText(text: text, iconName: iconName)
            .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.white, lineWidth: 1)
            )
    }
}

struct TitleText_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TitleText(text: "Hello, World!")
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color.gray)
                .previewDisplayName("Title Text")
            
            TitleText(text: "Hello, World!", iconName: "Galaxy")
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color.gray)
                .previewDisplayName("Title Text with Icon")
            
            TitleTextWithBorder(text: "Hello, World!")
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color.gray)
                .previewDisplayName("Title Text with Border")
            
            TitleTextWithBorder(text: "Hello, World!", backgroundColor: Color("ErrorColor"))
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color.gray)
                .previewDisplayName("Title Text with Border Error")
            
            SmallTitleText(text: "Hello, World!")
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color.gray)
                .previewDisplayName("Small Title Text")
            
            SmallTitleTextWithBorder(text: "Hello, World!")
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color.gray)
                .previewDisplayName("Small Title Text with Border")
            
            SmallTitleTextWithBorder(text: "Hello, World!", iconName: "Galaxy")
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color.gray)
                .previewDisplayName("Small Title Text with Border and Icon")
        }
    }
}
