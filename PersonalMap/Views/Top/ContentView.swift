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
            MapView(mapObjects: $viewModel.mapObjects, mapType: $viewModel.mapType) { (location: CLLocationCoordinate2D) in
                if viewModel.addObjectStatus == .ready {
                    return
                } else if viewModel.addObjectStatus == .point {
                    viewModel.showAddPointSheet(location: location)
                } else if viewModel.addObjectStatus == .line {
                    viewModel.appendLineLocations(location: location)
                } else if viewModel.addObjectStatus == .area {
                    viewModel.appendAreaLocation(location: location)
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
                TopHeaderButton(systemName: "square.stack.3d.up") {
                    viewModel.showMapObjectList()
                }
                
                TopHeaderButton(systemName: "paperplane") {
                    viewModel.showChangeMapTypeActionSheet()
                }
            }
            
            Spacer()
            
            TopPlusButton {
                viewModel.actionSheet = .newObject
            }
        }
    }
    
    @ViewBuilder
    func pointContent() -> some View {
        VStack {
            Spacer()
            Button(action: {
                viewModel.resetAddPointMode()
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
                    viewModel.resetAddLineMode()
                }, label: {
                    Text("閉じる")
                        .font(Font.system(size: 24))
                })
                .padding(8)
                
                Button(action: {
                    viewModel.showAddLineSheet()
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
        case .mapObjectList:
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
    func addLine(line: PolyLine) {
        viewModel.addLine(line: line)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
