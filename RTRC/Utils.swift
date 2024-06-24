import Foundation
import MetalKit

class Utils {
    static func logDeviceAtributes(device: MTLDevice) {
        print("GPU Name: \(device.name)")
        print("GPU Family: \(device.supportsFamily(.apple3) ? "Apple 3" : "Apple 2 or lower")")
        print("Max Threadgroup Memory Per Compute Kernel: \(device.maxThreadgroupMemoryLength)")
        print("Max Threads Per ThreadGroup: \(device.maxThreadsPerThreadgroup)")
        print("Has Unified Memory: \(device.hasUnifiedMemory)")
        print("Supports Ray Tracing: \(device.supportsRaytracing)")
        print("Supports Ray Tracing From Render: \(device.supportsRaytracingFromRender)")
    }
}
