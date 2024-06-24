import Foundation
import MetalKit

class Renderer: NSObject, MTKViewDelegate, ObservableObject {
    let device: MTLDevice
    let view: MTKView
    let commandQueue: MTLCommandQueue
    
    init(device: MTLDevice, view: MTKView) {
        self.device = device
        self.view = view
        commandQueue = device.makeCommandQueue()!
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
