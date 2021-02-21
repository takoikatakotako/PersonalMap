import SwiftUI
import MapKit

class ContentViewModel: ObservableObject {
    @Published var showingActionSheet = false
    @Published var status: Status = .add
    
    @Published var points: [CLLocationCoordinate2D] = []
    
    
    @Published var showingAddPointModal = false
    
    
    var newPoint: CLLocationCoordinate2D?
    
    func addPoint(location: CLLocationCoordinate2D) {
        self.newPoint = location
        showingAddPointModal = true
        
        // points.append(location)
    }
}

//レイヤー名
//タイトル
// 項目は自由に
// 送電線名: xxx [String: String]
