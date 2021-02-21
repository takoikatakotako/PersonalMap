import SwiftUI
import MapKit

enum Status {
    case ready
    case point
    case line
    case area
}

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapView(points: $viewModel.points) { (location) in
                if viewModel.status == .ready {
                    return
                } else if viewModel.status == .point {
                     viewModel.addPoint(location: location)
                }
            }
            
            if viewModel.status == .ready {
                Button(action: {
                    viewModel.showingActionSheet = true
                }, label: {
                    Image(systemName: "plus")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .frame(width: 30, height: 30)
                        .padding(12)
                        .background(Color.gray)
                        .cornerRadius(30)
                })
                .padding(32)
            } else if viewModel.status == .point {
                Button(action: {
                    viewModel.status = .ready
                }, label: {
                    Text("閉じる")
                        .font(Font.system(size: 24))
                })
                .padding(32)
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $viewModel.showingAddPointModal, onDismiss: {
            viewModel.status = .ready
        }, content: {
            if let newPoint = viewModel.newPoint {
                AddPointModalView(location: newPoint, delegate: self)
            } else {
                Text("Error")
            }
        })
        .actionSheet(isPresented: $viewModel.showingActionSheet) {
            ActionSheet(
                title: Text("追加"),
                message: Text("追加するオブジェクトの種類を選択してください"),
                buttons:
                    [
                        .default(Text("ポイント"), action: {
                            viewModel.status = .point
                        }),
                        .default(Text("ライン"), action: {
                            viewModel.status = .line
                        }),
                        .default(Text("エリア"), action: {
                            viewModel.status = .area
                        }),
                        .cancel()
                    ]
            )
        }
        
    }
}

extension ContentView: AddPointModalViewDelegate {
    func addPoint(point: Point) {
        viewModel.points.append(point)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
