import SwiftUI

struct MapPointObject: Codable, Identifiable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
}
