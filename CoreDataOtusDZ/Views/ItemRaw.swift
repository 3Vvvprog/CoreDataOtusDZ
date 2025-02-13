//
//  Item.swift
//  CoreDataOtusDZ
//
//  Created by Вячеслав Вовк on 13.02.2025.
//

import SwiftUI

struct ItemRaw: View {
    let character: Item
    var body: some View {
        VStack {
            if let image = character.image, let url = URL(string: image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                }placeholder: {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            }
            Text(character.name ?? "")
            Text(String(character.id))
        }
       
    }
}

