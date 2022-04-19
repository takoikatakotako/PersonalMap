import SwiftUI

struct ImageViewerView: View {
    
    let image: UIImage?
    init(imageName: String) {
        let fileRepository = FileRepository()
        image = fileRepository.getImageData(fileName: imageName)
    }
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
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
