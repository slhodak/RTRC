import MetalKit
import SwiftUI

struct ContentView: View {
    let device: MTLDevice
    let metalView: MTKView
    @StateObject var renderer: Renderer
    
    var body: some View {
        VStack {
            MetalView(device: device, view: metalView)
            XYZView(name: "Camera Position",
                    xyz: $renderer.cameraPosition)
        }
        .padding()
        .frame(width: 600, height: 600)
    }
}

struct XYZView: View {
    let name: String
    @Binding var xyz: SIMD3<Float>
    
    var body: some View {
        Text(name).bold()
        HStack {
            TextField("x", value: $xyz.x, format: .number)
            TextField("y", value: $xyz.y, format: .number)
            TextField("z", value: $xyz.z, format: .number)
        }.frame(width: 200)
    }
}
