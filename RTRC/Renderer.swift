import Foundation
import MetalKit

class Renderer: NSObject, MTKViewDelegate, ObservableObject {
    let device: MTLDevice
    let view: MTKView
    let commandQueue: MTLCommandQueue
    let computePipelineState: MTLComputePipelineState
//    let accelerationStructure: MTLAccelerationStructure
//    var outputTexture: MTLTexture
    var uniforms: Uniforms
    
    init(device: MTLDevice, view: MTKView) {
        self.device = device
        self.view = view
        commandQueue = device.makeCommandQueue()!
        computePipelineState = Renderer.makeComputePipelineState(device: device)
//        accelerationStructure = Renderer.makeAccelerationStructure(device: device)
//        outputTexture = Renderer.makeOutputTexture(device: device)
        uniforms = Renderer.makeUniforms()
        
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let computeEncoder = commandBuffer.makeComputeCommandEncoder() else {
            return
        }
        
        computeEncoder.setComputePipelineState(computePipelineState)
//        computeEncoder.setAccelerationStructure(accelerationStructure, bufferIndex: 0)
        computeEncoder.setTexture(drawable.texture, index: 0)
        computeEncoder.setBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 0)
        
        let threadGroupSize = MTLSize(width: 8, height: 8, depth: 1)
        let threadGroups = MTLSize(width: drawable.texture.width / threadGroupSize.width,
                                   height: drawable.texture.height / threadGroupSize.height,
                                   depth: 1)
        
        computeEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupSize)
        computeEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    static func makeUniforms() -> Uniforms {
        return Uniforms(cameraPosition: SIMD3<Float>(0, 0, -5),
                        sphereCenter: SIMD3<Float>(0, 0, 0),
                        sphereRadius: 1.0)
    }
    
//    static func makeOutputTexture(device: MTLDevice) -> MTLTexture {
//        let descriptor = MTLTextureDescriptor()
//        descriptor.width = 300
//        descriptor.height = 300
//        descriptor.pixelFormat = .bgra8Unorm
//        guard let texture = device.makeTexture(descriptor: descriptor) else {
//            fatalError("Failed to make output texture")
//        }
//        
//        return texture
//    }
    
    static func makeComputePipelineState(device: MTLDevice) -> MTLComputePipelineState {
        do {
            guard let library = device.makeDefaultLibrary(),
                  let function = library.makeFunction(name: "rayTraceKernel") else {
                fatalError("Failed to make default library or function")
            }
            
            let pipelineState = try device.makeComputePipelineState(function: function)
            return pipelineState
        } catch {
            fatalError("Failed to make compute pipeline state")
        }
    }
    
//    static func makeAccelerationStructure(device: MTLDevice) -> MTLAccelerationStructure {
//        let descriptor = MTLAccelerationStructureDescriptor()
//        
//        guard let structure = device.makeAccelerationStructure(descriptor: descriptor) else {
//            fatalError("Failed to make acceleration structure")
//        }
//        
//        return structure
//    }
}

struct Sphere {
    var center: SIMD3<Float>
    var radius: Float
}

struct Ray {
    var origin: SIMD3<Float>
    var direction: SIMD3<Float>
}

struct Uniforms {
    var cameraPosition: SIMD3<Float>
    var sphereCenter: SIMD3<Float>
    var sphereRadius: Float
}
