import SwiftUI
import MetalKit

@main
struct RTRCApp: App {
    let device: MTLDevice
    let metalView: MTKView
    var renderer: Renderer
    
    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Failed to create system gpu device")
        }
        
        self.device = device
        metalView = MTKView()
        metalView.device = device
        metalView.colorPixelFormat = .bgra8Unorm
        metalView.enableSetNeedsDisplay = false
        metalView.preferredFramesPerSecond = 12
        metalView.clearColor = MTLClearColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        metalView.framebufferOnly = false
        renderer = Renderer(device: device, view: metalView)
        metalView.delegate = renderer
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(device: device, metalView: metalView, renderer: renderer)
        }.windowResizability(.contentSize)
    }
}
