import SwiftUI
import MapKit

class ContentViewModel: ObservableObject {
    @Published var showingActionSheet = false
    @Published var status: Status = .ready
    
    @Published var points: [Point] = []
    
    
    @Published var showingAddPointModal = false
    @Published var showingPointListModal = false
    
    @Published var activeSheet: ActiveSheet?


    var newPoint: CLLocationCoordinate2D?
    
    func addPoint(location: CLLocationCoordinate2D) {
        newPoint = location
        activeSheet = .first
        // showingAddPointModal = true
        
        // points.append(location)
    }
    
    func showPointList() {
        activeSheet = .second
    }
}

//レイヤー名
//タイトル
// 項目は自由に
// 送電線名: xxx [String: String]
