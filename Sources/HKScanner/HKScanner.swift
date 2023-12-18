// The Swift Programming Language
// https://docs.swift.org/swift-book
import RealityKit
import SwiftUI
import os

@available(iOS 17.0, *)
/// The root of the SwiftUI view graph.
public struct HKScanner: View {
    static let logger = Logger(subsystem: _DScannerApp.subsystem,
                                category: "ContentView")
    
    let onCompletedCallback: (URL) -> Void
    public init(onCompletedCallback: @escaping (URL) -> Void) {
        self.onCompletedCallback = onCompletedCallback
    }

    @StateObject var appModel: AppDataModel = AppDataModel.instance
    
    @State private var showReconstructionView: Bool = false
    @State private var showErrorAlert: Bool = false
    private var showProgressView: Bool {
        appModel.state == .completed || appModel.state == .restart || appModel.state == .ready
    }

    public var body: some View {
        VStack {
            if appModel.state == .capturing {
                if let session = appModel.objectCaptureSession {
                    CapturePrimaryView(session: session)
                }
            } else if showProgressView {
                CircularProgressView()
            }
        }
        .onChange(of: appModel.state) { _, newState in
            if newState == .failed {
                showErrorAlert = true
                showReconstructionView = false
            } else {
                showErrorAlert = false
                showReconstructionView = newState == .reconstructing || newState == .viewing
            }
        }
        .sheet(isPresented: $showReconstructionView) {
            if let folderManager = appModel.scanFolderManager {
                ReconstructionPrimaryView(outputFile: folderManager.modelsFolder.appendingPathComponent("model-mobile.usdz"), onCompletedCallback: onCompletedCallback)
            }
        }
        .alert(
            "Failed:  " + (appModel.error != nil  ? "\(String(describing: appModel.error!))" : ""),
            isPresented: $showErrorAlert,
            actions: {
                Button("OK") {
                    HKScanner.logger.log("Calling restart...")
                    appModel.state = .restart
                }
            },
            message: {}
        )
        .environmentObject(appModel)
    }
}

private struct CircularProgressView: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .light ? .black : .white))
                Spacer()
            }
            Spacer()
        }
    }
}

#if DEBUG
@available(iOS 17.0, *)
struct HKScanner_Previews: PreviewProvider {
    static var previews: some View {
        HKScanner() { url in }
    }
}
#endif
