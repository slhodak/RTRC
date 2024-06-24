import SwiftUI
import MetalKit

@main
struct RTRCApp: App {
    let device: MTLDevice
    let metalView: MTKView
    let renderer: Renderer
    
    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Failed to create system gpu device")
        }
        
        self.device = device
        metalView = MTKView()
        metalView.device = device
        metalView.colorPixelFormat = .bgra8Unorm
        metalView.framebufferOnly = false
        metalView.preferredFramesPerSecond = 30
        renderer = Renderer(device: device, view: metalView)
        metalView.delegate = renderer
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(device: device, metalView: metalView)
        }
    }
}
