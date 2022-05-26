import SwiftUI

struct MapObjectHiddenSelecter: View {
    @Binding var hidden: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("表示")
                .font(Font.system(size: 20).bold())
                .padding(.top, 12)
            
            Picker("", selection: $hidden) {
                Text("表示").tag(false)
                Text("非表示").tag(true)
            }
            .pickerStyle(.segmented)
        }
    }
}
