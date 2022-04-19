import SwiftUI

enum MapObjectItemsSheetItem: Hashable, Identifiable {
    var id: Self {
        return self
    }
    case showItemList
    case shoeImage(imageName: String)
}
