import SwiftUI

struct LoadImageByUrl: View {
    let imageUrl: String?
    let size: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl ?? "")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } placeholder: {
            Color.gray
                .frame(width: 140, height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
