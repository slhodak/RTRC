import Foundation
import MetalKit

class Renderer: NSObject, MTKViewDelegate, ObservableObject {
    let device: MTLDevice
    let view: MTKView
    let commandQueue: MTLCommandQueue
    let computePipelineState: MTLComputePipelineState
    let accelerationStructure: MTLAccelerationStructure
    var outputTexture: MTLTexture
    
    init(device: MTLDevice, view: MTKView) {
        self.device = device
        self.view = view
        commandQueue = device.makeCommandQueue()!
        computePipelineState = Renderer.makeComputePipelineState(device: device)
        accelerationStructure = Renderer.makeAccelerationStructure(device: device)
        outputTexture = Renderer.makeOutputTexture(device: device)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let computeEncoder = commandBuffer.makeComputeCommandEncoder() else {
            return
        }
        
        computeEncoder.setComputePipelineState(computePipelineState)
        computeEncoder.setAccelerationStructure(accelerationStructure, bufferIndex: 0)
        computeEncoder.setTexture(outputTexture, index: 0)
        computeEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    static func makeOutputTexture(device: MTLDevice) -> MTLTexture {
        let descriptor = MTLTextureDescriptor()
        descriptor.width = 300
        descriptor.height = 300
        descriptor.pixelFormat = .bgra8Unorm
        guard let texture = device.makeTexture(descriptor: descriptor) else {
            fatalError("Failed to make output texture")
        }
        
        return texture
    }
    
    static func makeComputePipelineState(device: MTLDevice) -> MTLComputePipelineState {
        let descriptor = MTLComputePipelineDescriptor()
        
        let options: [MTLPipelineOption] = []
        do {
            let pipelineState = try device.makeComputePipelineState(descriptor: descriptor,
                                                                    options: [],
                                                                    reflection: nil)
            return pipelineState
        } catch {
            fatalError("Failed to make compute pipeline state")
        }
    }
    
    static func makeAccelerationStructure(device: MTLDevice) -> MTLAccelerationStructure {
        let descriptor = MTLAccelerationStructureDescriptor()
        
        guard let structure = device.makeAccelerationStructure(descriptor: descriptor) else {
            fatalError("Failed to make acceleration structure")
        }
        
        return structure
    }
}
