import MetalKit
import SwiftUI

struct ContentView: View {
    let device: MTLDevice
    let metalView: MTKView
    
    var body: some View {
        VStack {
            MetalView(device: device, view: metalView)
        }
        .padding()
        .frame(width: 600, height: 600)
    }
}
