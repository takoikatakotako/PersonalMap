import SwiftUI

enum MapObjectItemsSheetItem: Hashable, Identifiable {
    var id: Self {
        return self
    }
    case showItemList
    case showImage(imageName: String)
}
