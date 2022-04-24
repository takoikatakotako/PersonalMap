import SwiftUI

struct ImageViewerView: View {
    
    let image: UIImage?
    init(imageName: String) {
        let fileRepository = FileRepository()
        image = fileRepository.getImageData(fileName: imageName)
    }
    
    var body: some View {
        if let image = image {
            ImageViewer(uiImage: image)
                .ignoresSafeArea(.all, edges: .all)
        } else {
            Text("イメージ")
        }
    }
}

struct ImageViewerView_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewerView(imageName: "")
    }
}
