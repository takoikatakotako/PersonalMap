import SwiftUI

class AddMapPointViewState: ObservableObject {
    @Published var labelName: String = ""
    @Published var symbolName: String = "star.circle"
    @Published var longitude: String = ""
    @Published var latitude: String = ""
}
