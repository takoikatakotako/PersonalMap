import SwiftUI

struct AddMapPointView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewState: AddMapPointViewState
    
    init(mapLayerId: UUID) {
        _viewState = StateObject(wrappedValue: AddMapPointViewState(mapLayerId: mapLayerId))
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    MapObjectLabelTextField(labelName: $viewState.labelName)
                    
                    MapObjectHiddenSelecter(hidden: $viewState.hidden)
                    
                    MapObjectSymbolSelecter(symbolName: $viewState.symbolName)
                    
                    MapObjectSingleLocationSelecter(latitude: $viewState.latitude, longitude: $viewState.longitude)
                    
                    MapObjectItems(items: $viewState.items)
                }
            }
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
            .navigationTitle("ポイントの新規登録")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        viewState.savePoint()
                    }, label: {
                        Text("登録")
                            .font(Font.system(size: 16).bold())
                    })
            )
        }
    }
}

struct AddMapPointObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddMapPointView(mapLayerId: UUID())
    }
}
