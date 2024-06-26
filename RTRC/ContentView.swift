import MetalKit
import SwiftUI

struct ContentView: View {
    let device: MTLDevice
    let metalView: MTKView
    @StateObject var renderer: Renderer
    
    var body: some View {
        VStack {
            MetalView(device: device, view: metalView)
                .frame(width: 600, height: 600)
            XYZView(name: "Camera Position", xyz: $renderer.cameraPosition)
            XYZSliders(name: "Light Color", xyz: $renderer.lightColor)
        }
        .frame(height: 800)
        .padding()
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

struct XYZSliders: View {
    let name: String
    @Binding var xyz: SIMD3<Float>
    var min: Float = 0
    var max: Float = 1
    
    var body: some View {
        Text(name).bold()
        VStack {
            Slider(value: $xyz.x, in: min...max)
            Slider(value: $xyz.y, in: min...max)
            Slider(value: $xyz.z, in: min...max)
        }.frame(width: 200)
    }
}
