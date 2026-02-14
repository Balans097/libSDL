################################################################
##                      libSDL
##     ПОЛНОФУНКЦИОНАЛЬНАЯ ОБЁРТКА БИБЛИОТЕКИ SDL3 
##               SDL3 wrapper for Nim
## 
## 
## Версия:   0.2
## Дата:     2026-02-14
## Автор:    github.com/Balans097
################################################################

# 0.3 —  (2026-02-15)
# 0.2 — обеспечена полная поддержка GPU подсистемы (2026-02-14)
# 0.1 — начальная реализация библиотеки (2026-02-13)








when defined(windows):
  const LibName* = "SDL3.dll"
elif defined(macosx):
  const LibName* = "libSDL3.dylib"
else:
  const LibName* = "libSDL3.so(|.0)"





# =============================================================================
# Basic Types (SDL_stdinc.h)
# =============================================================================

type
  Sint8* = int8
  Uint8* = uint8
  Sint16* = int16
  Uint16* = uint16
  Sint32* = int32
  Uint32* = uint32
  Sint64* = int64
  Uint64* = uint64
  
  SdlBool* = uint8

const
  SDL_TRUE* = 1'u8
  SDL_FALSE* = 0'u8


# =============================================================================
# Main SDL Types
# =============================================================================

type
  # Opaque pointers
  SdlWindow* = ptr object
  SdlRenderer* = ptr object
  SdlTexture* = ptr object
  SdlSurface* = ptr SdlSurfaceObj
  SdlCursor* = ptr object
  SdlJoystick* = ptr object
  SdlGamepad* = ptr object
  SdlHaptic* = ptr object
  SdlSensor* = ptr object
  SdlAudioStream* = ptr object
  SdlCamera* = ptr object
  SdlIOStream* = ptr object
  SdlAsyncIO* = ptr object
  SdlAsyncIOQueue* = ptr object
  SdlMutex* = ptr object
  SdlRWLock* = ptr object
  SdlSemaphore* = ptr object
  SdlCondition* = ptr object
  SdlThread* = ptr object
  SdlTLSID* = uint32
  SdlSpinLock* = int32
  SdlAtomicInt* = int32
  SdlAtomicU32* = uint32

  SdlStorage* = ptr object
  SdlProcess* = ptr object
  SdlEnvironment* = ptr object
  SdlTray* = ptr object
  SdlTrayEntry* = ptr object
  SdlTrayMenu* = ptr object

  # GPU types
  SdlGpuDevice* = ptr object
  SdlGpuBuffer* = ptr object
  SdlGpuTexture* = ptr object
  SdlGpuSampler* = ptr object
  SdlGpuShader* = ptr object
  SdlGpuComputePipeline* = ptr object
  SdlGpuGraphicsPipeline* = ptr object
  SdlGpuCommandBuffer* = ptr object
  SdlGpuRenderPass* = ptr object
  SdlGpuComputePass* = ptr object
  SdlGpuCopyPass* = ptr object
  SdlGpuFence* = ptr object
  SdlGpuTransferBuffer* = ptr object

  # IDs
  SdlWindowID* = uint32
  SdlAudioDeviceID* = uint32
  SdlJoystickID* = uint32
  SdlMouseID* = uint32
  SdlKeyboardID* = uint32
  SdlPenID* = uint32
  SdlTouchID* = uint64
  SdlFingerID* = uint64
  SdlSensorID* = uint32
  SdlCameraID* = uint32
  SdlPropertiesID* = uint32
  SdlTimerID* = uint32
  
  # Function pointers
  SdlThreadFunction* = proc(data: pointer): cint {.cdecl.}
  SdlTimerCallback* = proc(userdata: pointer, timerID: SdlTimerID, interval: uint32): uint64 {.cdecl.}
  SdlNSTimerCallback* = proc(userdata: pointer, timerID: SdlTimerID, interval: uint64): uint64 {.cdecl.}
  
  # Surface structure (defined early for SdlSurface pointer type)
  SdlSurfaceObj* {.bycopy.} = object
    flags*: uint32
    format*: uint32
    w*: cint
    h*: cint
    pitch*: cint
    pixels*: pointer
    refcount*: cint
    reserved*: pointer

  # GUID type
  SdlGUID* {.bycopy.} = object
    data*: array[16, uint8]

  # DateTime structure
  SdlDateTime* {.bycopy.} = object
    year*: cint
    month*: cint
    day*: cint
    hour*: cint
    minute*: cint
    second*: cint
    nanosecond*: cint
    day_of_week*: cint
    utc_offset*: cint



# =============================================================================
# Initialization (SDL_init.h)
# =============================================================================

type
  SdlInitFlags* = distinct uint32

const
  SDL_INIT_AUDIO* = SdlInitFlags(0x00000010'u32)
  SDL_INIT_VIDEO* = SdlInitFlags(0x00000020'u32)
  SDL_INIT_JOYSTICK* = SdlInitFlags(0x00000200'u32)
  SDL_INIT_HAPTIC* = SdlInitFlags(0x00001000'u32)
  SDL_INIT_GAMEPAD* = SdlInitFlags(0x00002000'u32)
  SDL_INIT_EVENTS* = SdlInitFlags(0x00004000'u32)
  SDL_INIT_SENSOR* = SdlInitFlags(0x00008000'u32)
  SDL_INIT_CAMERA* = SdlInitFlags(0x00010000'u32)

proc `or`*(a, b: SdlInitFlags): SdlInitFlags {.borrow.}
proc `and`*(a, b: SdlInitFlags): SdlInitFlags {.borrow.}
proc `==`*(a, b: SdlInitFlags): bool {.borrow.}

{.push importc, dynlib: LibName, cdecl.}

proc SDL_Init*(flags: SdlInitFlags): SdlBool
proc SDL_InitSubSystem*(flags: SdlInitFlags): SdlBool
proc SDL_QuitSubSystem*(flags: SdlInitFlags)
proc SDL_WasInit*(flags: SdlInitFlags): SdlInitFlags
proc SDL_Quit*()
proc SDL_SetAppMetadata*(appname, appversion, appidentifier: cstring): SdlBool
proc SDL_SetAppMetadataProperty*(name, value: cstring): SdlBool
proc SDL_GetAppMetadataProperty*(name: cstring): cstring

{.pop.}

# =============================================================================
# Error Handling (SDL_error.h)
# =============================================================================

{.push importc, dynlib: LibName, cdecl.}

proc SDL_SetError*(fmt: cstring): cint {.varargs.}
proc SDL_OutOfMemory*(): cint
proc SDL_GetError*(): cstring
proc SDL_ClearError*(): SdlBool

{.pop.}


# =============================================================================
# Properties (SDL_properties.h)
# =============================================================================

type
  SdlPropertyType* {.size: sizeof(cint).} = enum
    SDL_PROPERTY_TYPE_INVALID
    SDL_PROPERTY_TYPE_POINTER
    SDL_PROPERTY_TYPE_STRING
    SDL_PROPERTY_TYPE_NUMBER
    SDL_PROPERTY_TYPE_FLOAT
    SDL_PROPERTY_TYPE_BOOLEAN

  SdlCleanupPropertyCallback* = proc(userdata, value: pointer) {.cdecl.}
  SdlEnumeratePropertiesCallback* = proc(userdata: pointer, props: SdlPropertiesID, name: cstring) {.cdecl.}

const
  SDL_PROP_INVALID* = SdlPropertiesID(0)

{.push importc, dynlib: LibName, cdecl.}

proc SDL_GetGlobalProperties*(): SdlPropertiesID
proc SDL_CreateProperties*(): SdlPropertiesID
proc SDL_CopyProperties*(src, dst: SdlPropertiesID): SdlBool
proc SDL_LockProperties*(props: SdlPropertiesID): SdlBool
proc SDL_UnlockProperties*(props: SdlPropertiesID)
proc SDL_SetPointerPropertyWithCleanup*(props: SdlPropertiesID, name: cstring, value: pointer, 
                                         cleanup: SdlCleanupPropertyCallback, userdata: pointer): SdlBool
proc SDL_SetPointerProperty*(props: SdlPropertiesID, name: cstring, value: pointer): SdlBool
proc SDL_SetStringProperty*(props: SdlPropertiesID, name: cstring, value: cstring): SdlBool
proc SDL_SetNumberProperty*(props: SdlPropertiesID, name: cstring, value: Sint64): SdlBool
proc SDL_SetFloatProperty*(props: SdlPropertiesID, name: cstring, value: cfloat): SdlBool
proc SDL_SetBooleanProperty*(props: SdlPropertiesID, name: cstring, value: SdlBool): SdlBool
proc SDL_HasProperty*(props: SdlPropertiesID, name: cstring): SdlBool
proc SDL_GetPropertyType*(props: SdlPropertiesID, name: cstring): SdlPropertyType
proc SDL_GetPointerProperty*(props: SdlPropertiesID, name: cstring, default_value: pointer): pointer
proc SDL_GetStringProperty*(props: SdlPropertiesID, name: cstring, default_value: cstring): cstring
proc SDL_GetNumberProperty*(props: SdlPropertiesID, name: cstring, default_value: Sint64): Sint64
proc SDL_GetFloatProperty*(props: SdlPropertiesID, name: cstring, default_value: cfloat): cfloat
proc SDL_GetBooleanProperty*(props: SdlPropertiesID, name: cstring, default_value: SdlBool): SdlBool
proc SDL_ClearProperty*(props: SdlPropertiesID, name: cstring): SdlBool
proc SDL_EnumerateProperties*(props: SdlPropertiesID, callback: SdlEnumeratePropertiesCallback, userdata: pointer): SdlBool
proc SDL_DestroyProperties*(props: SdlPropertiesID)

{.pop.}


# =============================================================================
# Rectangles and Points (SDL_rect.h)
# =============================================================================

type
  SdlPoint* {.bycopy.} = object
    x*: cint
    y*: cint

  SdlFPoint* {.bycopy.} = object
    x*: cfloat
    y*: cfloat

  SdlRect* {.bycopy.} = object
    x*: cint
    y*: cint
    w*: cint
    h*: cint

  SdlFRect* {.bycopy.} = object
    x*: cfloat
    y*: cfloat
    w*: cfloat
    h*: cfloat

{.push importc, dynlib: LibName, cdecl.}

proc SDL_HasRectIntersection*(a, b: ptr SdlRect): SdlBool
proc SDL_GetRectIntersection*(a, b, result: ptr SdlRect): SdlBool
proc SDL_GetRectUnion*(a, b, result: ptr SdlRect): SdlBool
proc SDL_GetRectEnclosingPoints*(points: ptr SdlPoint, count: cint, clip, result: ptr SdlRect): SdlBool
proc SDL_GetRectAndLineIntersection*(rect: ptr SdlRect, x1, y1, x2, y2: ptr cint): SdlBool
proc SDL_HasRectIntersectionFloat*(a, b: ptr SdlFRect): SdlBool
proc SDL_GetRectIntersectionFloat*(a, b, result: ptr SdlFRect): SdlBool
proc SDL_GetRectUnionFloat*(a, b, result: ptr SdlFRect): SdlBool
proc SDL_GetRectEnclosingPointsFloat*(points: ptr SdlFPoint, count: cint, clip, result: ptr SdlFRect): SdlBool
proc SDL_GetRectAndLineIntersectionFloat*(rect: ptr SdlFRect, x1, y1, x2, y2: ptr cfloat): SdlBool

{.pop.}


# =============================================================================
# Pixels and Formats (SDL_pixels.h)
# =============================================================================

type
  SdlPixelFormat* = distinct uint32
  SdlColorspace* = distinct uint32
  
  SdlPixelType* {.size: sizeof(cint).} = enum
    SDL_PIXELTYPE_UNKNOWN
    SDL_PIXELTYPE_INDEX1
    SDL_PIXELTYPE_INDEX4
    SDL_PIXELTYPE_INDEX8
    SDL_PIXELTYPE_PACKED8
    SDL_PIXELTYPE_PACKED16
    SDL_PIXELTYPE_PACKED32
    SDL_PIXELTYPE_ARRAYU8
    SDL_PIXELTYPE_ARRAYU16
    SDL_PIXELTYPE_ARRAYU32
    SDL_PIXELTYPE_ARRAYF16
    SDL_PIXELTYPE_ARRAYF32
    SDL_PIXELTYPE_INDEX2
  
  SdlBitmapOrder* {.size: sizeof(cint).} = enum
    SDL_BITMAPORDER_NONE
    SDL_BITMAPORDER_4321
    SDL_BITMAPORDER_1234
  
  SdlPackedOrder* {.size: sizeof(cint).} = enum
    SDL_PACKEDORDER_NONE
    SDL_PACKEDORDER_XRGB
    SDL_PACKEDORDER_RGBX
    SDL_PACKEDORDER_ARGB
    SDL_PACKEDORDER_RGBA
    SDL_PACKEDORDER_XBGR
    SDL_PACKEDORDER_BGRX
    SDL_PACKEDORDER_ABGR
    SDL_PACKEDORDER_BGRA
  
  SdlArrayOrder* {.size: sizeof(cint).} = enum
    SDL_ARRAYORDER_NONE
    SDL_ARRAYORDER_RGB
    SDL_ARRAYORDER_RGBA
    SDL_ARRAYORDER_ARGB
    SDL_ARRAYORDER_BGR
    SDL_ARRAYORDER_BGRA
    SDL_ARRAYORDER_ABGR
  
  SdlPackedLayout* {.size: sizeof(cint).} = enum
    SDL_PACKEDLAYOUT_NONE
    SDL_PACKEDLAYOUT_332
    SDL_PACKEDLAYOUT_4444
    SDL_PACKEDLAYOUT_1555
    SDL_PACKEDLAYOUT_5551
    SDL_PACKEDLAYOUT_565
    SDL_PACKEDLAYOUT_8888
    SDL_PACKEDLAYOUT_2101010
    SDL_PACKEDLAYOUT_1010102
  
  SdlColor* {.bycopy.} = object
    r*: uint8
    g*: uint8
    b*: uint8
    a*: uint8
  
  SdlFColor* {.bycopy.} = object
    r*: cfloat
    g*: cfloat
    b*: cfloat
    a*: cfloat
  
  SdlPalette* {.bycopy.} = object
    ncolors*: cint
    colors*: ptr SdlColor
    version*: uint32
    refcount*: cint
  
  SdlPixelFormatDetails* {.bycopy.} = object
    format*: SdlPixelFormat
    bits_per_pixel*: uint8
    bytes_per_pixel*: uint8
    padding*: array[2, uint8]
    Rmask*: uint32
    Gmask*: uint32
    Bmask*: uint32
    Amask*: uint32
    Rbits*: uint8
    Gbits*: uint8
    Bbits*: uint8
    Abits*: uint8
    Rshift*: uint8
    Gshift*: uint8
    Bshift*: uint8
    Ashift*: uint8

const
  SDL_PIXELFORMAT_UNKNOWN* = SdlPixelFormat(0)
  SDL_PIXELFORMAT_INDEX1LSB* = SdlPixelFormat(0x11100100'u32)
  SDL_PIXELFORMAT_INDEX1MSB* = SdlPixelFormat(0x11200100'u32)
  SDL_PIXELFORMAT_INDEX2LSB* = SdlPixelFormat(0x1c100200'u32)
  SDL_PIXELFORMAT_INDEX2MSB* = SdlPixelFormat(0x1c200200'u32)
  SDL_PIXELFORMAT_INDEX4LSB* = SdlPixelFormat(0x12100400'u32)
  SDL_PIXELFORMAT_INDEX4MSB* = SdlPixelFormat(0x12200400'u32)
  SDL_PIXELFORMAT_INDEX8* = SdlPixelFormat(0x13000801'u32)
  SDL_PIXELFORMAT_RGB332* = SdlPixelFormat(0x14110801'u32)
  SDL_PIXELFORMAT_XRGB4444* = SdlPixelFormat(0x15120c02'u32)
  SDL_PIXELFORMAT_XBGR4444* = SdlPixelFormat(0x15520c02'u32)
  SDL_PIXELFORMAT_XRGB1555* = SdlPixelFormat(0x15130f02'u32)
  SDL_PIXELFORMAT_XBGR1555* = SdlPixelFormat(0x15530f02'u32)
  SDL_PIXELFORMAT_ARGB4444* = SdlPixelFormat(0x15321002'u32)
  SDL_PIXELFORMAT_RGBA4444* = SdlPixelFormat(0x15421002'u32)
  SDL_PIXELFORMAT_ABGR4444* = SdlPixelFormat(0x15721002'u32)
  SDL_PIXELFORMAT_BGRA4444* = SdlPixelFormat(0x15821002'u32)
  SDL_PIXELFORMAT_ARGB1555* = SdlPixelFormat(0x15331002'u32)
  SDL_PIXELFORMAT_RGBA5551* = SdlPixelFormat(0x15441002'u32)
  SDL_PIXELFORMAT_ABGR1555* = SdlPixelFormat(0x15731002'u32)
  SDL_PIXELFORMAT_BGRA5551* = SdlPixelFormat(0x15841002'u32)
  SDL_PIXELFORMAT_RGB565* = SdlPixelFormat(0x15151002'u32)
  SDL_PIXELFORMAT_BGR565* = SdlPixelFormat(0x15551002'u32)
  SDL_PIXELFORMAT_RGB24* = SdlPixelFormat(0x17101803'u32)
  SDL_PIXELFORMAT_BGR24* = SdlPixelFormat(0x17401803'u32)
  SDL_PIXELFORMAT_XRGB8888* = SdlPixelFormat(0x16161804'u32)
  SDL_PIXELFORMAT_RGBX8888* = SdlPixelFormat(0x16261804'u32)
  SDL_PIXELFORMAT_XBGR8888* = SdlPixelFormat(0x16561804'u32)
  SDL_PIXELFORMAT_BGRX8888* = SdlPixelFormat(0x16661804'u32)
  SDL_PIXELFORMAT_ARGB8888* = SdlPixelFormat(0x16362004'u32)
  SDL_PIXELFORMAT_RGBA8888* = SdlPixelFormat(0x16462004'u32)
  SDL_PIXELFORMAT_ABGR8888* = SdlPixelFormat(0x16762004'u32)
  SDL_PIXELFORMAT_BGRA8888* = SdlPixelFormat(0x16862004'u32)
  SDL_PIXELFORMAT_XRGB2101010* = SdlPixelFormat(0x16172004'u32)
  SDL_PIXELFORMAT_XBGR2101010* = SdlPixelFormat(0x16572004'u32)
  SDL_PIXELFORMAT_ARGB2101010* = SdlPixelFormat(0x16372004'u32)
  SDL_PIXELFORMAT_ABGR2101010* = SdlPixelFormat(0x16772004'u32)

{.push importc, dynlib: LibName, cdecl.}

proc SDL_GetPixelFormatName*(format: SdlPixelFormat): cstring
proc SDL_GetMasksForPixelFormat*(format: SdlPixelFormat, bpp: ptr cint, Rmask, Gmask, Bmask, Amask: ptr uint32): SdlBool
proc SDL_GetPixelFormatForMasks*(bpp: cint, Rmask, Gmask, Bmask, Amask: uint32): SdlPixelFormat
proc SDL_GetPixelFormatDetails*(format: SdlPixelFormat): ptr SdlPixelFormatDetails
proc SDL_CreatePalette*(ncolors: cint): ptr SdlPalette
proc SDL_SetPaletteColors*(palette: ptr SdlPalette, colors: ptr SdlColor, firstcolor, ncolors: cint): SdlBool
proc SDL_DestroyPalette*(palette: ptr SdlPalette)
proc SDL_MapRGB*(format: ptr SdlPixelFormatDetails, palette: ptr SdlPalette, r, g, b: uint8): uint32
proc SDL_MapRGBA*(format: ptr SdlPixelFormatDetails, palette: ptr SdlPalette, r, g, b, a: uint8): uint32
proc SDL_GetRGB*(pixel: uint32, format: ptr SdlPixelFormatDetails, palette: ptr SdlPalette, r, g, b: ptr uint8)
proc SDL_GetRGBA*(pixel: uint32, format: ptr SdlPixelFormatDetails, palette: ptr SdlPalette, r, g, b, a: ptr uint8)

{.pop.}


# =============================================================================
# Blend Modes (SDL_blendmode.h)
# =============================================================================

type
  SdlBlendMode* = distinct uint32
  
  SdlBlendOperation* {.size: sizeof(cint).} = enum
    SDL_BLENDOPERATION_ADD = 0x1
    SDL_BLENDOPERATION_SUBTRACT = 0x2
    SDL_BLENDOPERATION_REV_SUBTRACT = 0x3
    SDL_BLENDOPERATION_MINIMUM = 0x4
    SDL_BLENDOPERATION_MAXIMUM = 0x5
  
  SdlBlendFactor* {.size: sizeof(cint).} = enum
    SDL_BLENDFACTOR_ZERO = 0x1
    SDL_BLENDFACTOR_ONE = 0x2
    SDL_BLENDFACTOR_SRC_COLOR = 0x3
    SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR = 0x4
    SDL_BLENDFACTOR_SRC_ALPHA = 0x5
    SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA = 0x6
    SDL_BLENDFACTOR_DST_COLOR = 0x7
    SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR = 0x8
    SDL_BLENDFACTOR_DST_ALPHA = 0x9
    SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA = 0xA

const
  SDL_BLENDMODE_NONE* = SdlBlendMode(0x00000000'u32)
  SDL_BLENDMODE_BLEND* = SdlBlendMode(0x00000001'u32)
  SDL_BLENDMODE_BLEND_PREMULTIPLIED* = SdlBlendMode(0x00000010'u32)
  SDL_BLENDMODE_ADD* = SdlBlendMode(0x00000002'u32)
  SDL_BLENDMODE_ADD_PREMULTIPLIED* = SdlBlendMode(0x00000020'u32)
  SDL_BLENDMODE_MOD* = SdlBlendMode(0x00000004'u32)
  SDL_BLENDMODE_MUL* = SdlBlendMode(0x00000008'u32)
  SDL_BLENDMODE_INVALID* = SdlBlendMode(0x7FFFFFFF'u32)

{.push importc, dynlib: LibName, cdecl.}

proc SDL_ComposeCustomBlendMode*(srcColorFactor, dstColorFactor: SdlBlendFactor,
                                  colorOperation: SdlBlendOperation,
                                  srcAlphaFactor, dstAlphaFactor: SdlBlendFactor,
                                  alphaOperation: SdlBlendOperation): SdlBlendMode

{.pop.}


# =============================================================================
# Surface (SDL_surface.h)
# =============================================================================

type
  SdlSurfaceFlags* = distinct uint32
  
  SdlScaleMode* {.size: sizeof(cint).} = enum
    SDL_SCALEMODE_NEAREST
    SDL_SCALEMODE_LINEAR
  
  SdlFlipMode* {.size: sizeof(cint).} = enum
    SDL_FLIP_NONE = 0x00000000
    SDL_FLIP_HORIZONTAL = 0x00000001
    SDL_FLIP_VERTICAL = 0x00000002

const
  SDL_SURFACE_PREALLOCATED* = SdlSurfaceFlags(0x00000001'u32)
  SDL_SURFACE_LOCK_NEEDED* = SdlSurfaceFlags(0x00000002'u32)
  SDL_SURFACE_LOCKED* = SdlSurfaceFlags(0x00000004'u32)
  SDL_SURFACE_SIMD_ALIGNED* = SdlSurfaceFlags(0x00000008'u32)

{.push importc, dynlib: LibName, cdecl.}

proc SDL_CreateSurface*(width, height: cint, format: SdlPixelFormat): SdlSurface
proc SDL_CreateSurfaceFrom*(width, height: cint, format: SdlPixelFormat, pixels: pointer, pitch: cint): SdlSurface
proc SDL_DestroySurface*(surface: SdlSurface)
proc SDL_GetSurfaceProperties*(surface: SdlSurface): SdlPropertiesID
proc SDL_SetSurfaceColorspace*(surface: SdlSurface, colorspace: SdlColorspace): SdlBool
proc SDL_GetSurfaceColorspace*(surface: SdlSurface, colorspace: ptr SdlColorspace): SdlBool
proc SDL_CreateSurfacePalette*(surface: SdlSurface): ptr SdlPalette
proc SDL_SetSurfacePalette*(surface: SdlSurface, palette: ptr SdlPalette): SdlBool
proc SDL_GetSurfacePalette*(surface: SdlSurface): ptr SdlPalette
proc SDL_AddSurfaceAlternateImage*(surface, image: SdlSurface): SdlBool
proc SDL_SurfaceHasAlternateImages*(surface: SdlSurface): SdlBool
proc SDL_GetSurfaceImages*(surface: SdlSurface, count: ptr cint): ptr SdlSurface
proc SDL_RemoveSurfaceAlternateImages*(surface: SdlSurface)
proc SDL_LockSurface*(surface: SdlSurface): SdlBool
proc SDL_UnlockSurface*(surface: SdlSurface)
proc SDL_LoadBMP_IO*(src: SdlIOStream, closeio: SdlBool): SdlSurface
proc SDL_LoadBMP*(file: cstring): SdlSurface
proc SDL_SaveBMP_IO*(surface: SdlSurface, dst: SdlIOStream, closeio: SdlBool): SdlBool
proc SDL_SaveBMP*(surface: SdlSurface, file: cstring): SdlBool
proc SDL_SetSurfaceRLE*(surface: SdlSurface, enabled: SdlBool): SdlBool
proc SDL_SurfaceHasRLE*(surface: SdlSurface): SdlBool
proc SDL_SetSurfaceColorKey*(surface: SdlSurface, enabled: SdlBool, key: uint32): SdlBool
proc SDL_SurfaceHasColorKey*(surface: SdlSurface): SdlBool
proc SDL_GetSurfaceColorKey*(surface: SdlSurface, key: ptr uint32): SdlBool
proc SDL_SetSurfaceColorMod*(surface: SdlSurface, r, g, b: uint8): SdlBool
proc SDL_GetSurfaceColorMod*(surface: SdlSurface, r, g, b: ptr uint8): SdlBool
proc SDL_SetSurfaceAlphaMod*(surface: SdlSurface, alpha: uint8): SdlBool
proc SDL_GetSurfaceAlphaMod*(surface: SdlSurface, alpha: ptr uint8): SdlBool
proc SDL_SetSurfaceBlendMode*(surface: SdlSurface, blendMode: SdlBlendMode): SdlBool
proc SDL_GetSurfaceBlendMode*(surface: SdlSurface, blendMode: ptr SdlBlendMode): SdlBool
proc SDL_SetSurfaceClipRect*(surface: SdlSurface, rect: ptr SdlRect): SdlBool
proc SDL_GetSurfaceClipRect*(surface: SdlSurface, rect: ptr SdlRect): SdlBool
proc SDL_FlipSurface*(surface: SdlSurface, flip: SdlFlipMode): SdlBool
proc SDL_DuplicateSurface*(surface: SdlSurface): SdlSurface
proc SDL_ScaleSurface*(surface: SdlSurface, width, height: cint, scaleMode: SdlScaleMode): SdlSurface
proc SDL_ConvertSurface*(surface: SdlSurface, format: SdlPixelFormat): SdlSurface
proc SDL_ConvertSurfaceAndColorspace*(surface: SdlSurface, format: SdlPixelFormat, palette: ptr SdlPalette, colorspace: SdlColorspace, props: SdlPropertiesID): SdlSurface
proc SDL_ConvertPixels*(width, height: cint, src_format: SdlPixelFormat, src: pointer, src_pitch: cint,
                        dst_format: SdlPixelFormat, dst: pointer, dst_pitch: cint): SdlBool
proc SDL_ConvertPixelsAndColorspace*(width, height: cint, src_format: SdlPixelFormat, src_colorspace: SdlColorspace,
                                      src_properties: SdlPropertiesID, src: pointer, src_pitch: cint,
                                      dst_format: SdlPixelFormat, dst_colorspace: SdlColorspace,
                                      dst_properties: SdlPropertiesID, dst: pointer, dst_pitch: cint): SdlBool
proc SDL_PremultiplyAlpha*(width, height: cint, src_format: SdlPixelFormat, src: pointer, src_pitch: cint,
                           dst_format: SdlPixelFormat, dst: pointer, dst_pitch: cint, linear: SdlBool): SdlBool
proc SDL_PremultiplySurfaceAlpha*(surface: SdlSurface, linear: SdlBool): SdlBool
proc SDL_ClearSurface*(surface: SdlSurface, r, g, b, a: cfloat): SdlBool
proc SDL_FillSurfaceRect*(dst: SdlSurface, rect: ptr SdlRect, color: uint32): SdlBool
proc SDL_FillSurfaceRects*(dst: SdlSurface, rects: ptr SdlRect, count: cint, color: uint32): SdlBool
proc SDL_BlitSurface*(src: SdlSurface, srcrect: ptr SdlRect, dst: SdlSurface, dstrect: ptr SdlRect): SdlBool
proc SDL_BlitSurfaceUnchecked*(src: SdlSurface, srcrect: ptr SdlRect, dst: SdlSurface, dstrect: ptr SdlRect): SdlBool
proc SDL_BlitSurfaceScaled*(src: SdlSurface, srcrect: ptr SdlRect, dst: SdlSurface, dstrect: ptr SdlRect, scaleMode: SdlScaleMode): SdlBool
proc SDL_BlitSurfaceUncheckedScaled*(src: SdlSurface, srcrect: ptr SdlRect, dst: SdlSurface, dstrect: ptr SdlRect, scaleMode: SdlScaleMode): SdlBool
proc SDL_BlitSurfaceTiled*(src: SdlSurface, srcrect: ptr SdlRect, dst: SdlSurface, dstrect: ptr SdlRect): SdlBool
proc SDL_BlitSurface9Grid*(src: SdlSurface, srcrect: ptr SdlRect, left_width, right_width, top_height, bottom_height: cint,
                           scale: cfloat, scaleMode: SdlScaleMode, dst: SdlSurface, dstrect: ptr SdlRect): SdlBool
proc SDL_MapSurfaceRGB*(surface: SdlSurface, r, g, b: uint8): uint32
proc SDL_MapSurfaceRGBA*(surface: SdlSurface, r, g, b, a: uint8): uint32
proc SDL_ReadSurfacePixel*(surface: SdlSurface, x, y: cint, r, g, b, a: ptr uint8): SdlBool
proc SDL_ReadSurfacePixelFloat*(surface: SdlSurface, x, y: cint, r, g, b, a: ptr cfloat): SdlBool
proc SDL_WriteSurfacePixel*(surface: SdlSurface, x, y: cint, r, g, b, a: uint8): SdlBool
proc SDL_WriteSurfacePixelFloat*(surface: SdlSurface, x, y: cint, r, g, b, a: cfloat): SdlBool

{.pop.}


# =============================================================================
# Video - Display and Window (SDL_video.h)
# =============================================================================

type
  SdlDisplayID* = uint32
  
  SdlSystemTheme* {.size: sizeof(cint).} = enum
    SDL_SYSTEM_THEME_UNKNOWN
    SDL_SYSTEM_THEME_LIGHT
    SDL_SYSTEM_THEME_DARK
  
  SdlDisplayOrientation* {.size: sizeof(cint).} = enum
    SDL_ORIENTATION_UNKNOWN
    SDL_ORIENTATION_LANDSCAPE
    SDL_ORIENTATION_LANDSCAPE_FLIPPED
    SDL_ORIENTATION_PORTRAIT
    SDL_ORIENTATION_PORTRAIT_FLIPPED
  
  SdlWindowFlags* = distinct uint64

const
  SDL_WINDOW_NONE* = SdlWindowFlags(0)

type
  SdlDisplayMode* {.bycopy.} = object
    displayID*: SdlDisplayID
    format*: SdlPixelFormat
    w*: cint
    h*: cint
    pixel_density*: cfloat
    refresh_rate*: cfloat
    refresh_rate_numerator*: cint
    refresh_rate_denominator*: cint
    internal*: pointer
  
  SdlGLContext* = pointer
  SdlGLContextFlag* = distinct cint
  SdlGLProfile* = distinct cint
  SdlGLContextReleaseFlag* = distinct cint
  SdlGLContextResetNotification* = distinct cint
  
  SdlGLattr* {.size: sizeof(cint).} = enum
    SDL_GL_RED_SIZE
    SDL_GL_GREEN_SIZE
    SDL_GL_BLUE_SIZE
    SDL_GL_ALPHA_SIZE
    SDL_GL_BUFFER_SIZE
    SDL_GL_DOUBLEBUFFER
    SDL_GL_DEPTH_SIZE
    SDL_GL_STENCIL_SIZE
    SDL_GL_ACCUM_RED_SIZE
    SDL_GL_ACCUM_GREEN_SIZE
    SDL_GL_ACCUM_BLUE_SIZE
    SDL_GL_ACCUM_ALPHA_SIZE
    SDL_GL_STEREO
    SDL_GL_MULTISAMPLEBUFFERS
    SDL_GL_MULTISAMPLESAMPLES
    SDL_GL_ACCELERATED_VISUAL
    SDL_GL_RETAINED_BACKING
    SDL_GL_CONTEXT_MAJOR_VERSION
    SDL_GL_CONTEXT_MINOR_VERSION
    SDL_GL_CONTEXT_FLAGS
    SDL_GL_CONTEXT_PROFILE_MASK
    SDL_GL_SHARE_WITH_CURRENT_CONTEXT
    SDL_GL_FRAMEBUFFER_SRGB_CAPABLE
    SDL_GL_CONTEXT_RELEASE_BEHAVIOR
    SDL_GL_CONTEXT_NO_ERROR
    SDL_GL_FLOATBUFFERS
    SDL_GL_EGL_PLATFORM

const
  SDL_WINDOW_FULLSCREEN* = SdlWindowFlags(0x0000000000000001'u64)
  SDL_WINDOW_OPENGL* = SdlWindowFlags(0x0000000000000002'u64)
  SDL_WINDOW_OCCLUDED* = SdlWindowFlags(0x0000000000000004'u64)
  SDL_WINDOW_HIDDEN* = SdlWindowFlags(0x0000000000000008'u64)
  SDL_WINDOW_BORDERLESS* = SdlWindowFlags(0x0000000000000010'u64)
  SDL_WINDOW_RESIZABLE* = SdlWindowFlags(0x0000000000000020'u64)
  SDL_WINDOW_MINIMIZED* = SdlWindowFlags(0x0000000000000040'u64)
  SDL_WINDOW_MAXIMIZED* = SdlWindowFlags(0x0000000000000080'u64)
  SDL_WINDOW_MOUSE_GRABBED* = SdlWindowFlags(0x0000000000000100'u64)
  SDL_WINDOW_INPUT_FOCUS* = SdlWindowFlags(0x0000000000000200'u64)
  SDL_WINDOW_MOUSE_FOCUS* = SdlWindowFlags(0x0000000000000400'u64)
  SDL_WINDOW_EXTERNAL* = SdlWindowFlags(0x0000000000000800'u64)
  SDL_WINDOW_MODAL* = SdlWindowFlags(0x0000000000001000'u64)
  SDL_WINDOW_HIGH_PIXEL_DENSITY* = SdlWindowFlags(0x0000000000002000'u64)
  SDL_WINDOW_MOUSE_CAPTURE* = SdlWindowFlags(0x0000000000004000'u64)
  SDL_WINDOW_MOUSE_RELATIVE_MODE* = SdlWindowFlags(0x0000000000008000'u64)
  SDL_WINDOW_ALWAYS_ON_TOP* = SdlWindowFlags(0x0000000000010000'u64)
  SDL_WINDOW_UTILITY* = SdlWindowFlags(0x0000000000020000'u64)
  SDL_WINDOW_TOOLTIP* = SdlWindowFlags(0x0000000000040000'u64)
  SDL_WINDOW_POPUP_MENU* = SdlWindowFlags(0x0000000000080000'u64)
  SDL_WINDOW_KEYBOARD_GRABBED* = SdlWindowFlags(0x0000000000100000'u64)
  SDL_WINDOW_VULKAN* = SdlWindowFlags(0x0000000010000000'u64)
  SDL_WINDOW_METAL* = SdlWindowFlags(0x0000000020000000'u64)
  SDL_WINDOW_TRANSPARENT* = SdlWindowFlags(0x0000000040000000'u64)
  SDL_WINDOW_NOT_FOCUSABLE* = SdlWindowFlags(0x0000000080000000'u64)

proc `or`*(a, b: SdlWindowFlags): SdlWindowFlags {.borrow.}
proc `and`*(a, b: SdlWindowFlags): SdlWindowFlags {.borrow.}

converter toSdlWindowFlags*(x: int): SdlWindowFlags = SdlWindowFlags(x)

const
  SDL_WINDOWPOS_UNDEFINED_MASK* = 0x1FFF0000'u32
  SDL_WINDOWPOS_CENTERED_MASK* = 0x2FFF0000'u32

template SDL_WINDOWPOS_UNDEFINED*(): cint = SDL_WINDOWPOS_UNDEFINED_MASK.cint
template SDL_WINDOWPOS_CENTERED*(): cint = SDL_WINDOWPOS_CENTERED_MASK.cint

{.push importc, dynlib: LibName, cdecl.}

# Display functions
proc SDL_GetNumVideoDrivers*(): cint
proc SDL_GetVideoDriver*(index: cint): cstring
proc SDL_GetCurrentVideoDriver*(): cstring
proc SDL_GetSystemTheme*(): SdlSystemTheme
proc SDL_GetDisplays*(count: ptr cint): ptr SdlDisplayID
proc SDL_GetPrimaryDisplay*(): SdlDisplayID
proc SDL_GetDisplayProperties*(displayID: SdlDisplayID): SdlPropertiesID
proc SDL_GetDisplayName*(displayID: SdlDisplayID): cstring
proc SDL_GetDisplayBounds*(displayID: SdlDisplayID, rect: ptr SdlRect): SdlBool
proc SDL_GetDisplayUsableBounds*(displayID: SdlDisplayID, rect: ptr SdlRect): SdlBool
proc SDL_GetNaturalDisplayOrientation*(displayID: SdlDisplayID): SdlDisplayOrientation
proc SDL_GetCurrentDisplayOrientation*(displayID: SdlDisplayID): SdlDisplayOrientation
proc SDL_GetDisplayContentScale*(displayID: SdlDisplayID): cfloat
proc SDL_GetFullscreenDisplayModes*(displayID: SdlDisplayID, count: ptr cint): ptr ptr SdlDisplayMode
proc SDL_GetClosestFullscreenDisplayMode*(displayID: SdlDisplayID, w, h: cint, refresh_rate: cfloat, include_high_density_modes: SdlBool): ptr SdlDisplayMode
proc SDL_GetDesktopDisplayMode*(displayID: SdlDisplayID): ptr SdlDisplayMode
proc SDL_GetCurrentDisplayMode*(displayID: SdlDisplayID): ptr SdlDisplayMode

# Window functions
proc SDL_CreateWindow*(title: cstring, w, h: cint, flags: SdlWindowFlags): SdlWindow
proc SDL_CreateWindowWithProperties*(props: SdlPropertiesID): SdlWindow
proc SDL_GetWindowID*(window: SdlWindow): SdlWindowID
proc SDL_GetWindowFromID*(id: SdlWindowID): SdlWindow
proc SDL_GetWindowParent*(window: SdlWindow): SdlWindow
proc SDL_GetWindowProperties*(window: SdlWindow): SdlPropertiesID
proc SDL_GetWindowFlags*(window: SdlWindow): SdlWindowFlags
proc SDL_SetWindowTitle*(window: SdlWindow, title: cstring): SdlBool
proc SDL_GetWindowTitle*(window: SdlWindow): cstring
proc SDL_SetWindowIcon*(window: SdlWindow, icon: SdlSurface): SdlBool
proc SDL_SetWindowPosition*(window: SdlWindow, x, y: cint): SdlBool
proc SDL_GetWindowPosition*(window: SdlWindow, x, y: ptr cint): SdlBool
proc SDL_SetWindowSize*(window: SdlWindow, w, h: cint): SdlBool
proc SDL_GetWindowSize*(window: SdlWindow, w, h: ptr cint): SdlBool
proc SDL_GetWindowSafeArea*(window: SdlWindow, rect: ptr SdlRect): SdlBool
proc SDL_SetWindowAspectRatio*(window: SdlWindow, min_aspect, max_aspect: cfloat): SdlBool
proc SDL_GetWindowAspectRatio*(window: SdlWindow, min_aspect, max_aspect: ptr cfloat): SdlBool
proc SDL_GetWindowBordersSize*(window: SdlWindow, top, left, bottom, right: ptr cint): SdlBool
proc SDL_GetWindowSizeInPixels*(window: SdlWindow, w, h: ptr cint): SdlBool
proc SDL_SetWindowMinimumSize*(window: SdlWindow, min_w, min_h: cint): SdlBool
proc SDL_GetWindowMinimumSize*(window: SdlWindow, w, h: ptr cint): SdlBool
proc SDL_SetWindowMaximumSize*(window: SdlWindow, max_w, max_h: cint): SdlBool
proc SDL_GetWindowMaximumSize*(window: SdlWindow, w, h: ptr cint): SdlBool
proc SDL_SetWindowBordered*(window: SdlWindow, bordered: SdlBool): SdlBool
proc SDL_SetWindowResizable*(window: SdlWindow, resizable: SdlBool): SdlBool
proc SDL_SetWindowAlwaysOnTop*(window: SdlWindow, on_top: SdlBool): SdlBool
proc SDL_ShowWindow*(window: SdlWindow): SdlBool
proc SDL_HideWindow*(window: SdlWindow): SdlBool
proc SDL_RaiseWindow*(window: SdlWindow): SdlBool
proc SDL_MaximizeWindow*(window: SdlWindow): SdlBool
proc SDL_MinimizeWindow*(window: SdlWindow): SdlBool
proc SDL_RestoreWindow*(window: SdlWindow): SdlBool
proc SDL_SetWindowFullscreen*(window: SdlWindow, fullscreen: SdlBool): SdlBool
proc SDL_SyncWindow*(window: SdlWindow): SdlBool
proc SDL_WindowHasSurface*(window: SdlWindow): SdlBool
proc SDL_GetWindowSurface*(window: SdlWindow): SdlSurface
proc SDL_SetWindowSurfaceVSync*(window: SdlWindow, vsync: cint): SdlBool
proc SDL_GetWindowSurfaceVSync*(window: SdlWindow, vsync: ptr cint): SdlBool
proc SDL_UpdateWindowSurface*(window: SdlWindow): SdlBool
proc SDL_UpdateWindowSurfaceRects*(window: SdlWindow, rects: ptr SdlRect, numrects: cint): SdlBool
proc SDL_DestroyWindowSurface*(window: SdlWindow): SdlBool
proc SDL_SetWindowKeyboardGrab*(window: SdlWindow, grabbed: SdlBool): SdlBool
proc SDL_SetWindowMouseGrab*(window: SdlWindow, grabbed: SdlBool): SdlBool
proc SDL_GetWindowKeyboardGrab*(window: SdlWindow): SdlBool
proc SDL_GetWindowMouseGrab*(window: SdlWindow): SdlBool
proc SDL_GetGrabbedWindow*(): SdlWindow
proc SDL_SetWindowMouseRect*(window: SdlWindow, rect: ptr SdlRect): SdlBool
proc SDL_GetWindowMouseRect*(window: SdlWindow): ptr SdlRect
proc SDL_SetWindowOpacity*(window: SdlWindow, opacity: cfloat): SdlBool
proc SDL_GetWindowOpacity*(window: SdlWindow): cfloat
proc SDL_SetWindowParent*(window, parent: SdlWindow): SdlBool
proc SDL_SetWindowModal*(window: SdlWindow, modal: SdlBool): SdlBool
proc SDL_SetWindowFocusable*(window: SdlWindow, focusable: SdlBool): SdlBool
proc SDL_ShowWindowSystemMenu*(window: SdlWindow, x, y: cint): SdlBool
proc SDL_SetWindowHitTest*(window: SdlWindow, callback: proc(win: SdlWindow, area: ptr SdlPoint, data: pointer): cint {.cdecl.}, callback_data: pointer): SdlBool
proc SDL_SetWindowShape*(window: SdlWindow, shape: SdlSurface): SdlBool
proc SDL_FlashWindow*(window: SdlWindow, operation: cint): SdlBool
proc SDL_DestroyWindow*(window: SdlWindow)
proc SDL_ScreenSaverEnabled*(): SdlBool
proc SDL_EnableScreenSaver*(): SdlBool
proc SDL_DisableScreenSaver*(): SdlBool

# OpenGL functions
proc SDL_GL_LoadLibrary*(path: cstring): SdlBool
proc SDL_GL_GetProcAddress*(`proc`: cstring): pointer
proc SDL_EGL_GetProcAddress*(`proc`: cstring): pointer
proc SDL_GL_UnloadLibrary*()
proc SDL_GL_ExtensionSupported*(extension: cstring): SdlBool
proc SDL_GL_ResetAttributes*()
proc SDL_GL_SetAttribute*(attr: SdlGLattr, value: cint): SdlBool
proc SDL_GL_GetAttribute*(attr: SdlGLattr, value: ptr cint): SdlBool
proc SDL_GL_CreateContext*(window: SdlWindow): SdlGLContext
proc SDL_GL_MakeCurrent*(window: SdlWindow, context: SdlGLContext): SdlBool
proc SDL_GL_GetCurrentWindow*(): SdlWindow
proc SDL_GL_GetCurrentContext*(): SdlGLContext
proc SDL_EGL_GetCurrentDisplay*(): pointer
proc SDL_EGL_GetCurrentConfig*(): pointer
proc SDL_EGL_GetWindowSurface*(window: SdlWindow): pointer
proc SDL_EGL_SetAttributeCallbacks*(platformAttribCallback: proc(userdata: pointer, display: pointer, attribs: ptr cint): pointer {.cdecl.},
                                     surfaceAttribCallback: proc(userdata: pointer, display: pointer, config: pointer, attribs: ptr cint): pointer {.cdecl.},
                                     contextAttribCallback: proc(userdata: pointer, display: pointer, config: pointer, attribs: ptr cint): pointer {.cdecl.},
                                     userdata: pointer)
proc SDL_GL_SetSwapInterval*(interval: cint): SdlBool
proc SDL_GL_GetSwapInterval*(interval: ptr cint): SdlBool
proc SDL_GL_SwapWindow*(window: SdlWindow): SdlBool
proc SDL_GL_DestroyContext*(context: SdlGLContext): SdlBool

{.pop.}


# =============================================================================
# Rendering (SDL_render.h)
# =============================================================================

type
  SdlRendererLogicalPresentation* {.size: sizeof(cint).} = enum
    SDL_LOGICAL_PRESENTATION_DISABLED
    SDL_LOGICAL_PRESENTATION_STRETCH
    SDL_LOGICAL_PRESENTATION_LETTERBOX
    SDL_LOGICAL_PRESENTATION_OVERSCAN
    SDL_LOGICAL_PRESENTATION_INTEGER_SCALE
  
  SdlTextureAccess* {.size: sizeof(cint).} = enum
    SDL_TEXTUREACCESS_STATIC
    SDL_TEXTUREACCESS_STREAMING
    SDL_TEXTUREACCESS_TARGET
  
  SdlRendererFlip* {.size: sizeof(cint).} = enum
    SDL_FLIP_NONE = 0x00000000
    SDL_FLIP_HORIZONTAL = 0x00000001
    SDL_FLIP_VERTICAL = 0x00000002
  
  SdlVertex* {.bycopy.} = object
    position*: SdlFPoint
    color*: SdlFColor
    tex_coord*: SdlFPoint



{.push importc, dynlib: LibName, cdecl.}

proc SDL_GetNumRenderDrivers*(): cint
proc SDL_GetRenderDriver*(index: cint): cstring
proc SDL_CreateWindowAndRenderer*(title: cstring, width, height: cint, window_flags: SdlWindowFlags, window: ptr SdlWindow, renderer: ptr SdlRenderer): SdlBool
proc SDL_CreateRenderer*(window: SdlWindow, name: cstring): SdlRenderer
proc SDL_CreateRendererWithProperties*(props: SdlPropertiesID): SdlRenderer
proc SDL_CreateSoftwareRenderer*(surface: SdlSurface): SdlRenderer
proc SDL_GetRenderer*(window: SdlWindow): SdlRenderer
proc SDL_GetRenderWindow*(renderer: SdlRenderer): SdlWindow
proc SDL_GetRendererName*(renderer: SdlRenderer): cstring
proc SDL_GetRendererProperties*(renderer: SdlRenderer): SdlPropertiesID
proc SDL_GetRenderOutputSize*(renderer: SdlRenderer, w, h: ptr cint): SdlBool
proc SDL_GetCurrentRenderOutputSize*(renderer: SdlRenderer, w, h: ptr cint): SdlBool
proc SDL_CreateTexture*(renderer: SdlRenderer, format: SdlPixelFormat, access: SdlTextureAccess, w, h: cint): SdlTexture
proc SDL_CreateTextureFromSurface*(renderer: SdlRenderer, surface: SdlSurface): SdlTexture
proc SDL_CreateTextureWithProperties*(renderer: SdlRenderer, props: SdlPropertiesID): SdlTexture
proc SDL_GetTextureProperties*(texture: SdlTexture): SdlPropertiesID
proc SDL_GetRendererFromTexture*(texture: SdlTexture): SdlRenderer
proc SDL_GetTextureSize*(texture: SdlTexture, w, h: ptr cfloat): SdlBool
proc SDL_SetTextureColorMod*(texture: SdlTexture, r, g, b: uint8): SdlBool
proc SDL_SetTextureColorModFloat*(texture: SdlTexture, r, g, b: cfloat): SdlBool
proc SDL_GetTextureColorMod*(texture: SdlTexture, r, g, b: ptr uint8): SdlBool
proc SDL_GetTextureColorModFloat*(texture: SdlTexture, r, g, b: ptr cfloat): SdlBool
proc SDL_SetTextureAlphaMod*(texture: SdlTexture, alpha: uint8): SdlBool
proc SDL_SetTextureAlphaModFloat*(texture: SdlTexture, alpha: cfloat): SdlBool
proc SDL_GetTextureAlphaMod*(texture: SdlTexture, alpha: ptr uint8): SdlBool
proc SDL_GetTextureAlphaModFloat*(texture: SdlTexture, alpha: ptr cfloat): SdlBool
proc SDL_SetTextureBlendMode*(texture: SdlTexture, blendMode: SdlBlendMode): SdlBool
proc SDL_GetTextureBlendMode*(texture: SdlTexture, blendMode: ptr SdlBlendMode): SdlBool
proc SDL_SetTextureScaleMode*(texture: SdlTexture, scaleMode: SdlScaleMode): SdlBool
proc SDL_GetTextureScaleMode*(texture: SdlTexture, scaleMode: ptr SdlScaleMode): SdlBool
proc SDL_UpdateTexture*(texture: SdlTexture, rect: ptr SdlRect, pixels: pointer, pitch: cint): SdlBool
proc SDL_UpdateYUVTexture*(texture: SdlTexture, rect: ptr SdlRect, Yplane: ptr uint8, Ypitch: cint, 
                           Uplane: ptr uint8, Upitch: cint, Vplane: ptr uint8, Vpitch: cint): SdlBool
proc SDL_UpdateNVTexture*(texture: SdlTexture, rect: ptr SdlRect, Yplane: ptr uint8, Ypitch: cint, UVplane: ptr uint8, UVpitch: cint): SdlBool
proc SDL_LockTexture*(texture: SdlTexture, rect: ptr SdlRect, pixels: ptr pointer, pitch: ptr cint): SdlBool
proc SDL_LockTextureToSurface*(texture: SdlTexture, rect: ptr SdlRect, surface: ptr SdlSurface): SdlBool
proc SDL_UnlockTexture*(texture: SdlTexture)
proc SDL_SetRenderTarget*(renderer: SdlRenderer, texture: SdlTexture): SdlBool
proc SDL_GetRenderTarget*(renderer: SdlRenderer): SdlTexture
proc SDL_SetRenderLogicalPresentation*(renderer: SdlRenderer, w, h: cint, mode: SdlRendererLogicalPresentation): SdlBool
proc SDL_GetRenderLogicalPresentation*(renderer: SdlRenderer, w, h: ptr cint, mode: ptr SdlRendererLogicalPresentation): SdlBool
proc SDL_GetRenderLogicalPresentationRect*(renderer: SdlRenderer, rect: ptr SdlFRect): SdlBool
proc SDL_RenderCoordinatesFromWindow*(renderer: SdlRenderer, window_x, window_y: cfloat, x, y: ptr cfloat): SdlBool
proc SDL_RenderCoordinatesToWindow*(renderer: SdlRenderer, x, y: cfloat, window_x, window_y: ptr cfloat): SdlBool
proc SDL_ConvertEventToRenderCoordinates*(renderer: SdlRenderer, event: pointer): SdlBool
proc SDL_SetRenderViewport*(renderer: SdlRenderer, rect: ptr SdlRect): SdlBool
proc SDL_GetRenderViewport*(renderer: SdlRenderer, rect: ptr SdlRect): SdlBool
proc SDL_RenderViewportSet*(renderer: SdlRenderer): SdlBool
proc SDL_GetRenderSafeArea*(renderer: SdlRenderer, rect: ptr SdlRect): SdlBool
proc SDL_SetRenderClipRect*(renderer: SdlRenderer, rect: ptr SdlRect): SdlBool
proc SDL_GetRenderClipRect*(renderer: SdlRenderer, rect: ptr SdlRect): SdlBool
proc SDL_RenderClipEnabled*(renderer: SdlRenderer): SdlBool
proc SDL_SetRenderScale*(renderer: SdlRenderer, scaleX, scaleY: cfloat): SdlBool
proc SDL_GetRenderScale*(renderer: SdlRenderer, scaleX, scaleY: ptr cfloat): SdlBool
proc SDL_SetRenderDrawColor*(renderer: SdlRenderer, r, g, b, a: uint8): SdlBool
proc SDL_SetRenderDrawColorFloat*(renderer: SdlRenderer, r, g, b, a: cfloat): SdlBool
proc SDL_GetRenderDrawColor*(renderer: SdlRenderer, r, g, b, a: ptr uint8): SdlBool
proc SDL_GetRenderDrawColorFloat*(renderer: SdlRenderer, r, g, b, a: ptr cfloat): SdlBool
proc SDL_SetRenderColorScale*(renderer: SdlRenderer, scale: cfloat): SdlBool
proc SDL_GetRenderColorScale*(renderer: SdlRenderer, scale: ptr cfloat): SdlBool
proc SDL_SetRenderDrawBlendMode*(renderer: SdlRenderer, blendMode: SdlBlendMode): SdlBool
proc SDL_GetRenderDrawBlendMode*(renderer: SdlRenderer, blendMode: ptr SdlBlendMode): SdlBool
proc SDL_RenderClear*(renderer: SdlRenderer): SdlBool
proc SDL_RenderPoint*(renderer: SdlRenderer, x, y: cfloat): SdlBool
proc SDL_RenderPoints*(renderer: SdlRenderer, points: ptr SdlFPoint, count: cint): SdlBool
proc SDL_RenderLine*(renderer: SdlRenderer, x1, y1, x2, y2: cfloat): SdlBool
proc SDL_RenderLines*(renderer: SdlRenderer, points: ptr SdlFPoint, count: cint): SdlBool
proc SDL_RenderRect*(renderer: SdlRenderer, rect: ptr SdlFRect): SdlBool
proc SDL_RenderRects*(renderer: SdlRenderer, rects: ptr SdlFRect, count: cint): SdlBool
proc SDL_RenderFillRect*(renderer: SdlRenderer, rect: ptr SdlFRect): SdlBool
proc SDL_RenderFillRects*(renderer: SdlRenderer, rects: ptr SdlFRect, count: cint): SdlBool
proc SDL_RenderTexture*(renderer: SdlRenderer, texture: SdlTexture, srcrect, dstrect: ptr SdlFRect): SdlBool
proc SDL_RenderTextureRotated*(renderer: SdlRenderer, texture: SdlTexture, srcrect, dstrect: ptr SdlFRect, angle: cdouble, center: ptr SdlFPoint, flip: SdlRendererFlip): SdlBool
proc SDL_RenderTextureTiled*(renderer: SdlRenderer, texture: SdlTexture, srcrect, scale: cfloat, dstrect: ptr SdlFRect): SdlBool
proc SDL_RenderTexture9Grid*(renderer: SdlRenderer, texture: SdlTexture, srcrect: ptr SdlFRect, left_width, right_width, top_height, bottom_height, scale: cfloat, dstrect: ptr SdlFRect): SdlBool
proc SDL_RenderGeometry*(renderer: SdlRenderer, texture: SdlTexture, vertices: ptr SdlVertex, num_vertices: cint, indices: ptr cint, num_indices: cint): SdlBool
proc SDL_RenderGeometryRaw*(renderer: SdlRenderer, texture: SdlTexture, xy: ptr cfloat, xy_stride: cint, color: ptr SdlFColor, color_stride: cint,
                            uv: ptr cfloat, uv_stride: cint, num_vertices: cint, indices: pointer, num_indices: cint, size_indices: cint): SdlBool
proc SDL_RenderReadPixels*(renderer: SdlRenderer, rect: ptr SdlRect): SdlSurface
proc SDL_RenderPresent*(renderer: SdlRenderer): SdlBool
proc SDL_DestroyTexture*(texture: SdlTexture)
proc SDL_DestroyRenderer*(renderer: SdlRenderer)
proc SDL_FlushRenderer*(renderer: SdlRenderer): SdlBool
proc SDL_GetRenderMetalLayer*(renderer: SdlRenderer): pointer
proc SDL_GetRenderMetalCommandEncoder*(renderer: SdlRenderer): pointer
proc SDL_AddVulkanRenderSemaphores*(renderer: SdlRenderer, wait_stage_mask: uint32, wait_semaphore, signal_semaphore: Sint64): SdlBool
proc SDL_SetRenderVSync*(renderer: SdlRenderer, vsync: cint): SdlBool
proc SDL_GetRenderVSync*(renderer: SdlRenderer, vsync: ptr cint): SdlBool

{.pop.}


# =============================================================================
# Scancode and Keycode (SDL_scancode.h, SDL_keycode.h)
# =============================================================================

type
  SdlScancode* {.size: sizeof(cint).} = enum
    SDL_SCANCODE_UNKNOWN = 0
    SDL_SCANCODE_A = 4
    SDL_SCANCODE_B = 5
    SDL_SCANCODE_C = 6
    SDL_SCANCODE_D = 7
    SDL_SCANCODE_E = 8
    SDL_SCANCODE_F = 9
    SDL_SCANCODE_G = 10
    SDL_SCANCODE_H = 11
    SDL_SCANCODE_I = 12
    SDL_SCANCODE_J = 13
    SDL_SCANCODE_K = 14
    SDL_SCANCODE_L = 15
    SDL_SCANCODE_M = 16
    SDL_SCANCODE_N = 17
    SDL_SCANCODE_O = 18
    SDL_SCANCODE_P = 19
    SDL_SCANCODE_Q = 20
    SDL_SCANCODE_R = 21
    SDL_SCANCODE_S = 22
    SDL_SCANCODE_T = 23
    SDL_SCANCODE_U = 24
    SDL_SCANCODE_V = 25
    SDL_SCANCODE_W = 26
    SDL_SCANCODE_X = 27
    SDL_SCANCODE_Y = 28
    SDL_SCANCODE_Z = 29
    SDL_SCANCODE_1 = 30
    SDL_SCANCODE_2 = 31
    SDL_SCANCODE_3 = 32
    SDL_SCANCODE_4 = 33
    SDL_SCANCODE_5 = 34
    SDL_SCANCODE_6 = 35
    SDL_SCANCODE_7 = 36
    SDL_SCANCODE_8 = 37
    SDL_SCANCODE_9 = 38
    SDL_SCANCODE_0 = 39
    SDL_SCANCODE_RETURN = 40
    SDL_SCANCODE_ESCAPE = 41
    SDL_SCANCODE_BACKSPACE = 42
    SDL_SCANCODE_TAB = 43
    SDL_SCANCODE_SPACE = 44
    SDL_SCANCODE_MINUS = 45
    SDL_SCANCODE_EQUALS = 46
    SDL_SCANCODE_LEFTBRACKET = 47
    SDL_SCANCODE_RIGHTBRACKET = 48
    SDL_SCANCODE_BACKSLASH = 49
    SDL_SCANCODE_SEMICOLON = 51
    SDL_SCANCODE_APOSTROPHE = 52
    SDL_SCANCODE_GRAVE = 53
    SDL_SCANCODE_COMMA = 54
    SDL_SCANCODE_PERIOD = 55
    SDL_SCANCODE_SLASH = 56
    SDL_SCANCODE_CAPSLOCK = 57
    SDL_SCANCODE_F1 = 58
    SDL_SCANCODE_F2 = 59
    SDL_SCANCODE_F3 = 60
    SDL_SCANCODE_F4 = 61
    SDL_SCANCODE_F5 = 62
    SDL_SCANCODE_F6 = 63
    SDL_SCANCODE_F7 = 64
    SDL_SCANCODE_F8 = 65
    SDL_SCANCODE_F9 = 66
    SDL_SCANCODE_F10 = 67
    SDL_SCANCODE_F11 = 68
    SDL_SCANCODE_F12 = 69
    SDL_SCANCODE_PRINTSCREEN = 70
    SDL_SCANCODE_SCROLLLOCK = 71
    SDL_SCANCODE_PAUSE = 72
    SDL_SCANCODE_INSERT = 73
    SDL_SCANCODE_HOME = 74
    SDL_SCANCODE_PAGEUP = 75
    SDL_SCANCODE_DELETE = 76
    SDL_SCANCODE_END = 77
    SDL_SCANCODE_PAGEDOWN = 78
    SDL_SCANCODE_RIGHT = 79
    SDL_SCANCODE_LEFT = 80
    SDL_SCANCODE_DOWN = 81
    SDL_SCANCODE_UP = 82
    SDL_SCANCODE_NUMLOCKCLEAR = 83
    SDL_SCANCODE_KP_DIVIDE = 84
    SDL_SCANCODE_KP_MULTIPLY = 85
    SDL_SCANCODE_KP_MINUS = 86
    SDL_SCANCODE_KP_PLUS = 87
    SDL_SCANCODE_KP_ENTER = 88
    SDL_SCANCODE_KP_1 = 89
    SDL_SCANCODE_KP_2 = 90
    SDL_SCANCODE_KP_3 = 91
    SDL_SCANCODE_KP_4 = 92
    SDL_SCANCODE_KP_5 = 93
    SDL_SCANCODE_KP_6 = 94
    SDL_SCANCODE_KP_7 = 95
    SDL_SCANCODE_KP_8 = 96
    SDL_SCANCODE_KP_9 = 97
    SDL_SCANCODE_KP_0 = 98
    SDL_SCANCODE_KP_PERIOD = 99
    SDL_SCANCODE_APPLICATION = 101
    SDL_SCANCODE_POWER = 102
    SDL_SCANCODE_KP_EQUALS = 103
    SDL_SCANCODE_LCTRL = 224
    SDL_SCANCODE_LSHIFT = 225
    SDL_SCANCODE_LALT = 226
    SDL_SCANCODE_LGUI = 227
    SDL_SCANCODE_RCTRL = 228
    SDL_SCANCODE_RSHIFT = 229
    SDL_SCANCODE_RALT = 230
    SDL_SCANCODE_RGUI = 231

  SdlKeycode* = distinct uint32
  SdlKeymod* = distinct uint32

const
  SDLK_SCANCODE_MASK* = 1'u32 shl 30
  
  SDLK_UNKNOWN* = SdlKeycode(0)
  SDLK_RETURN* = SdlKeycode(13'u32)  # '\r' (carriage return)
  SDLK_ESCAPE* = SdlKeycode(27'u32)  # '\x1B' (escape)
  SDLK_BACKSPACE* = SdlKeycode(8'u32)  # '\b' (backspace)
  SDLK_TAB* = SdlKeycode(9'u32)  # '\t' (tab)
  SDLK_SPACE* = SdlKeycode(' '.uint32)
  SDLK_a* = SdlKeycode('a'.uint32)
  SDLK_b* = SdlKeycode('b'.uint32)
  SDLK_c* = SdlKeycode('c'.uint32)
  SDLK_d* = SdlKeycode('d'.uint32)
  SDLK_e* = SdlKeycode('e'.uint32)
  SDLK_f* = SdlKeycode('f'.uint32)
  SDLK_g* = SdlKeycode('g'.uint32)
  SDLK_h* = SdlKeycode('h'.uint32)
  SDLK_i* = SdlKeycode('i'.uint32)
  SDLK_j* = SdlKeycode('j'.uint32)
  SDLK_k* = SdlKeycode('k'.uint32)
  SDLK_l* = SdlKeycode('l'.uint32)
  SDLK_m* = SdlKeycode('m'.uint32)
  SDLK_n* = SdlKeycode('n'.uint32)
  SDLK_o* = SdlKeycode('o'.uint32)
  SDLK_p* = SdlKeycode('p'.uint32)
  SDLK_q* = SdlKeycode('q'.uint32)
  SDLK_r* = SdlKeycode('r'.uint32)
  SDLK_s* = SdlKeycode('s'.uint32)
  SDLK_t* = SdlKeycode('t'.uint32)
  SDLK_u* = SdlKeycode('u'.uint32)
  SDLK_v* = SdlKeycode('v'.uint32)
  SDLK_w* = SdlKeycode('w'.uint32)
  SDLK_x* = SdlKeycode('x'.uint32)
  SDLK_y* = SdlKeycode('y'.uint32)
  SDLK_z* = SdlKeycode('z'.uint32)

  SDL_KMOD_NONE* = SdlKeymod(0x0000)
  SDL_KMOD_LSHIFT* = SdlKeymod(0x0001)
  SDL_KMOD_RSHIFT* = SdlKeymod(0x0002)
  SDL_KMOD_SHIFT* = SdlKeymod(uint32(SDL_KMOD_LSHIFT) or uint32(SDL_KMOD_RSHIFT))
  SDL_KMOD_LCTRL* = SdlKeymod(0x0040)
  SDL_KMOD_RCTRL* = SdlKeymod(0x0080)
  SDL_KMOD_CTRL* = SdlKeymod(uint32(SDL_KMOD_LCTRL) or uint32(SDL_KMOD_RCTRL))
  SDL_KMOD_LALT* = SdlKeymod(0x0100)
  SDL_KMOD_RALT* = SdlKeymod(0x0200)
  SDL_KMOD_LGUI* = SdlKeymod(0x0400)
  SDL_KMOD_RGUI* = SdlKeymod(0x0800)
  SDL_KMOD_NUM* = SdlKeymod(0x1000)
  SDL_KMOD_CAPS* = SdlKeymod(0x2000)
  SDL_KMOD_MODE* = SdlKeymod(0x4000)
  SDL_KMOD_SCROLL* = SdlKeymod(0x8000)

proc `or`*(a, b: SdlKeymod): SdlKeymod {.borrow.}
proc `and`*(a, b: SdlKeymod): SdlKeymod {.borrow.}

# =============================================================================
# Keyboard (SDL_keyboard.h)
# =============================================================================

type
  SdlKeysym* {.bycopy.} = object
    scancode*: SdlScancode
    key*: SdlKeycode
    `mod`*: SdlKeymod
    unused*: uint16

{.push importc, dynlib: LibName, cdecl.}

proc SDL_HasKeyboard*(): SdlBool
proc SDL_GetKeyboards*(count: ptr cint): ptr SdlKeyboardID
proc SDL_GetKeyboardNameForID*(instance_id: SdlKeyboardID): cstring
proc SDL_GetKeyboardFocus*(): SdlWindow
proc SDL_GetKeyboardState*(numkeys: ptr cint): ptr uint8
proc SDL_ResetKeyboard*()
proc SDL_GetModState*(): SdlKeymod
proc SDL_SetModState*(modstate: SdlKeymod)
proc SDL_GetKeyFromScancode*(scancode: SdlScancode, modstate: SdlKeymod, key_event: SdlBool): SdlKeycode
proc SDL_GetScancodeFromKey*(key: SdlKeycode, modstate: ptr SdlKeymod): SdlScancode
proc SDL_SetScancodeName*(scancode: SdlScancode, name: cstring): SdlBool
proc SDL_GetScancodeName*(scancode: SdlScancode): cstring
proc SDL_GetScancodeFromName*(name: cstring): SdlScancode
proc SDL_GetKeyName*(key: SdlKeycode): cstring
proc SDL_GetKeyFromName*(name: cstring): SdlKeycode
proc SDL_StartTextInput*(window: SdlWindow): SdlBool
proc SDL_TextInputActive*(window: SdlWindow): SdlBool
proc SDL_StopTextInput*(window: SdlWindow): SdlBool
proc SDL_ClearComposition*(window: SdlWindow): SdlBool
proc SDL_SetTextInputArea*(window: SdlWindow, rect: ptr SdlRect, cursor: cint): SdlBool
proc SDL_GetTextInputArea*(window: SdlWindow, rect: ptr SdlRect, cursor: ptr cint): SdlBool
proc SDL_HasScreenKeyboardSupport*(): SdlBool
proc SDL_ScreenKeyboardShown*(window: SdlWindow): SdlBool

{.pop.}

# =============================================================================
# Mouse (SDL_mouse.h)
# =============================================================================

type
  SdlSystemCursor* {.size: sizeof(cint).} = enum
    SDL_SYSTEM_CURSOR_DEFAULT
    SDL_SYSTEM_CURSOR_TEXT
    SDL_SYSTEM_CURSOR_WAIT
    SDL_SYSTEM_CURSOR_CROSSHAIR
    SDL_SYSTEM_CURSOR_PROGRESS
    SDL_SYSTEM_CURSOR_NWSE_RESIZE
    SDL_SYSTEM_CURSOR_NESW_RESIZE
    SDL_SYSTEM_CURSOR_EW_RESIZE
    SDL_SYSTEM_CURSOR_NS_RESIZE
    SDL_SYSTEM_CURSOR_MOVE
    SDL_SYSTEM_CURSOR_NOT_ALLOWED
    SDL_SYSTEM_CURSOR_POINTER
    SDL_SYSTEM_CURSOR_NW_RESIZE
    SDL_SYSTEM_CURSOR_N_RESIZE
    SDL_SYSTEM_CURSOR_NE_RESIZE
    SDL_SYSTEM_CURSOR_E_RESIZE
    SDL_SYSTEM_CURSOR_SE_RESIZE
    SDL_SYSTEM_CURSOR_S_RESIZE
    SDL_SYSTEM_CURSOR_SW_RESIZE
    SDL_SYSTEM_CURSOR_W_RESIZE
    SDL_SYSTEM_CURSOR_COUNT
  
  SdlMouseWheelDirection* {.size: sizeof(cint).} = enum
    SDL_MOUSEWHEEL_NORMAL
    SDL_MOUSEWHEEL_FLIPPED
  
  SdlMouseButtonFlags* = distinct uint32

const
  SDL_BUTTON_LEFT* = 1'u32
  SDL_BUTTON_MIDDLE* = 2'u32
  SDL_BUTTON_RIGHT* = 3'u32
  SDL_BUTTON_X1* = 4'u32
  SDL_BUTTON_X2* = 5'u32
  SDL_BUTTON_LMASK* = SdlMouseButtonFlags(1'u32 shl (SDL_BUTTON_LEFT - 1))
  SDL_BUTTON_MMASK* = SdlMouseButtonFlags(1'u32 shl (SDL_BUTTON_MIDDLE - 1))
  SDL_BUTTON_RMASK* = SdlMouseButtonFlags(1'u32 shl (SDL_BUTTON_RIGHT - 1))
  SDL_BUTTON_X1MASK* = SdlMouseButtonFlags(1'u32 shl (SDL_BUTTON_X1 - 1))
  SDL_BUTTON_X2MASK* = SdlMouseButtonFlags(1'u32 shl (SDL_BUTTON_X2 - 1))

{.push importc, dynlib: LibName, cdecl.}

proc SDL_HasMouse*(): SdlBool
proc SDL_GetMice*(count: ptr cint): ptr SdlMouseID
proc SDL_GetMouseNameForID*(instance_id: SdlMouseID): cstring
proc SDL_GetMouseFocus*(): SdlWindow
proc SDL_GetMouseState*(x, y: ptr cfloat): SdlMouseButtonFlags
proc SDL_GetGlobalMouseState*(x, y: ptr cfloat): SdlMouseButtonFlags
proc SDL_GetRelativeMouseState*(x, y: ptr cfloat): SdlMouseButtonFlags
proc SDL_WarpMouseInWindow*(window: SdlWindow, x, y: cfloat)
proc SDL_WarpMouseGlobal*(x, y: cfloat): SdlBool
proc SDL_SetWindowRelativeMouseMode*(window: SdlWindow, enabled: SdlBool): SdlBool
proc SDL_GetWindowRelativeMouseMode*(window: SdlWindow): SdlBool
proc SDL_CaptureMouse*(enabled: SdlBool): SdlBool
proc SDL_CreateCursor*(data, mask: ptr uint8, w, h, hot_x, hot_y: cint): SdlCursor
proc SDL_CreateColorCursor*(surface: SdlSurface, hot_x, hot_y: cint): SdlCursor
proc SDL_CreateSystemCursor*(id: SdlSystemCursor): SdlCursor
proc SDL_SetCursor*(cursor: SdlCursor): SdlBool
proc SDL_GetCursor*(): SdlCursor
proc SDL_GetDefaultCursor*(): SdlCursor
proc SDL_DestroyCursor*(cursor: SdlCursor)
proc SDL_ShowCursor*(): SdlBool
proc SDL_HideCursor*(): SdlBool
proc SDL_CursorVisible*(): SdlBool

{.pop.}


# =============================================================================
# Events (SDL_events.h)
# =============================================================================

type
  SdlEventType* {.size: sizeof(uint32).} = enum
    SDL_EVENT_FIRST = 0
    SDL_EVENT_QUIT = 0x100
    SDL_EVENT_TERMINATING
    SDL_EVENT_LOW_MEMORY
    SDL_EVENT_WILL_ENTER_BACKGROUND
    SDL_EVENT_DID_ENTER_BACKGROUND
    SDL_EVENT_WILL_ENTER_FOREGROUND
    SDL_EVENT_DID_ENTER_FOREGROUND
    SDL_EVENT_LOCALE_CHANGED
    SDL_EVENT_SYSTEM_THEME_CHANGED
    SDL_EVENT_DISPLAY_ORIENTATION = 0x151
    SDL_EVENT_DISPLAY_ADDED
    SDL_EVENT_DISPLAY_REMOVED
    SDL_EVENT_DISPLAY_MOVED
    SDL_EVENT_DISPLAY_DESKTOP_MODE_CHANGED
    SDL_EVENT_DISPLAY_CURRENT_MODE_CHANGED
    SDL_EVENT_DISPLAY_CONTENT_SCALE_CHANGED
    SDL_EVENT_WINDOW_SHOWN = 0x202
    SDL_EVENT_WINDOW_HIDDEN
    SDL_EVENT_WINDOW_EXPOSED
    SDL_EVENT_WINDOW_MOVED
    SDL_EVENT_WINDOW_RESIZED
    SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED
    SDL_EVENT_WINDOW_METAL_VIEW_RESIZED
    SDL_EVENT_WINDOW_MINIMIZED
    SDL_EVENT_WINDOW_MAXIMIZED
    SDL_EVENT_WINDOW_RESTORED
    SDL_EVENT_WINDOW_MOUSE_ENTER
    SDL_EVENT_WINDOW_MOUSE_LEAVE
    SDL_EVENT_WINDOW_FOCUS_GAINED
    SDL_EVENT_WINDOW_FOCUS_LOST
    SDL_EVENT_WINDOW_CLOSE_REQUESTED
    SDL_EVENT_WINDOW_HIT_TEST
    SDL_EVENT_WINDOW_ICCPROF_CHANGED
    SDL_EVENT_WINDOW_DISPLAY_CHANGED
    SDL_EVENT_WINDOW_DISPLAY_SCALE_CHANGED
    SDL_EVENT_WINDOW_SAFE_AREA_CHANGED
    SDL_EVENT_WINDOW_OCCLUDED
    SDL_EVENT_WINDOW_ENTER_FULLSCREEN
    SDL_EVENT_WINDOW_LEAVE_FULLSCREEN
    SDL_EVENT_WINDOW_DESTROYED
    SDL_EVENT_WINDOW_HDR_STATE_CHANGED
    SDL_EVENT_KEY_DOWN = 0x300
    SDL_EVENT_KEY_UP
    SDL_EVENT_TEXT_EDITING
    SDL_EVENT_TEXT_INPUT
    SDL_EVENT_KEYMAP_CHANGED
    SDL_EVENT_KEYBOARD_ADDED
    SDL_EVENT_KEYBOARD_REMOVED
    SDL_EVENT_TEXT_EDITING_CANDIDATES
    SDL_EVENT_MOUSE_MOTION = 0x400
    SDL_EVENT_MOUSE_BUTTON_DOWN
    SDL_EVENT_MOUSE_BUTTON_UP
    SDL_EVENT_MOUSE_WHEEL
    SDL_EVENT_MOUSE_ADDED
    SDL_EVENT_MOUSE_REMOVED
    SDL_EVENT_JOYSTICK_AXIS_MOTION = 0x600
    SDL_EVENT_JOYSTICK_BALL_MOTION
    SDL_EVENT_JOYSTICK_HAT_MOTION
    SDL_EVENT_JOYSTICK_BUTTON_DOWN
    SDL_EVENT_JOYSTICK_BUTTON_UP
    SDL_EVENT_JOYSTICK_ADDED
    SDL_EVENT_JOYSTICK_REMOVED
    SDL_EVENT_JOYSTICK_BATTERY_UPDATED
    SDL_EVENT_JOYSTICK_UPDATE_COMPLETE
    SDL_EVENT_GAMEPAD_AXIS_MOTION = 0x650
    SDL_EVENT_GAMEPAD_BUTTON_DOWN
    SDL_EVENT_GAMEPAD_BUTTON_UP
    SDL_EVENT_GAMEPAD_ADDED
    SDL_EVENT_GAMEPAD_REMOVED
    SDL_EVENT_GAMEPAD_REMAPPED
    SDL_EVENT_GAMEPAD_TOUCHPAD_DOWN
    SDL_EVENT_GAMEPAD_TOUCHPAD_MOTION
    SDL_EVENT_GAMEPAD_TOUCHPAD_UP
    SDL_EVENT_GAMEPAD_SENSOR_UPDATE
    SDL_EVENT_GAMEPAD_UPDATE_COMPLETE
    SDL_EVENT_GAMEPAD_STEAM_HANDLE_UPDATED
    SDL_EVENT_FINGER_DOWN = 0x700
    SDL_EVENT_FINGER_UP
    SDL_EVENT_FINGER_MOTION
    SDL_EVENT_CLIPBOARD_UPDATE = 0x900
    SDL_EVENT_DROP_FILE = 0x1000
    SDL_EVENT_DROP_TEXT
    SDL_EVENT_DROP_BEGIN
    SDL_EVENT_DROP_COMPLETE
    SDL_EVENT_DROP_POSITION
    SDL_EVENT_AUDIO_DEVICE_ADDED = 0x1100
    SDL_EVENT_AUDIO_DEVICE_REMOVED
    SDL_EVENT_AUDIO_DEVICE_FORMAT_CHANGED
    SDL_EVENT_SENSOR_UPDATE = 0x1200
    SDL_EVENT_PEN_PROXIMITY_IN = 0x1300
    SDL_EVENT_PEN_PROXIMITY_OUT
    SDL_EVENT_PEN_DOWN
    SDL_EVENT_PEN_UP
    SDL_EVENT_PEN_BUTTON_DOWN
    SDL_EVENT_PEN_BUTTON_UP
    SDL_EVENT_PEN_MOTION
    SDL_EVENT_PEN_AXIS
    SDL_EVENT_CAMERA_DEVICE_ADDED = 0x1400
    SDL_EVENT_CAMERA_DEVICE_REMOVED
    SDL_EVENT_CAMERA_DEVICE_APPROVED
    SDL_EVENT_CAMERA_DEVICE_DENIED
    SDL_EVENT_RENDER_TARGETS_RESET = 0x2000
    SDL_EVENT_RENDER_DEVICE_RESET
    SDL_EVENT_RENDER_DEVICE_LOST
    SDL_EVENT_PRIVATE0 = 0x4000
    SDL_EVENT_PRIVATE1
    SDL_EVENT_PRIVATE2
    SDL_EVENT_PRIVATE3
    SDL_EVENT_POLL_SENTINEL = 0x7F00
    SDL_EVENT_USER = 0x8000
    SDL_EVENT_LAST = 0xFFFF
    SDL_EVENT_ENUM_PADDING = 0x7FFFFFFF

  SdlCommonEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
  
  SdlDisplayEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    displayID*: SdlDisplayID
    data1*: int32
    data2*: int32
  
  SdlWindowEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    windowID*: SdlWindowID
    data1*: int32
    data2*: int32
  
  SdlKeyboardDeviceEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    which*: SdlKeyboardID
  
  SdlKeyboardEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    windowID*: SdlWindowID
    which*: SdlKeyboardID
    scancode*: SdlScancode
    key*: SdlKeycode
    `mod`*: SdlKeymod
    raw*: uint16
    down*: SdlBool
    repeat*: SdlBool
  
  SdlTextEditingEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    windowID*: SdlWindowID
    text*: cstring
    start*: int32
    length*: int32
  
  SdlTextInputEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    windowID*: SdlWindowID
    text*: cstring
  
  SdlMouseDeviceEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    which*: SdlMouseID
  
  SdlMouseMotionEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    windowID*: SdlWindowID
    which*: SdlMouseID
    state*: SdlMouseButtonFlags
    x*: cfloat
    y*: cfloat
    xrel*: cfloat
    yrel*: cfloat
  
  SdlMouseButtonEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    windowID*: SdlWindowID
    which*: SdlMouseID
    button*: uint8
    down*: SdlBool
    clicks*: uint8
    padding*: uint8
    x*: cfloat
    y*: cfloat
  
  SdlMouseWheelEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    windowID*: SdlWindowID
    which*: SdlMouseID
    x*: cfloat
    y*: cfloat
    direction*: SdlMouseWheelDirection
    mouse_x*: cfloat
    mouse_y*: cfloat
  
  SdlJoyAxisEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    which*: SdlJoystickID
    axis*: uint8
    padding1*: uint8
    padding2*: uint8
    padding3*: uint8
    value*: int16
    padding4*: uint16
  
  SdlJoyButtonEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    which*: SdlJoystickID
    button*: uint8
    down*: SdlBool
    padding1*: uint8
    padding2*: uint8
  
  SdlJoyDeviceEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    which*: SdlJoystickID
  
  SdlGamepadAxisEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    which*: SdlJoystickID
    axis*: uint8
    padding1*: uint8
    padding2*: uint8
    padding3*: uint8
    value*: int16
    padding4*: uint16
  
  SdlGamepadButtonEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    which*: SdlJoystickID
    button*: uint8
    down*: SdlBool
    padding1*: uint8
    padding2*: uint8
  
  SdlGamepadDeviceEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    which*: SdlJoystickID
  
  SdlAudioDeviceEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    which*: SdlAudioDeviceID
    recording*: SdlBool
    padding1*: uint8
    padding2*: uint8
    padding3*: uint8
  
  SdlTouchFingerEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    touchID*: SdlTouchID
    fingerID*: SdlFingerID
    x*: cfloat
    y*: cfloat
    dx*: cfloat
    dy*: cfloat
    pressure*: cfloat
    windowID*: SdlWindowID
  
  SdlDropEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    windowID*: SdlWindowID
    x*: cfloat
    y*: cfloat
    source*: cstring
    data*: cstring
  
  SdlQuitEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
  
  SdlUserEvent* {.bycopy.} = object
    `type`*: SdlEventType
    reserved*: uint32
    timestamp*: uint64
    windowID*: SdlWindowID
    code*: int32
    data1*: pointer
    data2*: pointer
  
  SdlEvent* {.bycopy, union.} = object
    `type`*: SdlEventType
    common*: SdlCommonEvent
    display*: SdlDisplayEvent
    window*: SdlWindowEvent
    kdevice*: SdlKeyboardDeviceEvent
    key*: SdlKeyboardEvent
    edit*: SdlTextEditingEvent
    text*: SdlTextInputEvent
    mdevice*: SdlMouseDeviceEvent
    motion*: SdlMouseMotionEvent
    button*: SdlMouseButtonEvent
    wheel*: SdlMouseWheelEvent
    jaxis*: SdlJoyAxisEvent
    jbutton*: SdlJoyButtonEvent
    jdevice*: SdlJoyDeviceEvent
    gaxis*: SdlGamepadAxisEvent
    gbutton*: SdlGamepadButtonEvent
    gdevice*: SdlGamepadDeviceEvent
    adevice*: SdlAudioDeviceEvent
    tfinger*: SdlTouchFingerEvent
    drop*: SdlDropEvent
    quit*: SdlQuitEvent
    user*: SdlUserEvent
    padding*: array[128, uint8]
  
  SdlEventAction* {.size: sizeof(cint).} = enum
    SDL_ADDEVENT
    SDL_PEEKEVENT
    SDL_GETEVENT
  
  SdlEventFilter* = proc(userdata: pointer, event: ptr SdlEvent): SdlBool {.cdecl.}

{.push importc, dynlib: LibName, cdecl.}

proc SDL_PumpEvents*()
proc SDL_PeepEvents*(events: ptr SdlEvent, numevents: cint, action: SdlEventAction, minType, maxType: uint32): cint
proc SDL_HasEvent*(`type`: uint32): SdlBool
proc SDL_HasEvents*(minType, maxType: uint32): SdlBool
proc SDL_FlushEvent*(`type`: uint32)
proc SDL_FlushEvents*(minType, maxType: uint32)
proc SDL_PollEvent*(event: ptr SdlEvent): SdlBool
proc SDL_WaitEvent*(event: ptr SdlEvent): SdlBool
proc SDL_WaitEventTimeout*(event: ptr SdlEvent, timeoutMS: int32): SdlBool
proc SDL_PushEvent*(event: ptr SdlEvent): SdlBool
proc SDL_SetEventFilter*(filter: SdlEventFilter, userdata: pointer)
proc SDL_GetEventFilter*(filter: ptr SdlEventFilter, userdata: ptr pointer): SdlBool
proc SDL_AddEventWatch*(filter: SdlEventFilter, userdata: pointer): SdlBool
proc SDL_RemoveEventWatch*(filter: SdlEventFilter, userdata: pointer)
proc SDL_FilterEvents*(filter: SdlEventFilter, userdata: pointer)
proc SDL_SetEventEnabled*(`type`: uint32, enabled: SdlBool)
proc SDL_EventEnabled*(`type`: uint32): SdlBool
proc SDL_RegisterEvents*(numevents: cint): uint32
proc SDL_GetWindowFromEvent*(event: ptr SdlEvent): SdlWindow

{.pop.}


# =============================================================================
# Audio (SDL_audio.h)
# =============================================================================

type
  SdlAudioFormat* = distinct uint16
  
  SdlAudioSpec* {.bycopy.} = object
    format*: SdlAudioFormat
    channels*: cint
    freq*: cint
  
  SdlAudioStreamCallback* = proc(userdata: pointer, stream: SdlAudioStream, additional_amount: cint, total_amount: cint) {.cdecl.}
  SdlAudioPostmixCallback* = proc(userdata: pointer, spec: ptr SdlAudioSpec, buffer: ptr cfloat, buflen: cint) {.cdecl.}

const
  SDL_AUDIO_U8* = SdlAudioFormat(0x0008)
  SDL_AUDIO_S8* = SdlAudioFormat(0x8008)
  SDL_AUDIO_S16LE* = SdlAudioFormat(0x8010)
  SDL_AUDIO_S16BE* = SdlAudioFormat(0x9010)
  SDL_AUDIO_S32LE* = SdlAudioFormat(0x8020)
  SDL_AUDIO_S32BE* = SdlAudioFormat(0x9020)
  SDL_AUDIO_F32LE* = SdlAudioFormat(0x8120)
  SDL_AUDIO_F32BE* = SdlAudioFormat(0x9120)

when cpuEndian == littleEndian:
  const
    SDL_AUDIO_S16* = SDL_AUDIO_S16LE
    SDL_AUDIO_S32* = SDL_AUDIO_S32LE
    SDL_AUDIO_F32* = SDL_AUDIO_F32LE
else:
  const
    SDL_AUDIO_S16* = SDL_AUDIO_S16BE
    SDL_AUDIO_S32* = SDL_AUDIO_S32BE
    SDL_AUDIO_F32* = SDL_AUDIO_F32BE

{.push importc, dynlib: LibName, cdecl.}

proc SDL_GetNumAudioDrivers*(): cint
proc SDL_GetAudioDriver*(index: cint): cstring
proc SDL_GetCurrentAudioDriver*(): cstring
proc SDL_GetAudioPlaybackDevices*(count: ptr cint): ptr SdlAudioDeviceID
proc SDL_GetAudioRecordingDevices*(count: ptr cint): ptr SdlAudioDeviceID
proc SDL_GetAudioDeviceName*(devid: SdlAudioDeviceID): cstring
proc SDL_GetAudioDeviceFormat*(devid: SdlAudioDeviceID, spec: ptr SdlAudioSpec, sample_frames: ptr cint): SdlBool
proc SDL_GetAudioDeviceChannelMap*(devid: SdlAudioDeviceID, count: ptr cint): ptr cint
proc SDL_OpenAudioDevice*(devid: SdlAudioDeviceID, spec: ptr SdlAudioSpec): SdlAudioDeviceID
proc SDL_IsAudioDevicePhysical*(devid: SdlAudioDeviceID): SdlBool
proc SDL_IsAudioDevicePlayback*(devid: SdlAudioDeviceID): SdlBool
proc SDL_PauseAudioDevice*(dev: SdlAudioDeviceID): SdlBool
proc SDL_ResumeAudioDevice*(dev: SdlAudioDeviceID): SdlBool
proc SDL_AudioDevicePaused*(dev: SdlAudioDeviceID): SdlBool
proc SDL_GetAudioDeviceGain*(devid: SdlAudioDeviceID): cfloat
proc SDL_SetAudioDeviceGain*(devid: SdlAudioDeviceID, gain: cfloat): SdlBool
proc SDL_CloseAudioDevice*(devid: SdlAudioDeviceID)
proc SDL_BindAudioStreams*(devid: SdlAudioDeviceID, streams: ptr SdlAudioStream, num_streams: cint): SdlBool
proc SDL_BindAudioStream*(devid: SdlAudioDeviceID, stream: SdlAudioStream): SdlBool
proc SDL_UnbindAudioStreams*(streams: ptr SdlAudioStream, num_streams: cint)
proc SDL_UnbindAudioStream*(stream: SdlAudioStream)
proc SDL_GetAudioStreamDevice*(stream: SdlAudioStream): SdlAudioDeviceID
proc SDL_CreateAudioStream*(src_spec, dst_spec: ptr SdlAudioSpec): SdlAudioStream
proc SDL_GetAudioStreamProperties*(stream: SdlAudioStream): SdlPropertiesID
proc SDL_GetAudioStreamFormat*(stream: SdlAudioStream, src_spec, dst_spec: ptr SdlAudioSpec): SdlBool
proc SDL_SetAudioStreamFormat*(stream: SdlAudioStream, src_spec, dst_spec: ptr SdlAudioSpec): SdlBool
proc SDL_GetAudioStreamFrequencyRatio*(stream: SdlAudioStream): cfloat
proc SDL_SetAudioStreamFrequencyRatio*(stream: SdlAudioStream, ratio: cfloat): SdlBool
proc SDL_GetAudioStreamGain*(stream: SdlAudioStream): cfloat
proc SDL_SetAudioStreamGain*(stream: SdlAudioStream, gain: cfloat): SdlBool
proc SDL_GetAudioStreamInputChannelMap*(stream: SdlAudioStream, count: ptr cint): ptr cint
proc SDL_GetAudioStreamOutputChannelMap*(stream: SdlAudioStream, count: ptr cint): ptr cint
proc SDL_SetAudioStreamInputChannelMap*(stream: SdlAudioStream, chmap: ptr cint, count: cint): SdlBool
proc SDL_SetAudioStreamOutputChannelMap*(stream: SdlAudioStream, chmap: ptr cint, count: cint): SdlBool
proc SDL_PutAudioStreamData*(stream: SdlAudioStream, buf: pointer, len: cint): SdlBool
proc SDL_GetAudioStreamData*(stream: SdlAudioStream, buf: pointer, len: cint): cint
proc SDL_GetAudioStreamAvailable*(stream: SdlAudioStream): cint
proc SDL_GetAudioStreamQueued*(stream: SdlAudioStream): cint
proc SDL_FlushAudioStream*(stream: SdlAudioStream): SdlBool
proc SDL_ClearAudioStream*(stream: SdlAudioStream): SdlBool
proc SDL_PauseAudioStreamDevice*(stream: SdlAudioStream): SdlBool
proc SDL_ResumeAudioStreamDevice*(stream: SdlAudioStream): SdlBool
proc SDL_LockAudioStream*(stream: SdlAudioStream): SdlBool
proc SDL_UnlockAudioStream*(stream: SdlAudioStream): SdlBool
proc SDL_SetAudioStreamGetCallback*(stream: SdlAudioStream, callback: SdlAudioStreamCallback, userdata: pointer): SdlBool
proc SDL_SetAudioStreamPutCallback*(stream: SdlAudioStream, callback: SdlAudioStreamCallback, userdata: pointer): SdlBool
proc SDL_DestroyAudioStream*(stream: SdlAudioStream)
proc SDL_OpenAudioDeviceStream*(devid: SdlAudioDeviceID, spec: ptr SdlAudioSpec, callback: SdlAudioStreamCallback, userdata: pointer): SdlAudioStream
proc SDL_SetAudioPostmixCallback*(devid: SdlAudioDeviceID, callback: SdlAudioPostmixCallback, userdata: pointer): SdlBool
proc SDL_LoadWAV_IO*(src: SdlIOStream, closeio: SdlBool, spec: ptr SdlAudioSpec, audio_buf: ptr ptr uint8, audio_len: ptr uint32): SdlBool
proc SDL_LoadWAV*(path: cstring, spec: ptr SdlAudioSpec, audio_buf: ptr ptr uint8, audio_len: ptr uint32): SdlBool
proc SDL_MixAudio*(dst, src: ptr uint8, format: SdlAudioFormat, len: uint32, volume: cfloat): SdlBool
proc SDL_ConvertAudioSamples*(src_spec: ptr SdlAudioSpec, src_data: ptr uint8, src_len: cint,
                              dst_spec: ptr SdlAudioSpec, dst_data: ptr ptr uint8, dst_len: ptr cint): SdlBool
proc SDL_GetAudioFormatName*(format: SdlAudioFormat): cstring
proc SDL_GetSilenceValueForFormat*(format: SdlAudioFormat): cint

{.pop.}

# =============================================================================
# Timer (SDL_timer.h)
# =============================================================================

{.push importc, dynlib: LibName, cdecl.}

proc SDL_GetTicks*(): uint64
proc SDL_GetTicksNS*(): uint64
proc SDL_GetPerformanceCounter*(): uint64
proc SDL_GetPerformanceFrequency*(): uint64
proc SDL_Delay*(ms: uint32)
proc SDL_DelayNS*(ns: uint64)
proc SDL_DelayPrecise*(ns: uint64)
proc SDL_AddTimer*(interval: uint32, callback: SdlTimerCallback, userdata: pointer): SdlTimerID
proc SDL_AddTimerNS*(interval: uint64, callback: SdlNSTimerCallback, userdata: pointer): SdlTimerID
proc SDL_RemoveTimer*(id: SdlTimerID): SdlBool

{.pop.}

# =============================================================================
# Joystick (SDL_joystick.h)
# =============================================================================

type
  SdlJoystickType* {.size: sizeof(cint).} = enum
    SDL_JOYSTICK_TYPE_UNKNOWN
    SDL_JOYSTICK_TYPE_GAMEPAD
    SDL_JOYSTICK_TYPE_WHEEL
    SDL_JOYSTICK_TYPE_ARCADE_STICK
    SDL_JOYSTICK_TYPE_FLIGHT_STICK
    SDL_JOYSTICK_TYPE_DANCE_PAD
    SDL_JOYSTICK_TYPE_GUITAR
    SDL_JOYSTICK_TYPE_DRUM_KIT
    SDL_JOYSTICK_TYPE_ARCADE_PAD
    SDL_JOYSTICK_TYPE_THROTTLE
    SDL_JOYSTICK_TYPE_COUNT
  
  SdlJoystickConnectionState* {.size: sizeof(cint).} = enum
    SDL_JOYSTICK_CONNECTION_INVALID = -1
    SDL_JOYSTICK_CONNECTION_UNKNOWN
    SDL_JOYSTICK_CONNECTION_WIRED
    SDL_JOYSTICK_CONNECTION_WIRELESS
  
  SdlJoystickPowerLevel* {.size: sizeof(cint).} = enum
    SDL_JOYSTICK_POWER_UNKNOWN = -1
    SDL_JOYSTICK_POWER_EMPTY
    SDL_JOYSTICK_POWER_LOW
    SDL_JOYSTICK_POWER_MEDIUM
    SDL_JOYSTICK_POWER_FULL
    SDL_JOYSTICK_POWER_WIRED
    SDL_JOYSTICK_POWER_MAX

const
  SDL_JOYSTICK_AXIS_MAX* = 32767'i16
  SDL_JOYSTICK_AXIS_MIN* = -32768'i16

{.push importc, dynlib: LibName, cdecl.}

proc SDL_LockJoysticks*()
proc SDL_UnlockJoysticks*()
proc SDL_HasJoystick*(): SdlBool
proc SDL_GetJoysticks*(count: ptr cint): ptr SdlJoystickID
proc SDL_GetJoystickNameForID*(instance_id: SdlJoystickID): cstring
proc SDL_GetJoystickPathForID*(instance_id: SdlJoystickID): cstring
proc SDL_GetJoystickPlayerIndexForID*(instance_id: SdlJoystickID): cint
proc SDL_GetJoystickGUIDForID*(instance_id: SdlJoystickID): uint64  # SDL_GUID
proc SDL_GetJoystickVendorForID*(instance_id: SdlJoystickID): uint16
proc SDL_GetJoystickProductForID*(instance_id: SdlJoystickID): uint16
proc SDL_GetJoystickProductVersionForID*(instance_id: SdlJoystickID): uint16
proc SDL_GetJoystickTypeForID*(instance_id: SdlJoystickID): SdlJoystickType
proc SDL_OpenJoystick*(instance_id: SdlJoystickID): SdlJoystick
proc SDL_GetJoystickFromID*(instance_id: SdlJoystickID): SdlJoystick
proc SDL_GetJoystickFromPlayerIndex*(player_index: cint): SdlJoystick
proc SDL_GetJoystickProperties*(joystick: SdlJoystick): SdlPropertiesID
proc SDL_GetJoystickName*(joystick: SdlJoystick): cstring
proc SDL_GetJoystickPath*(joystick: SdlJoystick): cstring
proc SDL_GetJoystickPlayerIndex*(joystick: SdlJoystick): cint
proc SDL_SetJoystickPlayerIndex*(joystick: SdlJoystick, player_index: cint): SdlBool
proc SDL_GetJoystickGUID*(joystick: SdlJoystick): uint64
proc SDL_GetJoystickVendor*(joystick: SdlJoystick): uint16
proc SDL_GetJoystickProduct*(joystick: SdlJoystick): uint16
proc SDL_GetJoystickProductVersion*(joystick: SdlJoystick): uint16
proc SDL_GetJoystickFirmwareVersion*(joystick: SdlJoystick): uint16
proc SDL_GetJoystickSerial*(joystick: SdlJoystick): cstring
proc SDL_GetJoystickType*(joystick: SdlJoystick): SdlJoystickType
proc SDL_GetJoystickConnectionState*(joystick: SdlJoystick): SdlJoystickConnectionState
proc SDL_GetJoystickPowerLevel*(joystick: SdlJoystick): SdlJoystickPowerLevel
proc SDL_JoystickConnected*(joystick: SdlJoystick): SdlBool
proc SDL_GetJoystickID*(joystick: SdlJoystick): SdlJoystickID
proc SDL_GetNumJoystickAxes*(joystick: SdlJoystick): cint
proc SDL_GetNumJoystickBalls*(joystick: SdlJoystick): cint
proc SDL_GetNumJoystickHats*(joystick: SdlJoystick): cint
proc SDL_GetNumJoystickButtons*(joystick: SdlJoystick): cint
proc SDL_SetJoystickEventsEnabled*(enabled: SdlBool)
proc SDL_JoystickEventsEnabled*(): SdlBool
proc SDL_UpdateJoysticks*()
proc SDL_GetJoystickAxis*(joystick: SdlJoystick, axis: cint): int16
proc SDL_GetJoystickAxisInitialState*(joystick: SdlJoystick, axis: cint, state: ptr int16): SdlBool
proc SDL_GetJoystickBall*(joystick: SdlJoystick, ball: cint, dx, dy: ptr cint): SdlBool
proc SDL_GetJoystickHat*(joystick: SdlJoystick, hat: cint): uint8
proc SDL_GetJoystickButton*(joystick: SdlJoystick, button: cint): SdlBool
proc SDL_RumbleJoystick*(joystick: SdlJoystick, low_frequency_rumble, high_frequency_rumble: uint16, duration_ms: uint32): SdlBool
proc SDL_RumbleJoystickTriggers*(joystick: SdlJoystick, left_rumble, right_rumble: uint16, duration_ms: uint32): SdlBool
proc SDL_SetJoystickLED*(joystick: SdlJoystick, red, green, blue: uint8): SdlBool
proc SDL_SendJoystickEffect*(joystick: SdlJoystick, data: pointer, size: cint): SdlBool
proc SDL_CloseJoystick*(joystick: SdlJoystick)

{.pop.}


# =============================================================================
# Gamepad (SDL_gamepad.h)
# =============================================================================

type
  SdlGamepadType* {.size: sizeof(cint).} = enum
    SDL_GAMEPAD_TYPE_UNKNOWN = 0
    SDL_GAMEPAD_TYPE_STANDARD
    SDL_GAMEPAD_TYPE_XBOX360
    SDL_GAMEPAD_TYPE_XBOXONE
    SDL_GAMEPAD_TYPE_PS3
    SDL_GAMEPAD_TYPE_PS4
    SDL_GAMEPAD_TYPE_PS5
    SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_PRO
    SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_LEFT
    SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_RIGHT
    SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_PAIR
    SDL_GAMEPAD_TYPE_COUNT
  
  SdlGamepadButton* {.size: sizeof(cint).} = enum
    SDL_GAMEPAD_BUTTON_INVALID = -1
    SDL_GAMEPAD_BUTTON_SOUTH
    SDL_GAMEPAD_BUTTON_EAST
    SDL_GAMEPAD_BUTTON_WEST
    SDL_GAMEPAD_BUTTON_NORTH
    SDL_GAMEPAD_BUTTON_BACK
    SDL_GAMEPAD_BUTTON_GUIDE
    SDL_GAMEPAD_BUTTON_START
    SDL_GAMEPAD_BUTTON_LEFT_STICK
    SDL_GAMEPAD_BUTTON_RIGHT_STICK
    SDL_GAMEPAD_BUTTON_LEFT_SHOULDER
    SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER
    SDL_GAMEPAD_BUTTON_DPAD_UP
    SDL_GAMEPAD_BUTTON_DPAD_DOWN
    SDL_GAMEPAD_BUTTON_DPAD_LEFT
    SDL_GAMEPAD_BUTTON_DPAD_RIGHT
    SDL_GAMEPAD_BUTTON_MISC1
    SDL_GAMEPAD_BUTTON_RIGHT_PADDLE1
    SDL_GAMEPAD_BUTTON_LEFT_PADDLE1
    SDL_GAMEPAD_BUTTON_RIGHT_PADDLE2
    SDL_GAMEPAD_BUTTON_LEFT_PADDLE2
    SDL_GAMEPAD_BUTTON_TOUCHPAD
    SDL_GAMEPAD_BUTTON_MISC2
    SDL_GAMEPAD_BUTTON_MISC3
    SDL_GAMEPAD_BUTTON_MISC4
    SDL_GAMEPAD_BUTTON_MISC5
    SDL_GAMEPAD_BUTTON_MISC6
    SDL_GAMEPAD_BUTTON_COUNT
  
  SdlGamepadAxis* {.size: sizeof(cint).} = enum
    SDL_GAMEPAD_AXIS_INVALID = -1
    SDL_GAMEPAD_AXIS_LEFTX
    SDL_GAMEPAD_AXIS_LEFTY
    SDL_GAMEPAD_AXIS_RIGHTX
    SDL_GAMEPAD_AXIS_RIGHTY
    SDL_GAMEPAD_AXIS_LEFT_TRIGGER
    SDL_GAMEPAD_AXIS_RIGHT_TRIGGER
    SDL_GAMEPAD_AXIS_COUNT

{.push importc, dynlib: LibName, cdecl.}

proc SDL_AddGamepadMapping*(mapping: cstring): cint
proc SDL_AddGamepadMappingsFromFile*(file: cstring): cint
proc SDL_AddGamepadMappingsFromIO*(src: SdlIOStream, closeio: SdlBool): cint
proc SDL_ReloadGamepadMappings*(): SdlBool
proc SDL_GetGamepadMappings*(count: ptr cint): cstringArray
proc SDL_GetGamepadMappingForGUID*(guid: uint64): cstring
proc SDL_GetGamepadMapping*(gamepad: SdlGamepad): cstring
proc SDL_SetGamepadMapping*(instance_id: SdlJoystickID, mapping: cstring): SdlBool
proc SDL_HasGamepad*(): SdlBool
proc SDL_GetGamepads*(count: ptr cint): ptr SdlJoystickID
proc SDL_IsGamepad*(instance_id: SdlJoystickID): SdlBool
proc SDL_GetGamepadNameForID*(instance_id: SdlJoystickID): cstring
proc SDL_GetGamepadPathForID*(instance_id: SdlJoystickID): cstring
proc SDL_GetGamepadPlayerIndexForID*(instance_id: SdlJoystickID): cint
proc SDL_GetGamepadGUIDForID*(instance_id: SdlJoystickID): uint64
proc SDL_GetGamepadVendorForID*(instance_id: SdlJoystickID): uint16
proc SDL_GetGamepadProductForID*(instance_id: SdlJoystickID): uint16
proc SDL_GetGamepadProductVersionForID*(instance_id: SdlJoystickID): uint16
proc SDL_GetGamepadTypeForID*(instance_id: SdlJoystickID): SdlGamepadType
proc SDL_GetRealGamepadTypeForID*(instance_id: SdlJoystickID): SdlGamepadType
proc SDL_GetGamepadMappingForID*(instance_id: SdlJoystickID): cstring
proc SDL_OpenGamepad*(instance_id: SdlJoystickID): SdlGamepad
proc SDL_GetGamepadFromID*(instance_id: SdlJoystickID): SdlGamepad
proc SDL_GetGamepadFromPlayerIndex*(player_index: cint): SdlGamepad
proc SDL_GetGamepadProperties*(gamepad: SdlGamepad): SdlPropertiesID
proc SDL_GetGamepadID*(gamepad: SdlGamepad): SdlJoystickID
proc SDL_GetGamepadName*(gamepad: SdlGamepad): cstring
proc SDL_GetGamepadPath*(gamepad: SdlGamepad): cstring
proc SDL_GetGamepadType*(gamepad: SdlGamepad): SdlGamepadType
proc SDL_GetRealGamepadType*(gamepad: SdlGamepad): SdlGamepadType
proc SDL_GetGamepadPlayerIndex*(gamepad: SdlGamepad): cint
proc SDL_SetGamepadPlayerIndex*(gamepad: SdlGamepad, player_index: cint): SdlBool
proc SDL_GetGamepadVendor*(gamepad: SdlGamepad): uint16
proc SDL_GetGamepadProduct*(gamepad: SdlGamepad): uint16
proc SDL_GetGamepadProductVersion*(gamepad: SdlGamepad): uint16
proc SDL_GetGamepadFirmwareVersion*(gamepad: SdlGamepad): uint16
proc SDL_GetGamepadSerial*(gamepad: SdlGamepad): cstring
proc SDL_GetGamepadSteamHandle*(gamepad: SdlGamepad): uint64
proc SDL_GetGamepadConnectionState*(gamepad: SdlGamepad): SdlJoystickConnectionState
proc SDL_GetGamepadPowerLevel*(gamepad: SdlGamepad): SdlJoystickPowerLevel
proc SDL_GamepadConnected*(gamepad: SdlGamepad): SdlBool
proc SDL_GetGamepadJoystick*(gamepad: SdlGamepad): SdlJoystick
proc SDL_SetGamepadEventsEnabled*(enabled: SdlBool)
proc SDL_GamepadEventsEnabled*(): SdlBool
proc SDL_UpdateGamepads*()
proc SDL_GetGamepadAxisFromString*(str: cstring): SdlGamepadAxis
proc SDL_GetGamepadStringForAxis*(axis: SdlGamepadAxis): cstring
proc SDL_GamepadHasAxis*(gamepad: SdlGamepad, axis: SdlGamepadAxis): SdlBool
proc SDL_GetGamepadAxis*(gamepad: SdlGamepad, axis: SdlGamepadAxis): int16
proc SDL_GetGamepadButtonFromString*(str: cstring): SdlGamepadButton
proc SDL_GetGamepadStringForButton*(button: SdlGamepadButton): cstring
proc SDL_GamepadHasButton*(gamepad: SdlGamepad, button: SdlGamepadButton): SdlBool
proc SDL_GetGamepadButton*(gamepad: SdlGamepad, button: SdlGamepadButton): SdlBool
proc SDL_GetGamepadButtonLabelForType*(`type`: SdlGamepadType, button: SdlGamepadButton): cint
proc SDL_GetGamepadButtonLabel*(gamepad: SdlGamepad, button: SdlGamepadButton): cint
proc SDL_GetNumGamepadTouchpads*(gamepad: SdlGamepad): cint
proc SDL_GetNumGamepadTouchpadFingers*(gamepad: SdlGamepad, touchpad: cint): cint
proc SDL_GetGamepadTouchpadFinger*(gamepad: SdlGamepad, touchpad, finger: cint, down: ptr SdlBool, x, y, pressure: ptr cfloat): SdlBool
proc SDL_GamepadHasSensor*(gamepad: SdlGamepad, `type`: cint): SdlBool
proc SDL_SetGamepadSensorEnabled*(gamepad: SdlGamepad, `type`: cint, enabled: SdlBool): SdlBool
proc SDL_GamepadSensorEnabled*(gamepad: SdlGamepad, `type`: cint): SdlBool
proc SDL_GetGamepadSensorDataRate*(gamepad: SdlGamepad, `type`: cint): cfloat
proc SDL_GetGamepadSensorData*(gamepad: SdlGamepad, `type`: cint, data: ptr cfloat, num_values: cint): SdlBool
proc SDL_RumbleGamepad*(gamepad: SdlGamepad, low_frequency_rumble, high_frequency_rumble: uint16, duration_ms: uint32): SdlBool
proc SDL_RumbleGamepadTriggers*(gamepad: SdlGamepad, left_rumble, right_rumble: uint16, duration_ms: uint32): SdlBool
proc SDL_SetGamepadLED*(gamepad: SdlGamepad, red, green, blue: uint8): SdlBool
proc SDL_SendGamepadEffect*(gamepad: SdlGamepad, data: pointer, size: cint): SdlBool
proc SDL_CloseGamepad*(gamepad: SdlGamepad)
proc SDL_GetGamepadAppleSFSymbolsNameForButton*(gamepad: SdlGamepad, button: SdlGamepadButton): cstring
proc SDL_GetGamepadAppleSFSymbolsNameForAxis*(gamepad: SdlGamepad, axis: SdlGamepadAxis): cstring

{.pop.}

# =============================================================================
# Threading and Synchronization (SDL_mutex.h, SDL_thread.h)
# =============================================================================

type
  SdlThreadPriority* {.size: sizeof(cint).} = enum
    SDL_THREAD_PRIORITY_LOW
    SDL_THREAD_PRIORITY_NORMAL
    SDL_THREAD_PRIORITY_HIGH
    SDL_THREAD_PRIORITY_TIME_CRITICAL

{.push importc, dynlib: LibName, cdecl.}

# Mutex
proc SDL_CreateMutex*(): SdlMutex
proc SDL_LockMutex*(mutex: SdlMutex)
proc SDL_TryLockMutex*(mutex: SdlMutex): SdlBool
proc SDL_UnlockMutex*(mutex: SdlMutex)
proc SDL_DestroyMutex*(mutex: SdlMutex)

# RWLock
proc SDL_CreateRWLock*(): SdlRWLock
proc SDL_LockRWLockForReading*(rwlock: SdlRWLock)
proc SDL_LockRWLockForWriting*(rwlock: SdlRWLock)
proc SDL_TryLockRWLockForReading*(rwlock: SdlRWLock): SdlBool
proc SDL_TryLockRWLockForWriting*(rwlock: SdlRWLock): SdlBool
proc SDL_UnlockRWLock*(rwlock: SdlRWLock)
proc SDL_DestroyRWLock*(rwlock: SdlRWLock)

# Semaphore
proc SDL_CreateSemaphore*(initial_value: uint32): SdlSemaphore
proc SDL_DestroySemaphore*(sem: SdlSemaphore)
proc SDL_WaitSemaphore*(sem: SdlSemaphore)
proc SDL_TryWaitSemaphore*(sem: SdlSemaphore): SdlBool
proc SDL_WaitSemaphoreTimeout*(sem: SdlSemaphore, timeoutMS: int32): SdlBool
proc SDL_SignalSemaphore*(sem: SdlSemaphore)
proc SDL_GetSemaphoreValue*(sem: SdlSemaphore): uint32

# Condition Variable
proc SDL_CreateCondition*(): SdlCondition
proc SDL_DestroyCondition*(cond: SdlCondition)
proc SDL_SignalCondition*(cond: SdlCondition)
proc SDL_BroadcastCondition*(cond: SdlCondition)
proc SDL_WaitCondition*(cond: SdlCondition, mutex: SdlMutex)
proc SDL_WaitConditionTimeout*(cond: SdlCondition, mutex: SdlMutex, timeoutMS: int32): SdlBool

# Thread
proc SDL_CreateThread*(fn: SdlThreadFunction, name: cstring, data: pointer): SdlThread
proc SDL_CreateThreadWithProperties*(props: SdlPropertiesID): SdlThread
proc SDL_GetThreadName*(thread: SdlThread): cstring
proc SDL_GetCurrentThreadID*(): uint64
proc SDL_GetThreadID*(thread: SdlThread): uint64
proc SDL_SetThreadPriority*(priority: SdlThreadPriority): SdlBool
proc SDL_WaitThread*(thread: SdlThread, status: ptr cint)
proc SDL_DetachThread*(thread: SdlThread)
proc SDL_GetTLS*(id: ptr SdlTLSID): pointer
proc SDL_SetTLS*(id: ptr SdlTLSID, value: pointer, destructor: proc(p: pointer) {.cdecl.}): SdlBool
proc SDL_CleanupTLS*()

{.pop.}

# =============================================================================
# File I/O (SDL_iostream.h)
# =============================================================================

type
  SdlIOWhence* {.size: sizeof(cint).} = enum
    SDL_IO_SEEK_SET
    SDL_IO_SEEK_CUR
    SDL_IO_SEEK_END
  
  SdlIOStatus* {.size: sizeof(cint).} = enum
    SDL_IO_STATUS_READY
    SDL_IO_STATUS_ERROR
    SDL_IO_STATUS_EOF

{.push importc, dynlib: LibName, cdecl.}

proc SDL_IOFromFile*(file, mode: cstring): SdlIOStream
proc SDL_IOFromMem*(mem: pointer, size: csize_t): SdlIOStream
proc SDL_IOFromConstMem*(mem: pointer, size: csize_t): SdlIOStream
proc SDL_IOFromDynamicMem*(): SdlIOStream
proc SDL_OpenIO*(iface: pointer, userdata: pointer): SdlIOStream
proc SDL_CloseIO*(context: SdlIOStream): SdlBool
proc SDL_GetIOProperties*(context: SdlIOStream): SdlPropertiesID
proc SDL_GetIOStatus*(context: SdlIOStream): SdlIOStatus
proc SDL_GetIOSize*(context: SdlIOStream): Sint64
proc SDL_SeekIO*(context: SdlIOStream, offset: Sint64, whence: SdlIOWhence): Sint64
proc SDL_TellIO*(context: SdlIOStream): Sint64
proc SDL_ReadIO*(context: SdlIOStream, `ptr`: pointer, size: csize_t): csize_t
proc SDL_WriteIO*(context: SdlIOStream, `ptr`: pointer, size: csize_t): csize_t
proc SDL_IOprintf*(context: SdlIOStream, fmt: cstring): csize_t {.varargs.}
proc SDL_IOvprintf*(context: SdlIOStream, fmt: cstring, ap: pointer): csize_t
proc SDL_FlushIO*(context: SdlIOStream): SdlBool
proc SDL_LoadFile_IO*(src: SdlIOStream, datasize: ptr csize_t, closeio: SdlBool): pointer
proc SDL_LoadFile*(file: cstring, datasize: ptr csize_t): pointer
proc SDL_SaveFile_IO*(src: SdlIOStream, data: pointer, datasize: csize_t, closeio: SdlBool): SdlBool
proc SDL_SaveFile*(file: cstring, data: pointer, datasize: csize_t): SdlBool
proc SDL_ReadU8*(src: SdlIOStream, value: ptr uint8): SdlBool
proc SDL_ReadS8*(src: SdlIOStream, value: ptr int8): SdlBool
proc SDL_ReadU16LE*(src: SdlIOStream, value: ptr uint16): SdlBool
proc SDL_ReadS16LE*(src: SdlIOStream, value: ptr int16): SdlBool
proc SDL_ReadU16BE*(src: SdlIOStream, value: ptr uint16): SdlBool
proc SDL_ReadS16BE*(src: SdlIOStream, value: ptr int16): SdlBool
proc SDL_ReadU32LE*(src: SdlIOStream, value: ptr uint32): SdlBool
proc SDL_ReadS32LE*(src: SdlIOStream, value: ptr int32): SdlBool
proc SDL_ReadU32BE*(src: SdlIOStream, value: ptr uint32): SdlBool
proc SDL_ReadS32BE*(src: SdlIOStream, value: ptr int32): SdlBool
proc SDL_ReadU64LE*(src: SdlIOStream, value: ptr uint64): SdlBool
proc SDL_ReadS64LE*(src: SdlIOStream, value: ptr int64): SdlBool
proc SDL_ReadU64BE*(src: SdlIOStream, value: ptr uint64): SdlBool
proc SDL_ReadS64BE*(src: SdlIOStream, value: ptr int64): SdlBool
proc SDL_WriteU8*(dst: SdlIOStream, value: uint8): SdlBool
proc SDL_WriteS8*(dst: SdlIOStream, value: int8): SdlBool
proc SDL_WriteU16LE*(dst: SdlIOStream, value: uint16): SdlBool
proc SDL_WriteS16LE*(dst: SdlIOStream, value: int16): SdlBool
proc SDL_WriteU16BE*(dst: SdlIOStream, value: uint16): SdlBool
proc SDL_WriteS16BE*(dst: SdlIOStream, value: int16): SdlBool
proc SDL_WriteU32LE*(dst: SdlIOStream, value: uint32): SdlBool
proc SDL_WriteS32LE*(dst: SdlIOStream, value: int32): SdlBool
proc SDL_WriteU32BE*(dst: SdlIOStream, value: uint32): SdlBool
proc SDL_WriteS32BE*(dst: SdlIOStream, value: int32): SdlBool
proc SDL_WriteU64LE*(dst: SdlIOStream, value: uint64): SdlBool
proc SDL_WriteS64LE*(dst: SdlIOStream, value: int64): SdlBool
proc SDL_WriteU64BE*(dst: SdlIOStream, value: uint64): SdlBool
proc SDL_WriteS64BE*(dst: SdlIOStream, value: int64): SdlBool

{.pop.}


# =============================================================================
# Clipboard (SDL_clipboard.h)
# =============================================================================

{.push importc, dynlib: LibName, cdecl.}

proc SDL_SetClipboardText*(text: cstring): SdlBool
proc SDL_GetClipboardText*(): cstring
proc SDL_HasClipboardText*(): SdlBool
proc SDL_SetPrimarySelectionText*(text: cstring): SdlBool
proc SDL_GetPrimarySelectionText*(): cstring
proc SDL_HasPrimarySelectionText*(): SdlBool
proc SDL_SetClipboardData*(callback: proc(userdata: pointer, mime_type: cstring, size: ptr csize_t): pointer {.cdecl.},
                            cleanup: proc(userdata: pointer) {.cdecl.}, userdata: pointer, mime_types: cstringArray, num_mime_types: csize_t): SdlBool
proc SDL_ClearClipboardData*(): SdlBool
proc SDL_GetClipboardData*(mime_type: cstring, size: ptr csize_t): pointer
proc SDL_HasClipboardData*(mime_type: cstring): SdlBool
proc SDL_GetClipboardMimeTypes*(num_mime_types: ptr csize_t): cstringArray

{.pop.}

# =============================================================================
# Filesystem (SDL_filesystem.h)
# =============================================================================

type
  SdlPathType* {.size: sizeof(cint).} = enum
    SDL_PATHTYPE_NONE
    SDL_PATHTYPE_FILE
    SDL_PATHTYPE_DIRECTORY
    SDL_PATHTYPE_OTHER
  
  SdlFolder* {.size: sizeof(cint).} = enum
    SDL_FOLDER_HOME
    SDL_FOLDER_DESKTOP
    SDL_FOLDER_DOCUMENTS
    SDL_FOLDER_DOWNLOADS
    SDL_FOLDER_MUSIC
    SDL_FOLDER_PICTURES
    SDL_FOLDER_PUBLICSHARE
    SDL_FOLDER_SAVEDGAMES
    SDL_FOLDER_SCREENSHOTS
    SDL_FOLDER_TEMPLATES
    SDL_FOLDER_VIDEOS
    SDL_FOLDER_COUNT
  
  SdlGlobFlags* = distinct uint32
  
  SdlPathInfo* {.bycopy.} = object
    `type`*: SdlPathType
    size*: uint64
    create_time*: int64
    modify_time*: int64
    access_time*: int64

const
  SDL_GLOB_CASEINSENSITIVE* = SdlGlobFlags(1'u32 shl 0)

{.push importc, dynlib: LibName, cdecl.}

proc SDL_GetBasePath*(): cstring
proc SDL_GetPrefPath*(org, app: cstring): cstring
proc SDL_GetUserFolder*(folder: SdlFolder): cstring
proc SDL_CreateDirectory*(path: cstring): SdlBool
proc SDL_EnumerateDirectory*(path: cstring, callback: proc(userdata: pointer, dirname, fname: cstring): cint {.cdecl.}, userdata: pointer): SdlBool
proc SDL_RemovePath*(path: cstring): SdlBool
proc SDL_RenamePath*(oldpath, newpath: cstring): SdlBool
proc SDL_CopyFile*(oldpath, newpath: cstring): SdlBool
proc SDL_GetPathInfo*(path: cstring, info: ptr SdlPathInfo): SdlBool
proc SDL_GlobDirectory*(path, pattern: cstring, flags: SdlGlobFlags, count: ptr cint): cstringArray
proc SDL_GetCurrentDirectory*(): cstring
proc SDL_GetStorageFileSize*(storage: pointer, path: cstring, length: ptr uint64): SdlBool
proc SDL_ReadStorageFile*(storage: pointer, path: cstring, destination: pointer, length: uint64): SdlBool
proc SDL_WriteStorageFile*(storage: pointer, path: cstring, source: pointer, length: uint64): SdlBool

{.pop.}

# =============================================================================
# Logging (SDL_log.h)
# =============================================================================

type
  SdlLogCategory* {.size: sizeof(cint).} = enum
    SDL_LOG_CATEGORY_APPLICATION
    SDL_LOG_CATEGORY_ERROR
    SDL_LOG_CATEGORY_ASSERT
    SDL_LOG_CATEGORY_SYSTEM
    SDL_LOG_CATEGORY_AUDIO
    SDL_LOG_CATEGORY_VIDEO
    SDL_LOG_CATEGORY_RENDER
    SDL_LOG_CATEGORY_INPUT
    SDL_LOG_CATEGORY_TEST
    SDL_LOG_CATEGORY_GPU
    SDL_LOG_CATEGORY_CUSTOM = 19
  
  SdlLogPriority* {.size: sizeof(cint).} = enum
    SDL_LOG_PRIORITY_INVALID
    SDL_LOG_PRIORITY_TRACE
    SDL_LOG_PRIORITY_VERBOSE
    SDL_LOG_PRIORITY_DEBUG
    SDL_LOG_PRIORITY_INFO
    SDL_LOG_PRIORITY_WARN
    SDL_LOG_PRIORITY_ERROR
    SDL_LOG_PRIORITY_CRITICAL
    SDL_LOG_PRIORITY_COUNT
  
  SdlLogOutputFunction* = proc(userdata: pointer, category: SdlLogCategory, priority: SdlLogPriority, message: cstring) {.cdecl.}

{.push importc, dynlib: LibName, cdecl.}

proc SDL_SetLogPriorities*(priority: SdlLogPriority)
proc SDL_SetLogPriority*(category: SdlLogCategory, priority: SdlLogPriority)
proc SDL_GetLogPriority*(category: SdlLogCategory): SdlLogPriority
proc SDL_ResetLogPriorities*()
proc SDL_SetLogOutputFunction*(callback: SdlLogOutputFunction, userdata: pointer): SdlBool
proc SDL_GetLogOutputFunction*(callback: ptr SdlLogOutputFunction, userdata: ptr pointer): SdlBool
proc SDL_Log*(fmt: cstring) {.varargs.}
proc SDL_LogTrace*(category: SdlLogCategory, fmt: cstring) {.varargs.}
proc SDL_LogVerbose*(category: SdlLogCategory, fmt: cstring) {.varargs.}
proc SDL_LogDebug*(category: SdlLogCategory, fmt: cstring) {.varargs.}
proc SDL_LogInfo*(category: SdlLogCategory, fmt: cstring) {.varargs.}
proc SDL_LogWarn*(category: SdlLogCategory, fmt: cstring) {.varargs.}
proc SDL_LogError*(category: SdlLogCategory, fmt: cstring) {.varargs.}
proc SDL_LogCritical*(category: SdlLogCategory, fmt: cstring) {.varargs.}
proc SDL_LogMessage*(category: SdlLogCategory, priority: SdlLogPriority, fmt: cstring) {.varargs.}

{.pop.}

# =============================================================================
# Version (SDL_version.h)
# =============================================================================

const
  SDL_MAJOR_VERSION* = 3
  SDL_MINOR_VERSION* = 5
  SDL_MICRO_VERSION* = 0

{.push importc, dynlib: LibName, cdecl.}

proc SDL_GetVersion*(): cint
proc SDL_GetRevision*(): cstring

{.pop.}

# =============================================================================
# CPU Info (SDL_cpuinfo.h)
# =============================================================================

const
  SDL_CACHELINE_SIZE* = 128

{.push importc, dynlib: LibName, cdecl.}

proc SDL_GetCPUCount*(): cint
proc SDL_GetCPUCacheLineSize*(): cint
proc SDL_HasAltiVec*(): SdlBool
proc SDL_HasMMX*(): SdlBool
proc SDL_HasSSE*(): SdlBool
proc SDL_HasSSE2*(): SdlBool
proc SDL_HasSSE3*(): SdlBool
proc SDL_HasSSE41*(): SdlBool
proc SDL_HasSSE42*(): SdlBool
proc SDL_HasAVX*(): SdlBool
proc SDL_HasAVX2*(): SdlBool
proc SDL_HasAVX512F*(): SdlBool
proc SDL_HasARMSIMD*(): SdlBool
proc SDL_HasNEON*(): SdlBool
proc SDL_HasLSX*(): SdlBool
proc SDL_HasLASX*(): SdlBool
proc SDL_GetSystemRAM*(): cint
proc SDL_GetSIMDAlignment*(): csize_t
proc SDL_SIMDAlloc*(len: csize_t): pointer
proc SDL_SIMDRealloc*(`mem`: pointer, len: csize_t): pointer
proc SDL_SIMDFree*(`ptr`: pointer)

{.pop.}


# =============================================================================
# Platform Detection (SDL_platform.h)
# =============================================================================

{.push importc, dynlib: LibName, cdecl.}

proc SDL_GetPlatform*(): cstring

{.pop.}


# =============================================================================
# Power Management (SDL_power.h)
# =============================================================================

type
  SdlPowerState* {.size: sizeof(cint).} = enum
    SDL_POWERSTATE_ERROR = -1
    SDL_POWERSTATE_UNKNOWN
    SDL_POWERSTATE_ON_BATTERY
    SDL_POWERSTATE_NO_BATTERY
    SDL_POWERSTATE_CHARGING
    SDL_POWERSTATE_CHARGED

{.push importc, dynlib: LibName, cdecl.}

proc SDL_GetPowerInfo*(seconds, percent: ptr cint): SdlPowerState

{.pop.}


# =============================================================================
# Locale (SDL_locale.h)
# =============================================================================

type
  SdlLocale* {.bycopy.} = object
    language*: cstring
    country*: cstring

{.push importc, dynlib: LibName, cdecl.}

proc SDL_GetPreferredLocales*(count: ptr cint): ptr SdlLocale

{.pop.}


# =============================================================================
# Hints (SDL_hints.h)
# =============================================================================

type
  SdlHintPriority* {.size: sizeof(cint).} = enum
    SDL_HINT_DEFAULT
    SDL_HINT_NORMAL
    SDL_HINT_OVERRIDE
  
  SdlHintCallback* = proc(userdata: pointer, name, oldValue, newValue: cstring) {.cdecl.}

{.push importc, dynlib: LibName, cdecl.}

proc SDL_SetHintWithPriority*(name, value: cstring, priority: SdlHintPriority): SdlBool
proc SDL_SetHint*(name, value: cstring): SdlBool
proc SDL_ResetHint*(name: cstring): SdlBool
proc SDL_ResetHints*()
proc SDL_GetHint*(name: cstring): cstring
proc SDL_GetHintBoolean*(name: cstring, default_value: SdlBool): SdlBool
proc SDL_AddHintCallback*(name: cstring, callback: SdlHintCallback, userdata: pointer): SdlBool
proc SDL_RemoveHintCallback*(name: cstring, callback: SdlHintCallback, userdata: pointer)

{.pop.}


# =============================================================================
# Miscellaneous (SDL_misc.h)
# =============================================================================

{.push importc, dynlib: LibName, cdecl.}

proc SDL_OpenURL*(url: cstring): SdlBool

{.pop.}


# =============================================================================
# Memory Management (SDL_stdinc.h)
# =============================================================================

{.push importc, dynlib: LibName, cdecl.}

proc SDL_malloc*(size: csize_t): pointer
proc SDL_calloc*(nmemb, size: csize_t): pointer
proc SDL_realloc*(`mem`: pointer, size: csize_t): pointer
proc SDL_free*(`mem`: pointer)
proc SDL_memset*(dst: pointer, c: cint, len: csize_t): pointer
proc SDL_memcpy*(dst, src: pointer, len: csize_t): pointer
proc SDL_memmove*(dst, src: pointer, len: csize_t): pointer
proc SDL_memcmp*(s1, s2: pointer, len: csize_t): cint
proc SDL_strlen*(str: cstring): csize_t
proc SDL_strlcpy*(dst, src: cstring, maxlen: csize_t): csize_t
proc SDL_strlcat*(dst, src: cstring, maxlen: csize_t): csize_t
proc SDL_strdup*(str: cstring): cstring
proc SDL_strndup*(str: cstring, maxlen: csize_t): cstring
proc SDL_strrev*(str: cstring): cstring
proc SDL_strupr*(str: cstring): cstring
proc SDL_strlwr*(str: cstring): cstring
proc SDL_strchr*(str: cstring, c: cint): cstring
proc SDL_strrchr*(str: cstring, c: cint): cstring
proc SDL_strstr*(haystack, needle: cstring): cstring
proc SDL_strnstr*(haystack, needle: cstring, maxlen: csize_t): cstring
proc SDL_strcasestr*(haystack, needle: cstring): cstring
proc SDL_strtok_r*(s1, s2: cstring, saveptr: ptr cstring): cstring
proc SDL_utf8strlen*(str: cstring): csize_t
proc SDL_utf8strnlen*(str: cstring, bytes: csize_t): csize_t
proc SDL_snprintf*(text: cstring, maxlen: csize_t, fmt: cstring): cint {.varargs.}
proc SDL_swprintf*(text: ptr uint16, maxlen: csize_t, fmt: ptr uint16): cint {.varargs.}
proc SDL_asprintf*(strp: ptr cstring, fmt: cstring): cint {.varargs.}
proc SDL_sscanf*(text, fmt: cstring): cint {.varargs.}
proc SDL_atoi*(str: cstring): cint
proc SDL_atof*(str: cstring): cdouble
proc SDL_strtol*(str, endp: cstring, base: cint): clong
proc SDL_strtoul*(str, endp: cstring, base: cint): culong
proc SDL_strtoll*(str, endp: cstring, base: cint): clonglong
proc SDL_strtoull*(str, endp: cstring, base: cint): culonglong
proc SDL_strtod*(str, endp: cstring): cdouble
proc SDL_strcmp*(str1, str2: cstring): cint
proc SDL_strncmp*(str1, str2: cstring, maxlen: csize_t): cint
proc SDL_strcasecmp*(str1, str2: cstring): cint
proc SDL_strncasecmp*(str1, str2: cstring, maxlen: csize_t): cint

{.pop.}


# =============================================================================
# End of SDL3 Wrapper for Nim
# =============================================================================
##
## This wrapper covers the major subsystems of SDL3 including:
## - Initialization and Configuration
## - Error Handling and Logging
## - Properties System
## - Geometry (Points, Rects)  
## - Pixels and Surfaces
## - Video (Displays, Windows, OpenGL)
## - Rendering (2D rendering, textures)
## - Input (Keyboard, Mouse, Joystick, Gamepad)
## - Events and Event Handling
## - Audio (Playback, Recording, Streams)
## - Timer and High-Resolution Timing
## - Threading (Threads, Mutexes, Semaphores, Conditions, RWLocks)
## - File I/O and Async I/O
## - Clipboard
## - Filesystem Operations
## - CPU Information
## - Platform Detection
## - Power Management
## - Locale Support
## - Hints System
## - Memory Management
##
## Additional subsystems available in SDL3 but not included in this wrapper:
## - GPU (Modern 3D graphics API)
## - Haptic/Force Feedback
## - Sensors (Accelerometer, Gyroscope)
## - Touch and Pen Input
## - Camera
## - Message Boxes and Dialogs
## - HID API
## - Process Management
## - Storage API
## - Tray Icons
## - Atomic Operations
## - Assertions
##
## For complete documentation, please refer to:
## https://wiki.libsdl.org/SDL3/FrontPage
##
## Usage example:
##
## ```nim
## import libSDL
##
## if SDL_Init(SDL_INIT_VIDEO) == SDL_FALSE:
##   echo "SDL_Init Error: ", SDL_GetError()
##   quit(1)
##
## let window = SDL_CreateWindow("Hello SDL3", 800, 600, SDL_WINDOW_RESIZABLE)
## if window.isNil:
##   echo "SDL_CreateWindow Error: ", SDL_GetError()
##   SDL_Quit()
##   quit(1)
##
## let renderer = SDL_CreateRenderer(window, nil)
## if renderer.isNil:
##   echo "SDL_CreateRenderer Error: ", SDL_GetError()
##   SDL_DestroyWindow(window)
##   SDL_Quit()
##   quit(1)
##
## var running = true
## var event: SdlEvent
##
## while running:
##   while SDL_PollEvent(addr event) == SDL_TRUE:
##     if event.type == SDL_EVENT_QUIT:
##       running = false
##
##   discard SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255)
##   discard SDL_RenderClear(renderer)
##   discard SDL_RenderPresent(renderer)
##   SDL_Delay(16)
##
## SDL_DestroyRenderer(renderer)
## SDL_DestroyWindow(window)
## SDL_Quit()
## ```








# ==============================================================================
# ДОПОЛНИТЕЛЬНЫЕ ФУНКЦИИ SDL3 - ДОБАВЛЕНЫ В ВЕРСИИ 0.2
# ==============================================================================

{.push importc, dynlib: LibName, cdecl.}

# =============================================================================
# Camera API (SDL_camera.h)
# =============================================================================

proc SDL_AcquireCameraFrame*(camera: SdlCamera, timestampNS: ptr uint64): SdlSurface
proc SDL_CloseCamera*(camera: SdlCamera)
proc SDL_GetCameraDriver*(index: cint): cstring
proc SDL_GetCameraFormat*(camera: SdlCamera, spec: ptr SdlAudioSpec): SdlBool
proc SDL_GetCameraID*(camera: SdlCamera): SdlCameraID
proc SDL_GetCameraName*(camera: SdlCamera): cstring
proc SDL_GetCameraPermissionState*(camera: SdlCamera): cint
proc SDL_GetCameraPosition*(camera: SdlCamera): cint
proc SDL_GetCameraProperties*(camera: SdlCamera): SdlPropertiesID
proc SDL_GetCameras*(count: ptr cint): ptr SdlCameraID
proc SDL_GetCameraSupportedFormats*(devid: SdlCameraID, count: ptr cint): ptr ptr SdlAudioSpec
proc SDL_GetCurrentCameraDriver*(): cstring
proc SDL_GetNumCameraDrivers*(): cint
proc SDL_OpenCamera*(instance_id: SdlCameraID, spec: ptr SdlAudioSpec): SdlCamera
proc SDL_ReleaseCameraFrame*(camera: SdlCamera, frame: SdlSurface)

# =============================================================================
# GPU API (SDL_gpu.h) — полная спецификация функций
# =============================================================================

proc SDL_AcquireGPUCommandBuffer*(device: SdlGpuDevice): SdlGpuCommandBuffer
proc SDL_AcquireGPUSwapchainTexture*(command_buffer: SdlGpuCommandBuffer, window: SdlWindow, swapchain_texture: ptr SdlGpuTexture, swapchain_texture_width: ptr uint32, swapchain_texture_height: ptr uint32): SdlBool
proc SDL_BeginGPUComputePass*(command_buffer: SdlGpuCommandBuffer, storage_texture_bindings: ptr pointer, num_storage_texture_bindings: uint32, storage_buffer_bindings: ptr pointer, num_storage_buffer_bindings: uint32): SdlGpuComputePass
proc SDL_BeginGPUCopyPass*(command_buffer: SdlGpuCommandBuffer): SdlGpuCopyPass
proc SDL_BeginGPURenderPass*(command_buffer: SdlGpuCommandBuffer, color_target_infos: ptr pointer, num_color_targets: uint32, depth_stencil_target_info: pointer): SdlGpuRenderPass
proc SDL_BindGPUComputePipeline*(compute_pass: SdlGpuComputePass, compute_pipeline: SdlGpuComputePipeline)
proc SDL_BindGPUComputeSamplers*(compute_pass: SdlGpuComputePass, first_slot: uint32, samplers: ptr SdlGpuSampler, num_samplers: uint32)
proc SDL_BindGPUComputeStorageBuffers*(compute_pass: SdlGpuComputePass, first_slot: uint32, storage_buffers: ptr SdlGpuBuffer, num_storage_buffers: uint32)
proc SDL_BindGPUComputeStorageTextures*(compute_pass: SdlGpuComputePass, first_slot: uint32, storage_textures: ptr SdlGpuTexture, num_storage_textures: uint32)
proc SDL_BindGPUFragmentSamplers*(render_pass: SdlGpuRenderPass, first_slot: uint32, samplers: ptr SdlGpuSampler, num_samplers: uint32)
proc SDL_BindGPUFragmentStorageBuffers*(render_pass: SdlGpuRenderPass, first_slot: uint32, storage_buffers: ptr SdlGpuBuffer, num_storage_buffers: uint32)
proc SDL_BindGPUFragmentStorageTextures*(render_pass: SdlGpuRenderPass, first_slot: uint32, storage_textures: ptr SdlGpuTexture, num_storage_textures: uint32)
proc SDL_BindGPUGraphicsPipeline*(render_pass: SdlGpuRenderPass, graphics_pipeline: SdlGpuGraphicsPipeline)
proc SDL_BindGPUIndexBuffer*(render_pass: SdlGpuRenderPass, buffer_binding: pointer, index_element_size: cint)
proc SDL_BindGPUVertexBuffers*(render_pass: SdlGpuRenderPass, first_slot: uint32, buffer_bindings: ptr pointer, num_bindings: uint32)
proc SDL_BindGPUVertexSamplers*(render_pass: SdlGpuRenderPass, first_slot: uint32, samplers: ptr SdlGpuSampler, num_samplers: uint32)
proc SDL_BindGPUVertexStorageBuffers*(render_pass: SdlGpuRenderPass, first_slot: uint32, storage_buffers: ptr SdlGpuBuffer, num_storage_buffers: uint32)
proc SDL_BindGPUVertexStorageTextures*(render_pass: SdlGpuRenderPass, first_slot: uint32, storage_textures: ptr SdlGpuTexture, num_storage_textures: uint32)
proc SDL_BlitGPUTexture*(command_buffer: SdlGpuCommandBuffer, info: pointer): SdlBool
proc SDL_CalculateGPUTextureFormatSize*(format: cint, width, height, depth_or_array_layers: uint32, bytes_per_row: ptr uint32, bytes_per_image: ptr uint32): SdlBool
proc SDL_CancelGPUCommandBuffer*(command_buffer: SdlGpuCommandBuffer)
proc SDL_ClaimWindowForGPUDevice*(device: SdlGpuDevice, window: SdlWindow): SdlBool
proc SDL_CopyGPUBufferToBuffer*(copy_pass: SdlGpuCopyPass, source: pointer, destination: pointer, cycle: SdlBool)
proc SDL_CopyGPUTextureToTexture*(copy_pass: SdlGpuCopyPass, source: pointer, destination: pointer, cycle: SdlBool)
proc SDL_CreateGPUBuffer*(device: SdlGpuDevice, usage: uint32, size: uint32): SdlGpuBuffer
proc SDL_CreateGPUComputePipeline*(device: SdlGpuDevice, createinfo: pointer): SdlGpuComputePipeline
proc SDL_CreateGPUDevice*(format_flags: uint32, debug_mode: SdlBool, name: cstring): SdlGpuDevice
proc SDL_CreateGPUDeviceWithProperties*(props: SdlPropertiesID): SdlGpuDevice
proc SDL_CreateGPUGraphicsPipeline*(device: SdlGpuDevice, createinfo: pointer): SdlGpuGraphicsPipeline
proc SDL_CreateGPUSampler*(device: SdlGpuDevice, createinfo: pointer): SdlGpuSampler
proc SDL_CreateGPUShader*(device: SdlGpuDevice, createinfo: pointer): SdlGpuShader
proc SDL_CreateGPUTexture*(device: SdlGpuDevice, createinfo: pointer): SdlGpuTexture
proc SDL_CreateGPUTransferBuffer*(device: SdlGpuDevice, usage: uint32, size: uint32): SdlGpuTransferBuffer
proc SDL_DestroyGPUDevice*(device: SdlGpuDevice)
proc SDL_DispatchGPUCompute*(compute_pass: SdlGpuComputePass, groupcount_x, groupcount_y, groupcount_z: uint32)
proc SDL_DispatchGPUComputeIndirect*(compute_pass: SdlGpuComputePass, buffer: SdlGpuBuffer, offset: uint32)
proc SDL_DownloadFromGPUBuffer*(copy_pass: SdlGpuCopyPass, source: pointer, destination: pointer)
proc SDL_DownloadFromGPUTexture*(copy_pass: SdlGpuCopyPass, source: pointer, destination: pointer)
proc SDL_DrawGPUIndexedPrimitives*(render_pass: SdlGpuRenderPass, num_indices: uint32, num_instances, first_index, vertex_offset: uint32, first_instance: uint32)
proc SDL_DrawGPUIndexedPrimitivesIndirect*(render_pass: SdlGpuRenderPass, buffer: SdlGpuBuffer, offset: uint32, draw_count: uint32, pitch: uint32)
proc SDL_DrawGPUPrimitives*(render_pass: SdlGpuRenderPass, num_vertices: uint32, num_instances, first_vertex, first_instance: uint32)
proc SDL_DrawGPUPrimitivesIndirect*(render_pass: SdlGpuRenderPass, buffer: SdlGpuBuffer, offset: uint32, draw_count: uint32, pitch: uint32)
proc SDL_EndGPUComputePass*(compute_pass: SdlGpuComputePass)
proc SDL_EndGPUCopyPass*(copy_pass: SdlGpuCopyPass)
proc SDL_EndGPURenderPass*(render_pass: SdlGpuRenderPass)
proc SDL_GenerateMipmapsForGPUTexture*(command_buffer: SdlGpuCommandBuffer, texture: SdlGpuTexture)
proc SDL_GetGPUDeviceDriver*(device: SdlGpuDevice): cstring
proc SDL_GetGPUDriver*(index: cint): cstring
proc SDL_GetGPUSwapchainTextureFormat*(device: SdlGpuDevice, window: SdlWindow): cint
proc SDL_GetNumGPUDrivers*(): cint
proc SDL_InsertGPUDebugLabel*(command_buffer: SdlGpuCommandBuffer, text: cstring)
proc SDL_MapGPUTransferBuffer*(device: SdlGpuDevice, transfer_buffer: SdlGpuTransferBuffer, cycle: SdlBool): pointer
proc SDL_PopGPUDebugGroup*(command_buffer: SdlGpuCommandBuffer)
proc SDL_PushGPUComputeUniformData*(command_buffer: SdlGpuCommandBuffer, slot_index: uint32, data: pointer, length: uint32)
proc SDL_PushGPUDebugGroup*(command_buffer: SdlGpuCommandBuffer, name: cstring)
proc SDL_PushGPUFragmentUniformData*(command_buffer: SdlGpuCommandBuffer, slot_index: uint32, data: pointer, length: uint32)
proc SDL_PushGPUVertexUniformData*(command_buffer: SdlGpuCommandBuffer, slot_index: uint32, data: pointer, length: uint32)
proc SDL_QueryGPUFence*(device: SdlGpuDevice, fence: SdlGpuFence): SdlBool
proc SDL_ReleaseGPUBuffer*(device: SdlGpuDevice, buffer: SdlGpuBuffer)
proc SDL_ReleaseGPUComputePipeline*(device: SdlGpuDevice, compute_pipeline: SdlGpuComputePipeline)
proc SDL_ReleaseGPUFence*(device: SdlGpuDevice, fence: SdlGpuFence)
proc SDL_ReleaseGPUGraphicsPipeline*(device: SdlGpuDevice, graphics_pipeline: SdlGpuGraphicsPipeline)
proc SDL_ReleaseGPUSampler*(device: SdlGpuDevice, sampler: SdlGpuSampler)
proc SDL_ReleaseGPUShader*(device: SdlGpuDevice, shader: SdlGpuShader)
proc SDL_ReleaseGPUTexture*(device: SdlGpuDevice, texture: SdlGpuTexture)
proc SDL_ReleaseGPUTransferBuffer*(device: SdlGpuDevice, transfer_buffer: SdlGpuTransferBuffer)
proc SDL_ReleaseWindowFromGPUDevice*(device: SdlGpuDevice, window: SdlWindow)
proc SDL_SetGPUAllowedFramesInFlight*(device: SdlGpuDevice, allowed_frames_in_flight: uint32)
proc SDL_SetGPUBlendConstants*(render_pass: SdlGpuRenderPass, color: SdlFColor)
proc SDL_SetGPUBufferName*(device: SdlGpuDevice, buffer: SdlGpuBuffer, text: cstring)
proc SDL_SetGPUScissor*(render_pass: SdlGpuRenderPass, scissor: ptr SdlRect)
proc SDL_SetGPUStencilReference*(render_pass: SdlGpuRenderPass, reference: uint8)
proc SDL_SetGPUSwapchainParameters*(device: SdlGpuDevice, window: SdlWindow, swapchain_composition: cint, present_mode: cint): SdlBool
proc SDL_SetGPUTextureName*(device: SdlGpuDevice, texture: SdlGpuTexture, text: cstring)
proc SDL_SetGPUViewport*(render_pass: SdlGpuRenderPass, viewport: pointer)
proc SDL_SubmitGPUCommandBuffer*(command_buffer: SdlGpuCommandBuffer): SdlBool
proc SDL_SubmitGPUCommandBufferAndAcquireFence*(command_buffer: SdlGpuCommandBuffer): SdlGpuFence
proc SDL_SupportsGPUPresentMode*(device: SdlGpuDevice, window: SdlWindow, present_mode: cint): SdlBool
proc SDL_SupportsGPUTextureFormat*(device: SdlGpuDevice, format: cint, `type`: cint, usage: uint32): SdlBool
proc SDL_UnmapGPUTransferBuffer*(device: SdlGpuDevice, transfer_buffer: SdlGpuTransferBuffer)
proc SDL_UploadToGPUBuffer*(copy_pass: SdlGpuCopyPass, source: pointer, destination: pointer, cycle: SdlBool)
proc SDL_UploadToGPUTexture*(copy_pass: SdlGpuCopyPass, source: pointer, destination: pointer, cycle: SdlBool)
proc SDL_WaitAndAcquireGPUSwapchainTexture*(command_buffer: SdlGpuCommandBuffer, window: SdlWindow, swapchain_texture: ptr SdlGpuTexture, swapchain_texture_width: ptr uint32, swapchain_texture_height: ptr uint32): SdlBool
proc SDL_WaitForGPUFences*(device: SdlGpuDevice, wait_all: SdlBool, fences: ptr SdlGpuFence, num_fences: uint32): SdlBool
proc SDL_WaitForGPUIdle*(device: SdlGpuDevice): SdlBool
proc SDL_WaitForGPUSwapchain*(device: SdlGpuDevice, window: SdlWindow): SdlBool
proc SDL_WindowSupportsGPUPresentMode*(device: SdlGpuDevice, window: SdlWindow, present_mode: cint): SdlBool
proc SDL_WindowSupportsGPUSwapchainComposition*(device: SdlGpuDevice, window: SdlWindow, swapchain_composition: cint): SdlBool
proc SDL_GetGPUDeviceProperties*(device: SdlGpuDevice): SdlPropertiesID

# =============================================================================
# Atomic Operations (SDL_atomic.h)
# =============================================================================

proc SDL_AddAtomicInt*(a: ptr SdlAtomicInt, v: cint): cint
proc SDL_AddAtomicU32*(a: ptr SdlAtomicU32, v: uint32): uint32
proc SDL_CompareAndSwapAtomicInt*(a: ptr SdlAtomicInt, oldval, newval: cint): SdlBool
proc SDL_CompareAndSwapAtomicPointer*(a: ptr pointer, oldval, newval: pointer): SdlBool
proc SDL_CompareAndSwapAtomicU32*(a: ptr SdlAtomicU32, oldval, newval: uint32): SdlBool
proc SDL_GetAtomicInt*(a: ptr SdlAtomicInt): cint
proc SDL_GetAtomicPointer*(a: ptr pointer): pointer
proc SDL_GetAtomicU32*(a: ptr SdlAtomicU32): uint32
proc SDL_SetAtomicInt*(a: ptr SdlAtomicInt, v: cint): cint
proc SDL_SetAtomicPointer*(a: ptr pointer, v: pointer): pointer
proc SDL_SetAtomicU32*(a: ptr SdlAtomicU32, v: uint32): uint32

# =============================================================================
# Thread Synchronization (SDL_mutex.h, SDL_thread.h)
# =============================================================================

proc SDL_BroadcastCondition*(cond: SdlCondition): SdlBool
proc SDL_SignalCondition*(cond: SdlCondition): SdlBool
proc SDL_TryLockSpinlock*(lock: ptr SdlSpinLock): SdlBool
proc SDL_UnlockSpinlock*(lock: ptr SdlSpinLock)
proc SDL_WaitCondition*(cond: SdlCondition, mutex: SdlMutex): SdlBool
proc SDL_WaitSemaphore*(sem: SdlSemaphore): SdlBool
proc SDL_SignalSemaphore*(sem: SdlSemaphore): SdlBool
proc SDL_LockRWLockForReading*(rwlock: SdlRWLock): SdlBool
proc SDL_LockRWLockForWriting*(rwlock: SdlRWLock): SdlBool
proc SDL_LockMutex*(mutex: SdlMutex): SdlBool
proc SDL_LockSpinlock*(lock: ptr SdlSpinLock)

# =============================================================================
# Extended Audio Functions (SDL_audio.h)
# =============================================================================

proc SDL_AudioStreamDevicePaused*(stream: SdlAudioStream): SdlBool
proc SDL_SetAudioPostmixCallback*(devid: SdlAudioDeviceID, callback: pointer, userdata: pointer): SdlBool
proc SDL_SetAudioStreamGetCallback*(stream: SdlAudioStream, callback: pointer, userdata: pointer): SdlBool
proc SDL_SetAudioStreamPutCallback*(stream: SdlAudioStream, callback: pointer, userdata: pointer): SdlBool
proc SDL_UnlockAudioStream*(stream: SdlAudioStream)

# =============================================================================
# Haptic (Force Feedback) Extended Functions  
# =============================================================================

proc SDL_CloseHaptic*(haptic: SdlHaptic)
proc SDL_CreateHapticEffect*(haptic: SdlHaptic, effect: pointer): cint
proc SDL_DestroyHapticEffect*(haptic: SdlHaptic, effect: cint)
proc SDL_RunHapticEffect*(haptic: SdlHaptic, effect: cint, iterations: uint32): SdlBool
proc SDL_StopHapticEffect*(haptic: SdlHaptic, effect: cint): SdlBool
proc SDL_StopHapticEffects*(haptic: SdlHaptic): SdlBool
proc SDL_StopHapticRumble*(haptic: SdlHaptic): SdlBool
proc SDL_UpdateHapticEffect*(haptic: SdlHaptic, effect: cint, data: pointer): SdlBool

# =============================================================================
# Timer Functions (SDL_timer.h)
# =============================================================================

proc SDL_AddTimer*(interval: uint32, callback: pointer, userdata: pointer): SdlTimerID
proc SDL_AddTimerNS*(interval: uint64, callback: pointer, userdata: pointer): SdlTimerID

# =============================================================================
# Hints (SDL_hints.h)
# =============================================================================

proc SDL_AddHintCallback*(name: cstring, callback: pointer, userdata: pointer): SdlBool
proc SDL_RemoveHintCallback*(name: cstring, callback: pointer, userdata: pointer)
proc SDL_SetHintWithPriority*(name, value: cstring, priority: cint): SdlBool


# =============================================================================
# Clipboard (SDL_clipboard.h)
# =============================================================================

proc SDL_SetClipboardData*(callback: pointer, cleanup: pointer, userdata: pointer, mime_types: cstringArray, num_mime_types: csize_t): SdlBool


# =============================================================================
# File I/O Extended (SDL_iostream.h)
# =============================================================================

proc SDL_AsyncIOFromFile*(file: cstring, mode: cstring): SdlAsyncIO
proc SDL_CloseAsyncIO*(asyncio: SdlAsyncIO): SdlBool
proc SDL_CreateAsyncIOQueue*(): SdlAsyncIOQueue
proc SDL_DestroyAsyncIOQueue*(queue: SdlAsyncIOQueue)
proc SDL_GetAsyncIOResult*(asyncio: SdlAsyncIO, result: ptr Sint64): SdlBool
proc SDL_GetAsyncIOSize*(asyncio: SdlAsyncIO): Sint64
proc SDL_ReadAsyncIO*(asyncio: SdlAsyncIO, `ptr`: pointer, offset: uint64, size: uint64, queue: SdlAsyncIOQueue, userdata: pointer): SdlBool
proc SDL_SaveFile_IO*(src: SdlIOStream, file: cstring, closeio: SdlBool): SdlBool
proc SDL_SaveFile*(filename: cstring, data: pointer, datasize: csize_t): SdlBool
proc SDL_SeekIO*(context: SdlIOStream, offset: Sint64, whence: cint): Sint64
proc SDL_SignalAsyncIOQueue*(queue: SdlAsyncIOQueue)
proc SDL_WaitAsyncIOResult*(asyncio: SdlAsyncIO, result: ptr Sint64, timeoutMS: Sint32): SdlBool
proc SDL_WriteAsyncIO*(asyncio: SdlAsyncIO, `ptr`: pointer, offset: uint64, size: uint64, queue: SdlAsyncIOQueue, userdata: pointer): SdlBool


# =============================================================================
# Storage (SDL_storage.h)
# =============================================================================

proc SDL_CloseStorage*(storage: SdlStorage): SdlBool
proc SDL_CopyStorageFile*(storage: SdlStorage, oldpath, newpath: cstring): SdlBool
proc SDL_CreateStorageDirectory*(storage: SdlStorage, path: cstring): SdlBool
proc SDL_EnumerateStorageDirectory*(storage: SdlStorage, path: cstring, callback: pointer, userdata: pointer): SdlBool
proc SDL_GetStorageFileSize*(storage: SdlStorage, path: cstring, length: ptr uint64): SdlBool
proc SDL_GetStoragePathInfo*(storage: SdlStorage, path: cstring, info: pointer): SdlBool
proc SDL_GetStorageSpaceRemaining*(storage: SdlStorage): uint64
proc SDL_OpenFileStorage*(path: cstring): SdlStorage
proc SDL_OpenStorage*(iface: pointer, userdata: pointer): SdlStorage
proc SDL_OpenTitleStorage*(override: cstring, props: SdlPropertiesID): SdlStorage
proc SDL_OpenUserStorage*(org, app: cstring, props: SdlPropertiesID): SdlStorage
proc SDL_ReadStorageFile*(storage: SdlStorage, path: cstring, destination: pointer, length: uint64): SdlBool
proc SDL_RemoveStoragePath*(storage: SdlStorage, path: cstring): SdlBool
proc SDL_RenameStoragePath*(storage: SdlStorage, oldpath, newpath: cstring): SdlBool
proc SDL_StorageReady*(storage: SdlStorage): SdlBool
proc SDL_WriteStorageFile*(storage: SdlStorage, path: cstring, source: pointer, length: uint64): SdlBool

# =============================================================================
# Date and Time (SDL_time.h)
# =============================================================================

proc SDL_DateTimeToTime*(dt: ptr SdlDateTime, ticks: ptr Sint64): SdlBool
proc SDL_GetCurrentTime*(ticks: ptr Sint64): SdlBool
proc SDL_GetDateTimeLocalePreferences*(dateFormat, timeFormat: ptr cint): SdlBool
proc SDL_GetDayOfWeek*(year, month, day: cint): cint
proc SDL_GetDayOfYear*(year, month, day: cint): cint
proc SDL_GetDaysInMonth*(year, month: cint): cint
proc SDL_TimeFromWindows*(dwLowDateTime, dwHighDateTime: uint32): Sint64
proc SDL_TimeToDateTime*(ticks: Sint64, dt: ptr SdlDateTime, localTime: SdlBool): SdlBool
proc SDL_TimeToWindows*(ticks: Sint64, dwLowDateTime, dwHighDateTime: ptr uint32)

# =============================================================================
# Process and Environment (SDL_process.h)
# =============================================================================

proc SDL_CreateProcess*(args: cstringArray, pipe_stdio: SdlBool): SdlProcess
proc SDL_CreateProcessWithProperties*(props: SdlPropertiesID): SdlProcess
proc SDL_DestroyProcess*(process: SdlProcess)
proc SDL_GetProcessInput*(process: SdlProcess): SdlIOStream
proc SDL_GetProcessOutput*(process: SdlProcess): SdlIOStream
proc SDL_GetProcessProperties*(process: SdlProcess): SdlPropertiesID
proc SDL_KillProcess*(process: SdlProcess, force: SdlBool): SdlBool
proc SDL_ReadProcess*(process: SdlProcess, datasize: ptr csize_t, exitcode: ptr cint): pointer
proc SDL_WaitProcess*(process: SdlProcess, blk: SdlBool, exitcode: ptr cint): SdlBool

# =============================================================================
# Tray Icon (SDL_tray.h)
# =============================================================================

proc SDL_ClickTrayEntry*(entry: SdlTrayEntry)
proc SDL_CreateTray*(icon: SdlSurface, tooltip: cstring): SdlTray
proc SDL_CreateTrayEntry*(menu: SdlTrayMenu, label: cstring, flags: uint32): SdlTrayEntry
proc SDL_CreateTrayMenu*(tray: SdlTray): SdlTrayMenu
proc SDL_CreateTraySubmenu*(entry: SdlTrayEntry): SdlTrayMenu
proc SDL_DestroyTray*(tray: SdlTray)
proc SDL_GetTrayEntries*(menu: SdlTrayMenu, size: ptr cint): ptr SdlTrayEntry
proc SDL_GetTrayEntry*(menu: SdlTrayMenu, pos: cint): SdlTrayEntry
proc SDL_GetTrayMenu*(tray: SdlTray): SdlTrayMenu
proc SDL_GetTraySubmenu*(entry: SdlTrayEntry): SdlTrayMenu
proc SDL_InsertTrayEntryAt*(menu: SdlTrayMenu, pos: cint, label: cstring, flags: uint32): SdlTrayEntry
proc SDL_RemoveTrayEntry*(entry: SdlTrayEntry)
proc SDL_SetTrayEntryCallback*(entry: SdlTrayEntry, callback: pointer, userdata: pointer)
proc SDL_SetTrayEntryChecked*(entry: SdlTrayEntry, checked: SdlBool)
proc SDL_SetTrayEntryEnabled*(entry: SdlTrayEntry, enabled: SdlBool)
proc SDL_SetTrayEntryLabel*(entry: SdlTrayEntry, label: cstring)
proc SDL_SetTrayIcon*(tray: SdlTray, icon: SdlSurface)
proc SDL_SetTrayTooltip*(tray: SdlTray, tooltip: cstring)
proc SDL_UpdateTrays*()


# =============================================================================
# TLS (Thread Local Storage)
# =============================================================================

proc SDL_GetTLS*(id: SdlTLSID): pointer
proc SDL_SetTLS*(id: ptr SdlTLSID, value: pointer, destructor: pointer): SdlBool


# =============================================================================
# Thread Extended Functions
# =============================================================================

proc SDL_CreateThread*(fn: pointer, name: cstring, data: pointer): SdlThread
proc SDL_CreateThreadRuntime*(fn: pointer, name: cstring, data: pointer, pfnBeginThread: pointer, pfnEndThread: pointer): SdlThread
proc SDL_CreateThreadWithPropertiesRuntime*(props: SdlPropertiesID, pfnBeginThread: pointer, pfnEndThread: pointer): SdlThread
proc SDL_SetCurrentThreadPriority*(priority: cint): SdlBool
proc SDL_SetThreadPriority*(priority: cint): SdlBool


# =============================================================================
# Filesystem (SDL_filesystem.h)
# =============================================================================

proc SDL_EnumerateDirectory*(path: cstring, callback: pointer, userdata: pointer): SdlBool
proc SDL_GetPathInfo*(path: cstring, info: pointer): SdlBool
proc SDL_GetUserFolder*(folder: cint): cstring
proc SDL_GlobDirectory*(path, pattern: cstring, flags: uint32, count: ptr cint): cstringArray


# =============================================================================
# Dialog (SDL_dialog.h)
# =============================================================================

proc SDL_ShowFileDialogWithProperties*(`type`: cint, callback: pointer, userdata: pointer, props: SdlPropertiesID)
proc SDL_ShowOpenFileDialog*(callback: pointer, userdata: pointer, window: SdlWindow, filters: pointer, nfilters: cint, default_location: cstring, allow_many: SdlBool)
proc SDL_ShowOpenFolderDialog*(callback: pointer, userdata: pointer, window: SdlWindow, default_location: cstring, allow_many: SdlBool)
proc SDL_ShowSaveFileDialog*(callback: pointer, userdata: pointer, window: SdlWindow, filters: pointer, nfilters: cint, default_location: cstring)
proc SDL_ShowMessageBox*(messageboxdata: pointer, buttonid: ptr cint): SdlBool
proc SDL_ShowSimpleMessageBox*(flags: uint32, title, message: cstring, window: SdlWindow): SdlBool


# =============================================================================
# Memory Management
# =============================================================================

proc SDL_aligned_alloc*(alignment, size: csize_t): pointer
proc SDL_aligned_free*(`mem`: pointer)


# =============================================================================
# Platform Specific Functions
# =============================================================================

proc SDL_GetAndroidActivity*(): pointer
proc SDL_GetAndroidCachePath*(): cstring
proc SDL_GetAndroidExternalStoragePath*(): cstring
proc SDL_GetAndroidExternalStorageState*(): uint32
proc SDL_GetAndroidInternalStoragePath*(): cstring
proc SDL_GetAndroidJNIEnv*(): pointer
proc SDL_GetAndroidSDKVersion*(): cint
proc SDL_IsAndroidTV*(): SdlBool
proc SDL_IsChromebook*(): SdlBool
proc SDL_IsDeXMode*(): SdlBool
proc SDL_IsTablet*(): SdlBool
proc SDL_RequestAndroidPermission*(permission: cstring, cb: pointer, userdata: pointer): SdlBool
proc SDL_SendAndroidBackButton*(): SdlBool
proc SDL_SendAndroidMessage*(command: cint, param: cint): SdlBool
proc SDL_ShowAndroidToast*(message: cstring, duration, gravity, xoffset, yoffset: cint): SdlBool
proc SDL_SetiOSAnimationCallback*(window: SdlWindow, interval: cint, callback: pointer, callbackParam: pointer): SdlBool
proc SDL_SetiOSEventPump*(enabled: SdlBool)
proc SDL_GetDirect3D9AdapterIndex*(displayID: SdlDisplayID): cint
proc SDL_GetDXGIOutputInfo*(displayID: SdlDisplayID, adapterIndex, outputIndex: ptr cint): SdlBool
proc SDL_GDKResumeGPU*(device: SdlGpuDevice): SdlBool
proc SDL_GDKSuspendComplete*()
proc SDL_GDKSuspendGPU*(device: SdlGpuDevice)
proc SDL_GetGDKDefaultUser*(outUserHandle: ptr pointer): SdlBool
proc SDL_GetGDKTaskQueue*(outTaskQueue: ptr pointer): SdlBool
proc SDL_LinuxSetThreadPriority*(threadID: Sint64, priority: cint): SdlBool
proc SDL_LinuxSetThreadPriorityAndPolicy*(threadID: Sint64, sdlPriority, schedPolicy: cint): SdlBool
proc SDL_SetLinuxThreadPriority*(threadID: Sint64, priority: cint): SdlBool
proc SDL_SetLinuxThreadPriorityAndPolicy*(threadID: Sint64, sdlPriority, schedPolicy: cint): SdlBool
proc SDL_SetWindowsMessageHook*(callback: pointer, userdata: pointer)
proc SDL_SetX11EventHook*(callback: pointer, userdata: pointer)
proc SDL_RegisterApp*(name: cstring, style: uint32, hInst: pointer): SdlBool
proc SDL_UnregisterApp*()

# =============================================================================
# Vulkan Functions
# =============================================================================

proc SDL_Vulkan_CreateSurface*(window: SdlWindow, instance: pointer, allocator: pointer, surface: pointer): SdlBool
proc SDL_Vulkan_DestroySurface*(instance: pointer, surface: pointer, allocator: pointer)
proc SDL_Vulkan_GetInstanceExtensions*(count: ptr uint32): cstringArray
proc SDL_Vulkan_GetPresentationSupport*(instance: pointer, physicalDevice: pointer, queueFamilyIndex: uint32): SdlBool
proc SDL_Vulkan_GetVkGetInstanceProcAddr*(): pointer
proc SDL_Vulkan_LoadLibrary*(path: cstring): SdlBool
proc SDL_Vulkan_UnloadLibrary*()


# =============================================================================
# Main Loop and Events
# =============================================================================

proc SDL_EnterAppMainCallbacks*(argc: cint, argv: cstringArray, appinit_func: pointer, appiter_func: pointer, appevent_func: pointer, appquit_func: pointer): cint
proc SDL_RunApp*(argc: cint, argv: cstringArray, mainFunction: pointer, reserved: pointer): cint
proc SDL_RunOnMainThread*(fn: pointer, userdata: pointer, wait_complete: SdlBool): SdlBool


# =============================================================================
# Miscellaneous Functions
# =============================================================================

proc SDL_IsScreenKeyboardShown*(window: SdlWindow): SdlBool
proc SDL_LoadObject*(sofile: cstring): pointer
proc SDL_LoadFunction*(`handle`: pointer, name: cstring): pointer
proc SDL_UnloadObject*(`handle`: pointer)
proc SDL_GetDefaultAssertionHandler*(): pointer
proc SDL_GetAssertionHandler*(userdata: ptr pointer): pointer
proc SDL_GetAssertionReport*(): pointer
proc SDL_ReportAssertion*(data: pointer, cmd, file: cstring, line: cint): cint
proc SDL_ResetAssertionReport*()
proc SDL_SetAssertionHandler*(handler: pointer, userdata: pointer)

{.pop.}










# SDL_ttf - TrueType Font Rendering (SDL3_ttf 3.0+)
# =============================================================================

when defined(windows):
  const TTF_LibName* = "SDL3_ttf.dll"
elif defined(macosx):
  const TTF_LibName* = "libSDL3_ttf.dylib"
else:
  const TTF_LibName* = "libSDL3_ttf.so(|.0)"

type
  # Opaque types
  TTF_Font* = ptr object
  TTF_Text* = ptr object
  TTF_TextEngine* = ptr object
  TTF_SubString* = ptr object
  
  # Font direction
  TTF_Direction* {.size: sizeof(cint).} = enum
    TTF_DIRECTION_LTR = 0  # Left to Right
    TTF_DIRECTION_RTL      # Right to Left  
    TTF_DIRECTION_TTB      # Top to Bottom
    TTF_DIRECTION_BTT      # Bottom to Top
  
  # Horizontal alignment
  TTF_HorizontalAlignment* {.size: sizeof(cint).} = enum
    TTF_HORIZONTAL_ALIGN_INVALID = -1
    TTF_HORIZONTAL_ALIGN_LEFT = 0
    TTF_HORIZONTAL_ALIGN_CENTER
    TTF_HORIZONTAL_ALIGN_RIGHT
  
  # Vertical alignment  
  TTF_VerticalAlignment* {.size: sizeof(cint).} = enum
    TTF_VERTICAL_ALIGN_INVALID = -1
    TTF_VERTICAL_ALIGN_TOP = 0
    TTF_VERTICAL_ALIGN_MIDDLE
    TTF_VERTICAL_ALIGN_BOTTOM

{.push importc, dynlib: TTF_LibName, cdecl.}

# =============================================================================
# Initialization
# =============================================================================

proc TTF_Init*(): bool
proc TTF_Quit*()
proc TTF_WasInit*(): bool
proc TTF_Version*(): cint

proc TTF_GetFreeTypeVersion*(major, minor, patch: ptr cint)
proc TTF_GetHarfBuzzVersion*(major, minor, patch: ptr cint)

# =============================================================================
# Font Loading
# =============================================================================

proc TTF_OpenFont*(file: cstring, ptsize: cfloat): TTF_Font
proc TTF_OpenFontIO*(src: SdlIOStream, closeio: bool, ptsize: cfloat): TTF_Font
proc TTF_OpenFontWithProperties*(props: SdlPropertiesID): TTF_Font

proc TTF_CloseFont*(font: TTF_Font)

# Font properties
proc TTF_SetFontSize*(font: TTF_Font, ptsize: cfloat): bool
proc TTF_GetFontSize*(font: TTF_Font): cfloat

# =============================================================================
# Font Properties
# =============================================================================

proc TTF_GetFontStyle*(font: TTF_Font): cint
proc TTF_SetFontStyle*(font: TTF_Font, style: cint)

proc TTF_GetFontOutline*(font: TTF_Font): cint
proc TTF_SetFontOutline*(font: TTF_Font, outline: cint): bool

proc TTF_GetFontHinting*(font: TTF_Font): cint
proc TTF_SetFontHinting*(font: TTF_Font, hinting: cint)

proc TTF_GetFontSDF*(font: TTF_Font): bool
proc TTF_SetFontSDF*(font: TTF_Font, enabled: bool): bool

proc TTF_SetFontDirection*(font: TTF_Font, direction: TTF_Direction): bool
proc TTF_SetFontScriptName*(font: TTF_Font, script: cstring): bool

proc TTF_GetFontKerning*(font: TTF_Font): bool
proc TTF_SetFontKerning*(font: TTF_Font, enabled: bool)

proc TTF_GetFontWrapAlignment*(font: TTF_Font): TTF_HorizontalAlignment
proc TTF_SetFontWrapAlignment*(font: TTF_Font, align: TTF_HorizontalAlignment)

# =============================================================================
# Font Metrics
# =============================================================================

proc TTF_GetFontHeight*(font: TTF_Font): cint
proc TTF_GetFontAscent*(font: TTF_Font): cint
proc TTF_GetFontDescent*(font: TTF_Font): cint
proc TTF_GetFontLineSkip*(font: TTF_Font): cint

proc TTF_FontHasGlyph*(font: TTF_Font, ch: uint32): bool

proc TTF_GetGlyphMetrics*(font: TTF_Font, ch: uint32, minx, maxx, miny, maxy, advance: ptr cint): bool

# =============================================================================
# Text Measurement
# =============================================================================

proc TTF_MeasureText*(font: TTF_Font, text: cstring, length: csize_t, measure_width: cint, 
                      extent: ptr cint, count: ptr csize_t): bool

proc TTF_MeasureString*(font: TTF_Font, text: cstring, length: csize_t, max_width: cint,
                        measured_width: ptr cint, measured_length: ptr csize_t): bool

proc TTF_GetTextSize*(font: TTF_Font, text: cstring, length: csize_t, w, h: ptr cint): bool
proc TTF_GetTextSizeWrapped*(font: TTF_Font, text: cstring, length: csize_t, 
                             wrapWidth: cint, w, h: ptr cint): bool

# =============================================================================
# Text Rendering to Surface (Legacy API)
# =============================================================================

proc TTF_RenderText_Solid*(font: TTF_Font, text: cstring, length: csize_t, fg: SdlColor): SdlSurface
proc TTF_RenderText_Shaded*(font: TTF_Font, text: cstring, length: csize_t, fg, bg: SdlColor): SdlSurface  
proc TTF_RenderText_Blended*(font: TTF_Font, text: cstring, length: csize_t, fg: SdlColor): SdlSurface
proc TTF_RenderText_LCD*(font: TTF_Font, text: cstring, length: csize_t, fg, bg: SdlColor): SdlSurface

proc TTF_RenderText_Solid_Wrapped*(font: TTF_Font, text: cstring, length: csize_t, 
                                   fg: SdlColor, wrapWidth: cint): SdlSurface
proc TTF_RenderText_Shaded_Wrapped*(font: TTF_Font, text: cstring, length: csize_t, 
                                    fg, bg: SdlColor, wrapWidth: cint): SdlSurface
proc TTF_RenderText_Blended_Wrapped*(font: TTF_Font, text: cstring, length: csize_t, 
                                     fg: SdlColor, wrapWidth: cint): SdlSurface
proc TTF_RenderText_LCD_Wrapped*(font: TTF_Font, text: cstring, length: csize_t, 
                                 fg, bg: SdlColor, wrapWidth: cint): SdlSurface

proc TTF_RenderGlyph_Solid*(font: TTF_Font, ch: uint32, fg: SdlColor): SdlSurface
proc TTF_RenderGlyph_Shaded*(font: TTF_Font, ch: uint32, fg, bg: SdlColor): SdlSurface
proc TTF_RenderGlyph_Blended*(font: TTF_Font, ch: uint32, fg: SdlColor): SdlSurface
proc TTF_RenderGlyph_LCD*(font: TTF_Font, ch: uint32, fg, bg: SdlColor): SdlSurface

# =============================================================================
# Text Engine API (New in SDL3_ttf)
# =============================================================================

proc TTF_CreateText*(engine: TTF_TextEngine, font: TTF_Font, text: cstring, length: csize_t): TTF_Text
proc TTF_GetTextEngine*(renderer: SdlRenderer): TTF_TextEngine
proc TTF_CreateSurfaceTextEngine*(): TTF_TextEngine
proc TTF_CreateRendererTextEngine*(renderer: SdlRenderer): TTF_TextEngine
proc TTF_DestroyTextEngine*(engine: TTF_TextEngine)

proc TTF_GetTextFont*(text: TTF_Text): TTF_Font
proc TTF_SetTextFont*(text: TTF_Text, font: TTF_Font): bool

proc TTF_SetTextColor*(text: TTF_Text, r, g, b, a: uint8): bool
proc TTF_SetTextColorFloat*(text: TTF_Text, r, g, b, a: cfloat): bool

proc TTF_SetTextString*(text: TTF_Text, str: cstring, length: csize_t): bool
proc TTF_InsertTextString*(text: TTF_Text, offset: cint, str: cstring, length: csize_t): bool
proc TTF_AppendTextString*(text: TTF_Text, str: cstring, length: csize_t): bool
proc TTF_DeleteTextString*(text: TTF_Text, offset: cint, length: csize_t): bool

proc TTF_SetTextWrapping*(text: TTF_Text, wrap: bool, wrapWidth: cint): bool

proc TTF_GetTextSize*(text: TTF_Text, w, h: ptr cint): bool

proc TTF_UpdateText*(text: TTF_Text): bool

proc TTF_DestroyText*(text: TTF_Text)

# =============================================================================
# Drawing Text
# =============================================================================

proc TTF_DrawRendererText*(text: TTF_Text, x, y: cfloat): bool
proc TTF_DrawSurfaceText*(text: TTF_Text, x, y: cint, surface: SdlSurface): bool

{.pop.}

# =============================================================================
# Helper Functions
# =============================================================================

proc initTTF*(): bool =
  ## Initialize SDL_ttf. Returns true on success.
  result = TTF_Init()
  if not result:
    echo "TTF_Init Error: ", SDL_GetError()

proc quitTTF*() =
  ## Shutdown SDL_ttf
  TTF_Quit()

proc loadFont*(filename: string, size: float): TTF_Font =
  ## Load a TrueType font from file with floating point size
  result = TTF_OpenFont(filename.cstring, size.cfloat)
  if result.isNil:
    echo "TTF_OpenFont Error: ", SDL_GetError()

proc renderTextSolid*(font: TTF_Font, text: string, color: SdlColor): SdlSurface =
  ## Render text using solid rendering (fastest, no anti-aliasing)
  result = TTF_RenderText_Solid(font, text.cstring, text.len.csize_t, color)
  if result.isNil:
    echo "TTF_RenderText_Solid Error: ", SDL_GetError()

proc renderTextBlended*(font: TTF_Font, text: string, color: SdlColor): SdlSurface =
  ## Render text using blended rendering (high quality, anti-aliased)
  result = TTF_RenderText_Blended(font, text.cstring, text.len.csize_t, color)
  if result.isNil:
    echo "TTF_RenderText_Blended Error: ", SDL_GetError()

proc renderTextShaded*(font: TTF_Font, text: string, fg, bg: SdlColor): SdlSurface =
  ## Render text using shaded rendering (anti-aliased with background)
  result = TTF_RenderText_Shaded(font, text.cstring, text.len.csize_t, fg, bg)
  if result.isNil:
    echo "TTF_RenderText_Shaded Error: ", SDL_GetError()

proc getTextSize*(font: TTF_Font, text: string): tuple[w, h: int] =
  ## Get the size of rendered text without actually rendering it
  ## Note: In SDL3_ttf, we use MeasureString which gives width only
  ## Height can be approximated from font metrics
  var w: cint
  var len: csize_t
  if TTF_MeasureString(font, text.cstring, text.len.csize_t, 0, addr w, addr len):
    # Get font height as an approximation for text height
    let h = TTF_GetFontHeight(font)
    result = (w.int, h.int)
  else:
    result = (0, 0)

# =============================================================================
# End of SDL3_ttf Wrapper
# =============================================================================
