import SwiftUI

struct InfoListView: View {
    @State private var showingSheet = false
    var body: some View {
        VStack {
            Text("Info一覧")
            
            Button {
                showingSheet = true
            } label: {
                Text("Itemを追加する")
            }


        }
        .sheet(isPresented: $showingSheet) {
            
        } content: {
            InfoInputView()
        }

    }
}

struct InputListView_Previews: PreviewProvider {
    static var previews: some View {
        InfoListView()
    }
}
