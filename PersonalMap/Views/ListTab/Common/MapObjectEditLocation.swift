import SwiftUI

struct MapObjectEditLocation: View {
    @Binding var coordinates: [Coordinate]
    let index: Int
    
    @State private var latitudeString: String = ""
    @State private var longitudeString: String = ""
    @State private var showingSheet: Bool = false
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    init(coordinates: Binding<[Coordinate]>, index: Int) {
        self._coordinates = coordinates
        self.index = index
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("座標の編集")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                
                TextField("緯度を入力してください", text: $latitudeString)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("経度を入力してください", text: $longitudeString)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Spacer()
                    Button {
                        showingSheet = true
                    } label: {
                        Text("地図から設定")
                    }
                }
                
                Spacer()
            }
            .sheet(isPresented: $showingSheet, onDismiss: {
                
            }, content: {
                LocationSelecterBindingCoordinate(coordinate: $coordinates[index])
            })
            .onAppear {
                latitudeString = coordinates[index].latitude.description
                longitudeString = coordinates[index].longitude.description
            }
            .alert(isPresented: $showingAlert)  {
                Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("閉じる")))
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("座標の編集")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        updateCoordinate()
                    }, label: {
                        Text("更新")
                            .font(Font.system(size: 16).bold())
                    }
                          )
            )
        }
    }
    
    private func updateCoordinate() {
        guard let latitude = Double(latitudeString), let longitude = Double(longitudeString) else {
            alertMessage = "kabigon"
            showingAlert = true
            return
        }
        
        coordinates[index] = Coordinate(latitude: latitude, longitude: longitude)
    }
}

//struct AddMapObjectEditLocation_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMapObjectEditLocation()
//    }
//}
