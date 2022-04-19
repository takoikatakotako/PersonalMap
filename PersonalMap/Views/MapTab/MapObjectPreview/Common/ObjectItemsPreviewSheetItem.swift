import SwiftUI

enum ObjectItemsPreviewSheetItem: Hashable, Identifiable {
    var id: Self {
        return self
    }
    case shoeImage(imageName: String)
}
