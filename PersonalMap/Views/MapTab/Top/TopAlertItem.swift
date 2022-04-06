import SwiftUI
import MapKit

enum TopAlertItem: Identifiable {
    var id: UUID {
        switch self {
        case let .routeConfirmAlert(id, _):
            return id
        case let .messageAlert(id, _):
            return id
        }
    }
    
    case routeConfirmAlert(UUID, CLLocationCoordinate2D)
    case messageAlert(UUID, String)
}
