import Foundation

enum ActiveSheet: Identifiable {
    case first, second
    
    var id: Int {
        hashValue
    }
}
