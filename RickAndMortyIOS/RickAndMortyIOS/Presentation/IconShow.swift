//
//  ImageShow.swift
//  RickAndMortyIOS
//
//  Created by DarkRader on 22.08.2024.
//

import SwiftUI

struct IconShow: View {
    let name: String
    let size: CGFloat
    let colorName: Color
    
    var body: some View {
        Image(systemName: name)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .padding(.trailing, 8)
            .foregroundColor(colorName)
    }
}
