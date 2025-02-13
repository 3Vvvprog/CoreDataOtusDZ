//
//  Item.swift
//  CoreDataOtusDZ
//
//  Created by Вячеслав Вовк on 13.02.2025.
//

import SwiftUI

struct ItemRaw: View {
    let character: Item
    @EnvironmentObject var viewModel: ViewModel
    @State private var imageData: Data?
    var body: some View {
        VStack {
            if let imageData, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
            }else {
                ProgressView()
                    .frame(width: 100, height: 100)
                    .progressViewStyle(CircularProgressViewStyle())
                    .task {
                        imageData = await viewModel.loadImage(character: character)
                    }
            }
            Text(character.name ?? "")
            Text(String(character.id))
        }
       
    }
}

