import SwiftUI
import MapKit

struct Info: Identifiable {
    var id: UUID = UUID()
    let key: String
    let value: String
}

protocol AddPointModalViewDelegate {
    func addPoint(point: Point)
}

struct AddPointModalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let location: CLLocationCoordinate2D
    let delegate: AddPointModalViewDelegate
        
    @State var layerName: String = ""
    @State var infos: [Info] = [Info(key: "鉄塔", value: "鉄塔１"), Info(key: "所在", value: "長野県"), Info(key: "色", value: "赤色")]
    @State var showingAlert = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("座標")
                        .font(Font.system(size: 20).bold())
                    Text("緯度: \(location.longitude)")
                    Text("軽度: \(location.latitude)")
                    
                    Text("レイヤー名")
                        .font(Font.system(size: 20).bold())
                        .padding(.top, 16)
                    TextField("レイヤー名を入力してください", text: $layerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                    Text("項目の追加")
                        .font(Font.system(size: 20).bold())
                        .padding(.top, 16)
                    
                    LazyVStack(alignment: .leading) {
                        ForEach(infos) { info in
                            VStack {
                                HStack {
                                    Text(info.key)
                                    Text(" : ")
                                    Text(info.value)
                                    Spacer()
                                }
                                Divider()
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddInfoView(delegate: self)) {
                            Text("追加")
                                .foregroundColor(Color.white)
                                .frame(width: 60, height: 60)
                                .background(Color.green)
                                .cornerRadius(30)
                        }
                        Spacer()
                    }
                    .padding(.top, 16)
                    
                    
                    Button(action: {
                        if layerName.isEmpty {
                            showingAlert = true
                            return
                        }
                        delegate.addPoint(point: Point(layerName: layerName, location: location))
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("保存")
                            .font(Font.system(size: 24))
                            .foregroundColor(Color.white)
                            .frame(minWidth: 0 ,maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.gray)
                            .cornerRadius(16)
                            .padding(.top, 16)
                    })
                }
                .padding()
            }
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text("タイトル"),
                         message: Text("レイヤー名を入力する必要があります"),
                         dismissButton: .default(Text("了解")))
            })
            .navigationTitle("ポイントを追加")
        }
    }
}

extension AddPointModalView: AddInfoViewDelegate {
    func addInfo(info: Info) {
        infos.append(info)
    }
}

struct AddPointModalView_Previews: PreviewProvider {
    struct MockAddPointModalViewDelegate: AddPointModalViewDelegate {
        func addPoint(point: Point) {}
    }
    
    static var previews: some View {
        AddPointModalView(location: CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529), delegate: MockAddPointModalViewDelegate())
    }
}
