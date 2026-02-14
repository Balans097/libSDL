## SDL3 Wrapper Test Application
## ===============================
##
## This application tests various SDL3 subsystems through the Nim wrapper.
## It creates a window, handles events, renders graphics, plays audio,
## and demonstrates input handling.

import libSDL
import std/[strformat, math, times]

# =============================================================================
# Constants
# =============================================================================

const
  WINDOW_WIDTH = 1024
  WINDOW_HEIGHT = 768
  WINDOW_TITLE = "SDL3 Nim Wrapper - Test Application"
  TARGET_FPS = 60
  FRAME_TIME = 1000 div TARGET_FPS

# =============================================================================
# Types
# =============================================================================

type
  AppState = object
    window: SdlWindow
    renderer: SdlRenderer
    running: bool
    frameCount: uint64
    lastTime: uint64
    fps: float
    mouseX, mouseY: float32
    mousePressed: bool
    keys: array[512, bool]
    audioDevice: SdlAudioDeviceID
    
  Particle = object
    x, y: float32
    vx, vy: float32
    life: float32
    r, g, b, a: uint8

# =============================================================================
# Test Functions
# =============================================================================

proc testVersion(): bool =
  ## Test SDL version information
  echo "\n=== Testing SDL Version ==="
  let version = SDL_GetVersion()
  let major = (version shr 24) and 0xFF
  let minor = (version shr 16) and 0xFF
  let patch = version and 0xFFFF
  echo &"SDL Version: {major}.{minor}.{patch}"
  echo &"SDL Revision: {SDL_GetRevision()}"
  echo &"Platform: {SDL_GetPlatform()}"
  return true

proc testCPUInfo(): bool =
  ## Test CPU information
  echo "\n=== Testing CPU Information ==="
  echo &"CPU Count: {SDL_GetCPUCount()}"
  echo &"CPU Cache Line Size: {SDL_GetCPUCacheLineSize()}"
  echo &"System RAM: {SDL_GetSystemRAM()} MB"
  
  echo "CPU Features:"
  if SDL_HasSSE() == SDL_TRUE: echo "  - SSE"
  if SDL_HasSSE2() == SDL_TRUE: echo "  - SSE2"
  if SDL_HasSSE3() == SDL_TRUE: echo "  - SSE3"
  if SDL_HasSSE41() == SDL_TRUE: echo "  - SSE4.1"
  if SDL_HasSSE42() == SDL_TRUE: echo "  - SSE4.2"
  if SDL_HasAVX() == SDL_TRUE: echo "  - AVX"
  if SDL_HasAVX2() == SDL_TRUE: echo "  - AVX2"
  if SDL_HasNEON() == SDL_TRUE: echo "  - NEON"
  
  return true

proc testDisplays(): bool =
  ## Test display information
  echo "\n=== Testing Display Information ==="
  var count: cint
  let displays = SDL_GetDisplays(addr count)
  
  if displays.isNil:
    echo &"Error getting displays: {SDL_GetError()}"
    return false
  
  echo &"Number of displays: {count}"
  
  for i in 0..<count:
    let displayID = cast[ptr UncheckedArray[SdlDisplayID]](displays)[i]
    echo &"\nDisplay {i}:"
    echo &"  Name: {SDL_GetDisplayName(displayID)}"
    
    var bounds: SdlRect
    if SDL_GetDisplayBounds(displayID, addr bounds) == SDL_TRUE:
      echo &"  Bounds: {bounds.x}x{bounds.y} - {bounds.w}x{bounds.h}"
    
    let mode = SDL_GetCurrentDisplayMode(displayID)
    if not mode.isNil:
      echo &"  Current Mode: {mode.w}x{mode.h} @ {mode.refresh_rate:.2f}Hz"
      echo &"  Pixel Format: {SDL_GetPixelFormatName(mode.format)}"
  
  SDL_free(displays)
  return true

proc testTimer(): bool =
  ## Test timer functions
  echo "\n=== Testing Timer ==="
  let start = SDL_GetTicks()
  SDL_Delay(100)
  let elapsed = SDL_GetTicks() - start
  echo &"Delay test: requested 100ms, actual {elapsed}ms"
  
  let perfFreq = SDL_GetPerformanceFrequency()
  echo &"Performance Counter Frequency: {perfFreq} Hz"
  
  return true

proc testFilesystem(): bool =
  ## Test filesystem functions
  echo "\n=== Testing Filesystem ==="
  
  let basePath = SDL_GetBasePath()
  if not basePath.isNil:
    echo &"Base Path: {basePath}"
  
  let prefPath = SDL_GetPrefPath("NimSDL3Test", "TestApp")
  if not prefPath.isNil:
    echo &"Pref Path: {prefPath}"
  
  let homePath = SDL_GetUserFolder(SDL_FOLDER_HOME)
  if not homePath.isNil:
    echo &"Home Folder: {homePath}"
  
  let docsPath = SDL_GetUserFolder(SDL_FOLDER_DOCUMENTS)
  if not docsPath.isNil:
    echo &"Documents Folder: {docsPath}"
  
  return true

proc testClipboard(): bool =
  ## Test clipboard functions
  echo "\n=== Testing Clipboard ==="
  
  let testText = "SDL3 Nim Wrapper Test"
  if SDL_SetClipboardText(testText.cstring) == SDL_TRUE:
    echo "Clipboard text set successfully"
    
    let retrieved = SDL_GetClipboardText()
    if not retrieved.isNil:
      echo &"Retrieved clipboard text: {retrieved}"
      return $retrieved == testText
  else:
    echo &"Error setting clipboard: {SDL_GetError()}"
    return false
  
  return true

proc initAudio(state: var AppState): bool =
  ## Initialize audio subsystem
  echo "\n=== Testing Audio ==="
  
  var count: cint
  let devices = SDL_GetAudioPlaybackDevices(addr count)
  
  if devices.isNil:
    echo &"Error getting audio devices: {SDL_GetError()}"
    return false
  
  echo &"Audio playback devices: {count}"
  for i in 0..<count:
    let deviceID = cast[ptr UncheckedArray[SdlAudioDeviceID]](devices)[i]
    echo &"  Device {i}: {SDL_GetAudioDeviceName(deviceID)}"
  
  # Open default audio device
  var spec: SdlAudioSpec
  spec.format = SDL_AUDIO_F32
  spec.channels = 2
  spec.freq = 48000
  
  state.audioDevice = SDL_OpenAudioDevice(0, addr spec)
  if state.audioDevice == 0:
    echo &"Error opening audio device: {SDL_GetError()}"
    SDL_free(devices)
    return false
  
  echo "Audio device opened successfully"
  SDL_free(devices)
  return true

proc testJoysticks(): bool =
  ## Test joystick/gamepad support
  echo "\n=== Testing Joysticks/Gamepads ==="
  
  if SDL_HasJoystick() == SDL_TRUE:
    var count: cint
    let joysticks = SDL_GetJoysticks(addr count)
    echo &"Number of joysticks: {count}"
    
    if not joysticks.isNil and count > 0:
      for i in 0..<count:
        let joyID = cast[ptr UncheckedArray[SdlJoystickID]](joysticks)[i]
        echo &"  Joystick {i}: {SDL_GetJoystickNameForID(joyID)}"
        
        if SDL_IsGamepad(joyID) == SDL_TRUE:
          echo &"    -> Is a gamepad"
      
      SDL_free(joysticks)
  else:
    echo "No joystick support available"
  
  # Test gamepad
  if SDL_HasGamepad() == SDL_TRUE:
    var count: cint
    let gamepads = SDL_GetGamepads(addr count)
    echo &"Number of gamepads: {count}"
    
    if not gamepads.isNil:
      SDL_free(gamepads)
  
  return true

proc createWindow(state: var AppState): bool =
  ## Create SDL window and renderer
  echo "\n=== Creating Window and Renderer ==="
  
  let windowFlags = SDL_WINDOW_RESIZABLE or SDL_WINDOW_HIGH_PIXEL_DENSITY
  state.window = SDL_CreateWindow(WINDOW_TITLE, WINDOW_WIDTH, WINDOW_HEIGHT, windowFlags)
  
  if state.window.isNil:
    echo &"Error creating window: {SDL_GetError()}"
    return false
  
  echo "Window created successfully"
  
  state.renderer = SDL_CreateRenderer(state.window, nil)
  if state.renderer.isNil:
    echo &"Error creating renderer: {SDL_GetError()}"
    SDL_DestroyWindow(state.window)
    return false
  
  echo "Renderer created successfully"
  
  # Get renderer info
  let rendererName = SDL_GetRendererName(state.renderer)
  if not rendererName.isNil:
    echo &"Renderer: {rendererName}"
  
  # Enable VSync
  if SDL_SetRenderVSync(state.renderer, 1) == SDL_TRUE:
    echo "VSync enabled"
  
  return true

proc handleEvents(state: var AppState): bool =
  ## Handle SDL events
  var event: SdlEvent
  
  while SDL_PollEvent(addr event) == SDL_TRUE:
    case event.type
    of SDL_EVENT_QUIT:
      state.running = false
      return false
    
    of SDL_EVENT_KEY_DOWN:
      let key = event.key
      if key.scancode.int < state.keys.len:
        state.keys[key.scancode.int] = true
      
      # Check for ESC key
      if key.scancode == SDL_SCANCODE_ESCAPE:
        state.running = false
        return false
      
      # Check for F key to toggle fullscreen
      if key.scancode == SDL_SCANCODE_F:
        var flags: SdlWindowFlags = SDL_GetWindowFlags(state.window)
        let isFullscreen = (flags.uint64 and SDL_WINDOW_FULLSCREEN.uint64) != 0
        discard SDL_SetWindowFullscreen(state.window, if isFullscreen: SDL_FALSE else: SDL_TRUE)
    
    of SDL_EVENT_KEY_UP:
      let key = event.key
      if key.scancode.int < state.keys.len:
        state.keys[key.scancode.int] = false
    
    of SDL_EVENT_MOUSE_MOTION:
      state.mouseX = event.motion.x
      state.mouseY = event.motion.y
    
    of SDL_EVENT_MOUSE_BUTTON_DOWN:
      if event.button.button == SDL_BUTTON_LEFT:
        state.mousePressed = true
    
    of SDL_EVENT_MOUSE_BUTTON_UP:
      if event.button.button == SDL_BUTTON_LEFT:
        state.mousePressed = false
    
    of SDL_EVENT_WINDOW_RESIZED:
      let w = event.window
      echo &"Window resized to {w.data1}x{w.data2}"
    
    else:
      discard
  
  return true

proc renderFrame(state: var AppState) =
  ## Render a test frame
  let time = SDL_GetTicks().float / 1000.0
  
  # Clear screen with animated color
  let r = uint8((sin(time * 0.5) * 0.5 + 0.5) * 100)
  let g = uint8((sin(time * 0.7) * 0.5 + 0.5) * 100)
  let b = uint8((sin(time * 0.3) * 0.5 + 0.5) * 100)
  
  discard SDL_SetRenderDrawColor(state.renderer, r, g, b, 255)
  discard SDL_RenderClear(state.renderer)
  
  # Draw some test rectangles
  for i in 0..<5:
    let x = 100.0 + float(i) * 150.0
    let y = 100.0 + sin(time + float(i) * 0.5) * 50.0
    
    var rect = SdlFRect(
      x: x,
      y: y,
      w: 120.0,
      h: 80.0
    )
    
    let hue = (float(i) / 5.0 + time * 0.1).mod(1.0)
    let red = uint8(abs(sin(hue * PI * 2.0)) * 255)
    let green = uint8(abs(sin((hue + 0.33) * PI * 2.0)) * 255)
    let blue = uint8(abs(sin((hue + 0.67) * PI * 2.0)) * 255)
    
    discard SDL_SetRenderDrawColor(state.renderer, red, green, blue, 255)
    discard SDL_RenderFillRect(state.renderer, addr rect)
    
    # Draw border
    discard SDL_SetRenderDrawColor(state.renderer, 255, 255, 255, 255)
    discard SDL_RenderRect(state.renderer, addr rect)
  
  # Draw some animated lines
  discard SDL_SetRenderDrawColor(state.renderer, 255, 255, 0, 255)
  for i in 0..<20:
    let angle = time + float(i) * 0.3
    let x1 = WINDOW_WIDTH.float / 2.0
    let y1 = WINDOW_HEIGHT.float / 2.0
    let x2 = x1 + cos(angle) * 200.0
    let y2 = y1 + sin(angle) * 200.0
    discard SDL_RenderLine(state.renderer, x1, y1, x2, y2)
  
  # Draw circle around mouse cursor
  if state.mousePressed:
    discard SDL_SetRenderDrawColor(state.renderer, 255, 0, 0, 128)
    let steps = 32
    for i in 0..steps:
      let angle1 = (float(i) / float(steps)) * PI * 2.0
      let angle2 = (float(i + 1) / float(steps)) * PI * 2.0
      let x1 = state.mouseX + cos(angle1) * 50.0
      let y1 = state.mouseY + sin(angle1) * 50.0
      let x2 = state.mouseX + cos(angle2) * 50.0
      let y2 = state.mouseY + sin(angle2) * 50.0
      discard SDL_RenderLine(state.renderer, x1, y1, x2, y2)
  
  # Draw mouse position indicator
  discard SDL_SetRenderDrawColor(state.renderer, 255, 255, 255, 255)
  discard SDL_RenderLine(state.renderer, state.mouseX - 10, state.mouseY, state.mouseX + 10, state.mouseY)
  discard SDL_RenderLine(state.renderer, state.mouseX, state.mouseY - 10, state.mouseX, state.mouseY + 10)
  
  # Draw FPS counter in top-left corner
  var fpsRect = SdlFRect(x: 10, y: 10, w: 150, h: 30)
  discard SDL_SetRenderDrawColor(state.renderer, 0, 0, 0, 180)
  discard SDL_RenderFillRect(state.renderer, addr fpsRect)
  
  # Present
  discard SDL_RenderPresent(state.renderer)

proc updateFPS(state: var AppState) =
  ## Update FPS counter
  state.frameCount.inc
  let currentTime = SDL_GetTicks()
  
  if currentTime - state.lastTime >= 1000:
    state.fps = float(state.frameCount) * 1000.0 / float(currentTime - state.lastTime)
    echo &"FPS: {state.fps:.2f}"
    state.frameCount = 0
    state.lastTime = currentTime

proc mainLoop(state: var AppState) =
  ## Main application loop
  echo "\n=== Running Main Loop ==="
  echo "Controls:"
  echo "  ESC - Quit"
  echo "  F - Toggle Fullscreen"
  echo "  Left Mouse - Draw circle at cursor"
  echo ""
  
  state.running = true
  state.lastTime = SDL_GetTicks()
  
  while state.running:
    let frameStart = SDL_GetTicks()
    
    # Handle events
    if not handleEvents(state):
      break
    
    # Render
    renderFrame(state)
    
    # Update FPS
    updateFPS(state)
    
    # Frame rate limiting
    let frameTime = SDL_GetTicks() - frameStart
    if frameTime < FRAME_TIME.uint64:
      SDL_Delay(uint32(FRAME_TIME.uint64 - frameTime))

proc cleanup(state: var AppState) =
  ## Cleanup resources
  echo "\n=== Cleaning Up ==="
  
  if state.audioDevice != 0:
    SDL_CloseAudioDevice(state.audioDevice)
    echo "Audio device closed"
  
  if not state.renderer.isNil:
    SDL_DestroyRenderer(state.renderer)
    echo "Renderer destroyed"
  
  if not state.window.isNil:
    SDL_DestroyWindow(state.window)
    echo "Window destroyed"

# =============================================================================
# Main Program
# =============================================================================

proc main() =
  echo "SDL3 Nim Wrapper - Comprehensive Test Application"
  echo "=================================================="
  
  # Run pre-initialization tests
  discard testVersion()
  discard testCPUInfo()
  
  # Initialize SDL
  echo "\n=== Initializing SDL ==="
  let initFlags = SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_EVENTS or 
                  SDL_INIT_JOYSTICK or SDL_INIT_GAMEPAD
  
  if SDL_Init(initFlags) == SDL_FALSE:
    echo &"SDL_Init failed: {SDL_GetError()}"
    quit(1)
  
  echo "SDL initialized successfully"
  
  # Run post-initialization tests
  discard testDisplays()
  discard testTimer()
  discard testFilesystem()
  discard testClipboard()
  discard testJoysticks()
  
  # Initialize application state
  var state: AppState
  
  # Initialize audio
  discard initAudio(state)
  
  # Create window and renderer
  if not createWindow(state):
    SDL_Quit()
    quit(1)
  
  # Run main loop
  try:
    mainLoop(state)
  finally:
    cleanup(state)
    SDL_Quit()
    echo "\nSDL shut down successfully"
    echo "All tests completed!"

# Run the application
when isMainModule:
  main()
