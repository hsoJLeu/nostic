import SwiftUI

struct SimpleImageView: View {
    var image: UIImage

    var body: some View {
        Image(uiImage: image).frame(width: 150,
                                    height: 150)
    }
}
