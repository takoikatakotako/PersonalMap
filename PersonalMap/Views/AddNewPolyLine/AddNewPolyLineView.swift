import SwiftUI
import MapKit

protocol AddNewLineViewDelegate {
    func addLine(line: MapPolyLine)
}

struct AddNewPolyLineView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let locations: [CLLocationCoordinate2D]
    let delegate: AddNewLineViewDelegate
        
    @State var layerName: String = ""
    @State var infos: [Info] = []
    @State var showingAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // Text("座標")
                    //    .font(Font.system(size: 20).bold())
                    // Text("緯度: \(location.longitude)")
                    // Text("軽度: \(location.latitude)")
                    
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
                        delegate.addLine(line: MapPolyLine(isHidden: false, layerName: layerName, locations: locations, infos: infos))
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
            .navigationTitle("ラインを追加")
        }
    }
}

extension AddNewPolyLineView: AddInfoViewDelegate {
    func addInfo(info: Info) {
        infos.append(info)
    }
}

//struct AddNewLineView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNewLineView()
//    }
//}
