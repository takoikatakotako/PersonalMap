import SwiftUI

struct EditMapPolylineView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

//    @State var polyline: MapPolyLine
//    @State var newKey: String = ""
//    @State var newValue: String = ""
//        
    
    @StateObject var viewState: EditMapPolylineViewState
    
    init(polyLine: MapPolyLine) {
        _viewState = StateObject(wrappedValue: EditMapPolylineViewState(polyLine: polyLine))
    }
    
    
    var body: some View {
        Text("Comming Soon")
    }
}

//struct MapPolylineDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPolylineDetailView(polyline: <#MapPolyLine#>)
//    }
//}
