#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
//using namespace raytracing;

struct Ray {
    float3 origin;
    float3 direction;
};

struct Sphere {
    float3 center;
    float radius;
};

struct Uniforms {
    float3 cameraPosition;
    float3 sphereCenter;
    float sphereRadius;
    float3 lightColor;
};

bool intersectSphere(Ray ray, Sphere sphere, thread float &t) {
    float3 oc = ray.origin - sphere.center;
    float a = dot(ray.direction, ray.direction);
    float b = 2.0 * dot(oc, ray.direction);
    float c = dot(oc, oc) - sphere.radius * sphere.radius;
    float discriminant = b * b - 4 * a * c;
    
    if (discriminant < 0) {
        return false;
    } else {
        t = (-b - sqrt(discriminant)) / (2.0 * a);
        return (t > 0);
    }
}

float3 sphereNormal(float3 hitPoint, Sphere sphere) {
    return normalize(hitPoint - sphere.center);
}

kernel void rayTraceKernel(texture2d<float, access::write> outTexture [[texture(0)]],
                           constant Uniforms &uniforms [[buffer(0)]],
                           uint2 gid [[thread_position_in_grid]]) {
    int width = outTexture.get_width();
    int height = outTexture.get_height();
    
    float2 uv = float2(gid) / float2(width, height) * 2.0f - 1.0f;
    uv.y = -uv.y;
    
    Ray ray;
    ray.origin = uniforms.cameraPosition;
    ray.direction = normalize(float3(uv.x, uv.y, 1));
    
    Sphere sphere = { uniforms.sphereCenter, uniforms.sphereRadius };
    
    float t;
    float3 color = float3(0.1, 0.1, 0.1); // Background color
    
    if (intersectSphere(ray, sphere, t)) {
        float3 hitPoint = ray.origin + t * ray.direction;
        float3 normal = sphereNormal(hitPoint, sphere);
        
        float3 lightDir = normalize(float3(1, 1, -1));
        float diffuse = max(0.0f, dot(normal, lightDir));
        color = uniforms.lightColor * diffuse;
    }
    
    outTexture.write(float4(color, 1.0), gid);
}
