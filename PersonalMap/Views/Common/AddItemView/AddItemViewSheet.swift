import Foundation

enum AddItemViewSheet: Identifiable {
    var id: Int {
        self.hashValue
    }
    
    case image
    case pdf
}
