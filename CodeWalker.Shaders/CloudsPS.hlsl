#include "Clouds.hlsli"


Texture2D<float4> DensitySampler : register(t0);
Texture2D<float4> NormalSampler : register(t1);
Texture2D<float4> DetailDensitySampler : register(t2);
Texture2D<float4> DetailNormalSampler : register(t3);
Texture2D<float4> DetailDensity2Sampler : register(t4);
Texture2D<float4> DetailNormal2Sampler : register(t5);
Texture2D<float4> DepthMapTexSampler : register(t6);
SamplerState TextureSS : register(s0);

cbuffer PSSceneVars : register(b1)
{
    float4 LightDirection;
    uint EnableHDR;
    uint Pad0;
    uint Pad1;
    uint Pad2;
}

struct VS_OUTPUT
{
    float4 Position : SV_POSITION; //         0   xyzw        0      POS   float   xyzw
    float4 o0 : TEXCOORD0; //                 0   xyzw        0     NONE   float       
    float4 o1 : TEXCOORD1; //                 1   xyzw        1     NONE   float   xyzw
    float4 o2 : TEXCOORD2; //                 2   xyzw        2     NONE   float   xyzw
    float4 o3 : TEXCOORD3; //                 3   xyzw        3     NONE   float   xyzw
    float2 o4 : TEXCOORD4; //                 4   xy          4     NONE   float   xy  
    float4 o5 : TEXCOORD5; //                 5   xyzw        5     NONE   float   xyzw
    float4 o6 : TEXCOORD6; //                 6   xyzw        6     NONE   float   xy w
    float4 o7 : TEXCOORD7; //                 7   xyzw        7     NONE   float   xyzw
    float3 o8 : TEXCOORD8; //                 8   xyz         8     NONE   float   xyz 
    float4 o9 : TEXCOORD9; //                 9   xyzw        9     NONE   float   xyzw
};



float4 main(VS_OUTPUT input) : SV_TARGET
{
    float2 texc = input.o4;

    float4 d = DensitySampler.Sample(TextureSS, texc);
    float4 n = NormalSampler.Sample(TextureSS, texc);

    float dv = saturate((1.0 - d.g) * input.o1.w);


    float3 dc = gSunColor;
    return float4(dc, saturate(dv));
}
















/*
//clouds_animsoft.fxc_PSCloudsVertScatterPiercing_AnimSoft

//
// Generated by Microsoft (R) HLSL Shader Compiler 9.29.952.3111
//
//
// Buffer Definitions: 
//
// cbuffer misc_globals
// {
//
//   float4 globalFade;                 // Offset:    0 Size:    16 [unused]
//   float globalHeightScale;           // Offset:   16 Size:     4 [unused]
//   float4 g_Rage_Tessellation_CameraPosition;// Offset:   32 Size:    16 [unused]
//   float4 g_Rage_Tessellation_CameraZAxis;// Offset:   48 Size:    16 [unused]
//   float4 g_Rage_Tessellation_ScreenSpaceErrorParams;// Offset:   64 Size:    16 [unused]
//   float4 g_Rage_Tessellation_LinearScale;// Offset:   80 Size:    16 [unused]
//   float4 g_Rage_Tessellation_Frustum[4];// Offset:   96 Size:    64 [unused]
//   float4 g_Rage_Tessellation_Epsilons;// Offset:  160 Size:    16 [unused]
//   float4 globalScalars;              // Offset:  176 Size:    16 [unused]
//   float4 globalScalars2;             // Offset:  192 Size:    16 [unused]
//   float4 globalScalars3;             // Offset:  208 Size:    16
//   float4 globalScreenSize;           // Offset:  224 Size:    16 [unused]
//   uint4 gTargetAAParams;             // Offset:  240 Size:    16 [unused]
//   float4 colorize;                   // Offset:  256 Size:    16 [unused]
//   float4 gGlobalParticleShadowBias;  // Offset:  272 Size:    16 [unused]
//   float gGlobalParticleDofAlphaScale;// Offset:  288 Size:     4 [unused]
//   float gGlobalFogIntensity;         // Offset:  292 Size:     4 [unused]
//   float4 gPlayerLFootPos;            // Offset:  304 Size:    16 [unused]
//   float4 gPlayerRFootPos;            // Offset:  320 Size:    16 [unused]
//
// }
//
// cbuffer clouds_locals
// {
//
//   float3 gSkyColor;                  // Offset:    0 Size:    12
//   float3 gEastMinusWestColor;        // Offset:   16 Size:    12
//   float3 gWestColor;                 // Offset:   32 Size:    12
//   float3 gSunDirection;              // Offset:   48 Size:    12
//   float3 gSunColor;                  // Offset:   64 Size:    12
//   float3 gCloudColor;                // Offset:   80 Size:    12
//   float3 gAmbientColor;              // Offset:   96 Size:    12
//   float3 gBounceColor;               // Offset:  112 Size:    12
//   float4 gDensityShiftScale;         // Offset:  128 Size:    16
//   float4 gScatterG_GSquared_PhaseMult_Scale;// Offset:  144 Size:    16 [unused]
//   float4 gPiercingLightPower_Strength_NormalStrength_Thickness;// Offset:  160 Size:    16
//   float3 gScaleDiffuseFillAmbient;   // Offset:  176 Size:    12
//   float3 gWrapLighting_MSAARef;      // Offset:  192 Size:    12
//   float4 gNearFarQMult;              // Offset:  208 Size:    16
//   float3 gAnimCombine;               // Offset:  224 Size:    12
//   float3 gAnimSculpt;                // Offset:  240 Size:    12
//   float3 gAnimBlendWeights;          // Offset:  256 Size:    12
//   float4 gUVOffset[2];               // Offset:  272 Size:    32 [unused]
//   row_major float4x4 gCloudViewProj; // Offset:  304 Size:    64 [unused]
//   float4 gCameraPos;                 // Offset:  368 Size:    16 [unused]
//   float2 gUVOffset1;                 // Offset:  384 Size:     8 [unused]
//   float2 gUVOffset2;                 // Offset:  392 Size:     8 [unused]
//   float2 gUVOffset3;                 // Offset:  400 Size:     8 [unused]
//   float2 gRescaleUV1;                // Offset:  408 Size:     8 [unused]
//   float2 gRescaleUV2;                // Offset:  416 Size:     8 [unused]
//   float2 gRescaleUV3;                // Offset:  424 Size:     8 [unused]
//   float gSoftParticleRange;          // Offset:  432 Size:     4
//   float gEnvMapAlphaScale;           // Offset:  436 Size:     4 [unused]
//   float2 cloudLayerAnimScale1;       // Offset:  440 Size:     8 [unused]
//   float2 cloudLayerAnimScale2;       // Offset:  448 Size:     8 [unused]
//   float2 cloudLayerAnimScale3;       // Offset:  456 Size:     8 [unused]
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// DensitySampler                    sampler      NA          NA             s2      1 
// NormalSampler                     sampler      NA          NA             s3      1 
// DetailDensitySampler              sampler      NA          NA             s4      1 
// DetailNormalSampler               sampler      NA          NA             s5      1 
// DetailDensity2Sampler             sampler      NA          NA             s6      1 
// DetailNormal2Sampler              sampler      NA          NA             s7      1 
// DepthMapTexSampler                sampler      NA          NA            s10      1 
// DensitySampler                    texture  float4          2d             t2      1 
// NormalSampler                     texture  float4          2d             t3      1 
// DetailDensitySampler              texture  float4          2d             t4      1 
// DetailNormalSampler               texture  float4          2d             t5      1 
// DetailDensity2Sampler             texture  float4          2d             t6      1 
// DetailNormal2Sampler              texture  float4          2d             t7      1 
// DepthMapTexSampler                texture  float4          2d            t10      1 
// misc_globals                      cbuffer      NA          NA            cb2      1 
// clouds_locals                     cbuffer      NA          NA           cb12      1 
//
//
//
// Input signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// TEXCOORD                 0   xyzw        0     NONE   float       
// TEXCOORD                 1   xyzw        1     NONE   float   xyzw
// TEXCOORD                 2   xyzw        2     NONE   float   xyzw
// TEXCOORD                 3   xyzw        3     NONE   float   xyzw
// TEXCOORD                 4   xy          4     NONE   float   xy  
// TEXCOORD                 5   xyzw        5     NONE   float   xyzw
// TEXCOORD                 6   xyzw        6     NONE   float   xy w
// TEXCOORD                 7   xyzw        7     NONE   float   xyzw
// TEXCOORD                 8   xyz         8     NONE   float   xyz 
// TEXCOORD                 9   xyzw        9     NONE   float   xyzw
// SV_Position              0   xyzw       10      POS   float       
// SV_ClipDistance          0   xyzw       11  CLIPDST   float       
//
//
// Output signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_Target                0   xyzw        0   TARGET   float   xyzw
//
ps_4_0
dcl_constantbuffer CB2[14], immediateIndexed
dcl_constantbuffer CB12[28], immediateIndexed
dcl_sampler s2, mode_default
dcl_sampler s3, mode_default
dcl_sampler s4, mode_default
dcl_sampler s5, mode_default
dcl_sampler s6, mode_default
dcl_sampler s7, mode_default
dcl_sampler s10, mode_default
dcl_resource_texture2d (float,float,float,float) t2
dcl_resource_texture2d (float,float,float,float) t3
dcl_resource_texture2d (float,float,float,float) t4
dcl_resource_texture2d (float,float,float,float) t5
dcl_resource_texture2d (float,float,float,float) t6
dcl_resource_texture2d (float,float,float,float) t7
dcl_resource_texture2d (float,float,float,float) t10
dcl_input_ps linear v1.xyzw
dcl_input_ps linear v2.xyzw
dcl_input_ps linear v3.xyzw
dcl_input_ps linear v4.xy
dcl_input_ps linear v5.xyzw
dcl_input_ps linear v6.xyw
dcl_input_ps linear v7.xyzw
dcl_input_ps linear v8.xyz
dcl_input_ps linear v9.xyzw
dcl_output o0.xyzw
dcl_temps 5
sample r0.xyzw, v5.zwzz, t7.xyzw, s7
mad r0.xy, r0.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000), l(-1.000000, -1.000000, 0.000000, 0.000000)
dp2 r0.w, r0.xyxx, r0.xyxx
add r0.w, -r0.w, l(1.000000)
max r0.w, r0.w, l(0.000000)
sqrt r0.z, r0.w
sample r1.xyzw, v4.xyxx, t3.xyzw, s3
mad r1.xy, r1.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000), l(-1.000000, -1.000000, 0.000000, 0.000000)
dp2 r0.w, r1.xyxx, r1.xyxx
add r0.w, -r0.w, l(1.000000)
max r0.w, r0.w, l(0.000000)
sqrt r1.z, r0.w
sample r2.xyzw, v5.xyxx, t5.xyzw, s5
mad r2.xy, r2.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000), l(-1.000000, -1.000000, 0.000000, 0.000000)
dp2 r0.w, r2.xyxx, r2.xyxx
add r0.w, -r0.w, l(1.000000)
max r0.w, r0.w, l(0.000000)
sqrt r2.z, r0.w
sample r3.xyzw, v4.xyxx, t2.yxzw, s2
sample r4.xyzw, v5.xyxx, t4.xyzw, s4
mov r3.y, r4.y
sample r4.xyzw, v5.zwzz, t6.xyzw, s6
mov r3.z, r4.y
mad r3.xyz, -r3.xyzx, r3.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
mul r3.xyz, r3.xyzx, cb12[16].xyzx
mul r4.xyz, r3.xyzx, cb12[14].xyzx
mul r2.xyz, r2.xyzx, r4.yyyy
mad r1.xyz, r1.xyzx, r4.xxxx, r2.xyzx
mad r0.xyz, r0.xyzx, r4.zzzz, r1.xyzx
dp3 r0.w, r0.xyzx, r0.xyzx
rsq r0.w, r0.w
mul r0.xyz, r0.wwww, r0.xyzx
mul r1.xyz, r0.yyyy, v3.xyzx
mad r0.xyw, r0.xxxx, v2.xyxz, r1.xyxz
mad r0.xyz, r0.zzzz, v1.xyzx, r0.xywx
mad_sat r1.xyz, r0.xzzx, l(0.500000, -0.800000, 0.571429, 0.000000), l(0.500000, 0.200000, 0.428571, 0.000000)
mad r2.xyz, r1.xxxx, cb12[1].xyzx, cb12[2].xyzx
mad r1.xyw, cb12[7].xyxz, r1.yyyy, r2.xyxz
mad r1.xyz, cb12[0].xyzx, r1.zzzz, r1.xywx
dp3 r0.w, r0.xyzx, cb12[3].xyzx
dp3_sat r0.x, r0.xyzx, v7.xyzx
mul r0.x, r0.x, cb12[10].z
mad_sat r0.y, r0.w, cb12[12].x, cb12[12].y
mul r0.yzw, r0.yyyy, cb12[4].xxyz
mul r0.yzw, r0.yyzw, cb12[11].xxxx
mad r0.yzw, cb12[11].yyyy, r1.xxyz, r0.yyzw
mad r0.yzw, cb12[6].xxyz, cb12[11].zzzz, r0.yyzw
mad r1.x, r3.x, cb12[15].x, v3.w
mad r1.x, r3.y, cb12[15].y, r1.x
mad r1.x, r3.z, cb12[15].z, r1.x
max r1.y, r4.z, r4.y
max r1.y, r1.y, r4.x
mul r1.z, r1.y, v2.w
mad r1.y, -v2.w, r1.y, l(1.000000)
mad r1.x, -r1.y, r1.x, r1.z
add r1.x, r1.x, -cb12[8].x
mul_sat r1.x, r1.x, cb12[8].y
add r1.y, -r1.x, l(1.000000)
mul r1.x, r1.x, v1.w
add r1.z, -cb12[10].w, l(1.000000)
mad_sat r1.y, r1.y, cb12[10].w, r1.z
mul r2.xyz, r1.yyyy, v8.xyzx
mad r0.yzw, cb12[5].xxyz, r0.yyzw, r2.xxyz
mul r1.z, r0.x, v7.w
mad r0.x, -r0.x, v7.w, v7.w
mad r0.x, v7.w, r0.x, r1.z
mul r0.x, r1.y, r0.x
mul r1.yzw, r0.xxxx, cb12[4].xxyz
mad r0.xyz, r1.yzwy, cb12[10].yyyy, r0.yzwy
mad r0.xyz, r0.xyzx, v9.wwww, v9.xyzx
mul o0.xyz, r0.xyzx, cb2[13].zzzz
div r0.xy, v6.xyxx, v6.wwww
sample r0.xyzw, r0.xyxx, t10.xyzw, s10
add r0.x, -r0.x, l(1.000000)
add r0.y, r0.x, -cb12[13].z
ge r0.x, r0.x, l(1.000000)
div r0.y, cb12[13].w, r0.y
add r0.y, r0.y, -v6.w
movc r0.x, r0.x, cb12[27].x, r0.y
div_sat r0.x, r0.x, cb12[27].x
mul o0.w, r0.x, r1.x
ret 
// Approximately 82 instruction slots used



*/