import SwiftUI

struct AddMapPolygonView: View {    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewState: AddMapPolygonViewState
    
    init(mapLayerId: UUID) {
        _viewState = StateObject(wrappedValue: AddMapPolygonViewState(mapLayerId: mapLayerId))
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    MapObjectLabelTextField(labelName: $viewState.labelName)
                    
                    MapObjectHiddenSelecter(hidden: $viewState.hidden)
                    
                    MapObjectSymbolSelecter(symbolName: $viewState.symbolName)

                    MapObjectMultiLocationSelecter(coordinates: $viewState.coordinates)
                    
                    MapObjectItems(items: $viewState.items)
                }
            }
            .navigationBarItems(
                trailing:
                    Button(action: {
                        viewState.savePolygon()
                    }, label: {
                        Text("登録")
                            .font(Font.system(size: 16).bold())
                    })
            )
            .alert(isPresented: $viewState.showingAlert)  {
                Alert(title: Text(""), message: Text(viewState.message), dismissButton: .default(Text("閉じる")))
            }
            .onReceive(viewState.$dismiss, perform: { dismiss in
                if dismiss {
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .padding(.horizontal, 16)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("エリアの新規登録")
        }
    }
}
