import SwiftUI

struct AddMapObjectEditLocation: View {
    @Binding var coordinates: [Coordinate]
    let index: Int
    
    @State private var latitudeString: String = ""
    @State private var longitudeString: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("緯度を入力してください", text: $latitudeString)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("経度を入力してください", text: $longitudeString)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
            }
            .padding()
            .onAppear {
                latitudeString = coordinates[index].latitude.description
                longitudeString = coordinates[index].longitude.description

            }
        }
    }
}

//struct AddMapObjectEditLocation_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMapObjectEditLocation()
//    }
//}
