import SwiftUI

enum ObjectItemsPreviewSheetItem: Hashable, Identifiable {
    var id: Self {
        return self
    }
    case showImage(imageName: String)
    case showPDF(fileName: String)
}
