//
//  RemoteImage.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import SwiftUI

struct RemoteImage: View {
    
    let url: String?
    var size: CGSize = CGSize(width: 60, height: 60)
    
    var body: some View {
        if let imageUrl = url {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: size.width, maxHeight: size.height)
                        .scaledToFill()
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.black, lineWidth: 2))
                case .failure:
                    Image(systemName: "person.fill.questionmark")
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: size.width, maxHeight: size.height)
                        .scaledToFill()
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.black, lineWidth: 2))
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "person.fill.questionmark")
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: 60, maxHeight: 60)
                .scaledToFill()
                .clipShape(Circle())
                .overlay(Circle().stroke(.black, lineWidth: 2))
        }
    }
}

#Preview {
    RemoteImage(url: "https://static.wikia.nocookie.net/disney/images/d/d3/Vlcsnap-2015-05-06-23h04m15s601.png", 
                size: CGSize(width: 150, height: 150))
}
