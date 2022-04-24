import SwiftUI

struct ImageViewer: UIViewRepresentable {
    let uiImage: UIImage

    func makeUIView(context: Context) -> UIImageViewerView {
        let view = UIImageViewerView(uiImage: uiImage)
        return view
    }

    func updateUIView(_ uiView: UIImageViewerView, context: Context) {}
}
