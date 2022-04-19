import SwiftUI
import MapKit

enum TopAlertItem: Identifiable, Hashable {
    var id: Self {
        return self
    }
    
    case routeConfirmAlert(Coordinate)
    case messageAlert(String)
}
