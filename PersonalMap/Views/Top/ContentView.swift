import SwiftUI
import MapKit

enum AddObjectStatus {
    case ready
    case point
    case line
    case area
}

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            MapView(mapObjects: $viewModel.mapObjects, mapType: $viewModel.mapType) { (location) in
                if viewModel.addObjectStatus == .ready {
                    return
                } else if viewModel.addObjectStatus == .point {
                    viewModel.showAddPointSheet(location: location)
                } else if viewModel.addObjectStatus == .line {
                    viewModel.addLine(location: location)
                }
            }
            .ignoresSafeArea()
            
            if viewModel.addObjectStatus == .ready {
                readyContent()
            } else if viewModel.addObjectStatus == .point {
                pointContent()
            } else if viewModel.addObjectStatus == .line {
                lineContent()
            }
        }
        .sheet(
            item: $viewModel.sheet,
            onDismiss: {
                viewModel.setReadyMode()
            },
            content: { (item: ContentViewModelSheet) in
                sheetContent(item: item)
            })
        .actionSheet(item: $viewModel.actionSheet) { (item: ContentViewModelActionSheet) in
            actionSheetContent(item: item)
        }
    }
    
    @ViewBuilder
    func readyContent() -> some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.showPointList()
                }) {
                    Image(systemName: "square.stack.3d.up")
                        .padding(8)
                        .background(Color.orange)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.blue, lineWidth: 2))
                }
                
                Button(action: {
                    viewModel.showChangeMapTypeActionSheet()
                }) {
                    Image(systemName: "paperplane")
                        .padding(8)
                        .background(Color.orange)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.blue, lineWidth: 2))
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.actionSheet = .newObject
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
            .padding(8)
        }
    }
    
    @ViewBuilder
    func pointContent() -> some View {
        VStack {
            Spacer()
            Button(action: {
                viewModel.setReadyMode()
            }, label: {
                Text("閉じる")
                    .font(Font.system(size: 24))
            })
            .padding(8)
        }
    }
        
    @ViewBuilder
    func lineContent() -> some View {
        VStack {
            Spacer()
            
            HStack {
                Button(action: {
                    viewModel.setReadyMode()
                }, label: {
                    Text("閉じる")
                        .font(Font.system(size: 24))
                })
                .padding(8)
                
                Button(action: {
                    viewModel.addLineXXX()
                }, label: {
                    Text("決定")
                        .font(Font.system(size: 24))
                })
                .padding(8)
            }
        }
    }
    
    @ViewBuilder
    func sheetContent(item: ContentViewModelSheet) -> some View {
        switch item {
        case let .addPoint(_, location):
            AddNewPointView(location: location, delegate: self)
        case let .addLine(_, locations):
            AddNewLineView(locations: locations, delegate: self)
        case .pointList:
            MapObjectListView(mapObjects: $viewModel.mapObjects)
        }
    }
    
    func actionSheetContent(item: ContentViewModelActionSheet) -> ActionSheet {
        switch item {
        case .newObject:
            return ActionSheet(
                title: Text("追加"),
                message: Text("追加するオブジェクトの種類を選択してください"),
                buttons:
                    [
                        .default(Text("ポイント"), action: {
                            viewModel.setAddPointMode()
                        }),
                        .default(Text("ライン"), action: {
                            viewModel.setAddLineMode()
                        }),
                        .default(Text("エリア"), action: {
                            viewModel.setAddAreaMode()
                        }),
                        .cancel()
                    ]
            )
        case .changeMapType:
            return ActionSheet(
                title: Text("マップタイプ変更"),
                message: Text("マップタイプを選択してください"),
                buttons:
                    [
                        .default(Text("standard"), action: {
                            viewModel.changeMapType(mapType: .standard)
                        }),
                        .default(Text("hybrid"), action: {
                            viewModel.changeMapType(mapType: .hybrid)
                        }),
                        .default(Text("hybridFlyover"), action: {
                            viewModel.changeMapType(mapType: .hybridFlyover)
                        }),
                        .default(Text("satellite"), action: {
                            viewModel.changeMapType(mapType: .satellite)
                        }),
                        .cancel()
                    ]
            )
        }
    }
    
    

}

extension ContentView: AddPointModalViewDelegate {
    func addPoint(point: Point) {
        viewModel.addPoint(point: point)
    }
}

extension ContentView: AddNewLineViewDelegate {
    func addLine(line: Line) {
        viewModel.addLine(line: line)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
