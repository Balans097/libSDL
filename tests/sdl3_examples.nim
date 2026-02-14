## SDL3 Nim Wrapper - Code Examples
## ==================================
##
## Additional code examples demonstrating various SDL3 features



import math
import libSDL

# =============================================================================
# Example 1: Basic Window with Event Loop
# =============================================================================

proc example1_BasicWindow() =
  echo "\n=== Example 1: Basic Window ==="
  
  if SDL_Init(SDL_INIT_VIDEO) == SDL_FALSE:
    echo "Error: ", SDL_GetError()
    return
  
  let window = SDL_CreateWindow("Basic Window", 640, 480, SDL_WINDOW_RESIZABLE)
  if window.isNil:
    SDL_Quit()
    return
  
  var running = true
  var event: SdlEvent
  
  while running:
    while SDL_PollEvent(addr event) == SDL_TRUE:
      if event.type == SDL_EVENT_QUIT:
        running = false
  
  SDL_DestroyWindow(window)
  SDL_Quit()

# =============================================================================
# Example 2: Rendering Shapes
# =============================================================================

proc example2_RenderingShapes() =
  echo "\n=== Example 2: Rendering Shapes ==="
  
  if SDL_Init(SDL_INIT_VIDEO) == SDL_FALSE:
    return
  
  let window = SDL_CreateWindow("Rendering Shapes", 800, 600, 0)
  let renderer = SDL_CreateRenderer(window, nil)
  
  if window.isNil or renderer.isNil:
    SDL_Quit()
    return
  
  var running = true
  var event: SdlEvent
  
  while running:
    while SDL_PollEvent(addr event) == SDL_TRUE:
      if event.type == SDL_EVENT_QUIT or 
         (event.type == SDL_EVENT_KEY_DOWN and event.key.scancode == SDL_SCANCODE_ESCAPE):
        running = false
    
    # Clear with black
    discard SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255)
    discard SDL_RenderClear(renderer)
    
    # Draw red rectangle
    discard SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255)
    var rect1 = SdlFRect(x: 50, y: 50, w: 200, h: 150)
    discard SDL_RenderFillRect(renderer, addr rect1)
    
    # Draw green outline rectangle
    discard SDL_SetRenderDrawColor(renderer, 0, 255, 0, 255)
    var rect2 = SdlFRect(x: 300, y: 100, w: 150, h: 200)
    discard SDL_RenderRect(renderer, addr rect2)
    
    # Draw blue line
    discard SDL_SetRenderDrawColor(renderer, 0, 0, 255, 255)
    discard SDL_RenderLine(renderer, 100, 400, 700, 450)
    
    # Draw yellow points
    discard SDL_SetRenderDrawColor(renderer, 255, 255, 0, 255)
    for i in 0..<100:
      discard SDL_RenderPoint(renderer, 50.0 + float(i) * 7, 500)
    
    discard SDL_RenderPresent(renderer)
    SDL_Delay(16)
  
  SDL_DestroyRenderer(renderer)
  SDL_DestroyWindow(window)
  SDL_Quit()

# =============================================================================
# Example 3: Keyboard Input
# =============================================================================

proc example3_KeyboardInput() =
  echo "\n=== Example 3: Keyboard Input ==="
  
  if SDL_Init(SDL_INIT_VIDEO) == SDL_FALSE:
    return
  
  let window = SDL_CreateWindow("Keyboard Input", 640, 480, 0)
  let renderer = SDL_CreateRenderer(window, nil)
  
  var running = true
  var event: SdlEvent
  var posX = 320.0
  var posY = 240.0
  let speed = 5.0
  
  echo "Use arrow keys to move the square, ESC to quit"
  
  while running:
    while SDL_PollEvent(addr event) == SDL_TRUE:
      case event.type
      of SDL_EVENT_QUIT:
        running = false
      of SDL_EVENT_KEY_DOWN:
        case event.key.scancode
        of SDL_SCANCODE_ESCAPE:
          running = false
        of SDL_SCANCODE_UP:
          posY -= speed
        of SDL_SCANCODE_DOWN:
          posY += speed
        of SDL_SCANCODE_LEFT:
          posX -= speed
        of SDL_SCANCODE_RIGHT:
          posX += speed
        else:
          discard
      else:
        discard
    
    # Clamp position to window
    posX = max(0.0, min(posX, 590.0))
    posY = max(0.0, min(posY, 430.0))
    
    # Clear
    discard SDL_SetRenderDrawColor(renderer, 30, 30, 30, 255)
    discard SDL_RenderClear(renderer)
    
    # Draw player square
    discard SDL_SetRenderDrawColor(renderer, 0, 255, 0, 255)
    var rect = SdlFRect(x: posX, y: posY, w: 50, h: 50)
    discard SDL_RenderFillRect(renderer, addr rect)
    
    discard SDL_RenderPresent(renderer)
    SDL_Delay(16)
  
  SDL_DestroyRenderer(renderer)
  SDL_DestroyWindow(window)
  SDL_Quit()

# =============================================================================
# Example 4: Mouse Input
# =============================================================================

proc example4_MouseInput() =
  echo "\n=== Example 4: Mouse Input ==="
  
  if SDL_Init(SDL_INIT_VIDEO) == SDL_FALSE:
    return
  
  let window = SDL_CreateWindow("Mouse Input", 800, 600, 0)
  let renderer = SDL_CreateRenderer(window, nil)
  
  type Point = tuple[x, y: float32]
  var points: seq[Point] = @[]
  
  var running = true
  var event: SdlEvent
  var drawing = false
  
  echo "Click and drag to draw, press C to clear, ESC to quit"
  
  while running:
    while SDL_PollEvent(addr event) == SDL_TRUE:
      case event.type
      of SDL_EVENT_QUIT:
        running = false
      of SDL_EVENT_KEY_DOWN:
        if event.key.scancode == SDL_SCANCODE_ESCAPE:
          running = false
        elif event.key.scancode == SDL_SCANCODE_C:
          points = @[]
      of SDL_EVENT_MOUSE_BUTTON_DOWN:
        if event.button.button == SDL_BUTTON_LEFT:
          drawing = true
          points.add((event.button.x, event.button.y))
      of SDL_EVENT_MOUSE_BUTTON_UP:
        if event.button.button == SDL_BUTTON_LEFT:
          drawing = false
      of SDL_EVENT_MOUSE_MOTION:
        if drawing:
          points.add((event.motion.x, event.motion.y))
      else:
        discard
    
    # Clear
    discard SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255)
    discard SDL_RenderClear(renderer)
    
    # Draw lines
    if points.len > 1:
      discard SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255)
      for i in 0..<points.len - 1:
        discard SDL_RenderLine(renderer, points[i].x, points[i].y, 
                                points[i + 1].x, points[i + 1].y)
    
    discard SDL_RenderPresent(renderer)
    SDL_Delay(16)
  
  SDL_DestroyRenderer(renderer)
  SDL_DestroyWindow(window)
  SDL_Quit()

# =============================================================================
# Example 5: Surface and Texture
# =============================================================================

proc example5_SurfaceTexture() =
  echo "\n=== Example 5: Surface and Texture ==="
  
  if SDL_Init(SDL_INIT_VIDEO) == SDL_FALSE:
    return
  
  let window = SDL_CreateWindow("Surface & Texture", 640, 480, 0)
  let renderer = SDL_CreateRenderer(window, nil)
  
  # Create a surface with a pattern
  let surface = SDL_CreateSurface(200, 200, SDL_PIXELFORMAT_RGBA8888)
  
  if not surface.isNil:
    # Lock surface for pixel access
    if SDL_LockSurface(surface) == SDL_TRUE:
      # Draw a simple pattern
      let pixels = cast[ptr UncheckedArray[uint32]](surface.pixels)
      for y in 0..<200:
        for x in 0..<200:
          let r = uint8((x * 255) div 200)
          let g = uint8((y * 255) div 200)
          let b = uint8(128)
          pixels[y * 200 + x] = (255'u32 shl 24) or (b.uint32 shl 16) or 
                                 (g.uint32 shl 8) or r.uint32
      
      SDL_UnlockSurface(surface)
    
    # Create texture from surface
    let texture = SDL_CreateTextureFromSurface(renderer, surface)
    SDL_DestroySurface(surface)
    
    if not texture.isNil:
      var running = true
      var event: SdlEvent
      
      while running:
        while SDL_PollEvent(addr event) == SDL_TRUE:
          if event.type == SDL_EVENT_QUIT or
             (event.type == SDL_EVENT_KEY_DOWN and event.key.scancode == SDL_SCANCODE_ESCAPE):
            running = false
        
        discard SDL_SetRenderDrawColor(renderer, 50, 50, 50, 255)
        discard SDL_RenderClear(renderer)
        
        # Draw texture at different positions
        var srcRect = SdlFRect(x: 0, y: 0, w: 200, h: 200)
        var dstRect = SdlFRect(x: 50, y: 50, w: 200, h: 200)
        discard SDL_RenderTexture(renderer, texture, addr srcRect, addr dstRect)
        
        dstRect.x = 350
        discard SDL_RenderTexture(renderer, texture, addr srcRect, addr dstRect)
        
        discard SDL_RenderPresent(renderer)
        SDL_Delay(16)
      
      SDL_DestroyTexture(texture)
  
  SDL_DestroyRenderer(renderer)
  SDL_DestroyWindow(window)
  SDL_Quit()

# =============================================================================
# Example 6: Multiple Windows
# =============================================================================

proc example6_MultipleWindows() =
  echo "\n=== Example 6: Multiple Windows ==="
  
  if SDL_Init(SDL_INIT_VIDEO) == SDL_FALSE:
    return
  
  let window1 = SDL_CreateWindow("Window 1", 400, 300, SDL_WINDOW_RESIZABLE)
  let window2 = SDL_CreateWindow("Window 2", 400, 300, SDL_WINDOW_RESIZABLE)
  
  let renderer1 = SDL_CreateRenderer(window1, nil)
  let renderer2 = SDL_CreateRenderer(window2, nil)
  
  # Position windows side by side
  discard SDL_SetWindowPosition(window1, 100, 100)
  discard SDL_SetWindowPosition(window2, 550, 100)
  
  var running = true
  var event: SdlEvent
  
  while running:
    while SDL_PollEvent(addr event) == SDL_TRUE:
      if event.type == SDL_EVENT_QUIT:
        running = false
      elif event.type == SDL_EVENT_KEY_DOWN and event.key.scancode == SDL_SCANCODE_ESCAPE:
        running = false
    
    # Render window 1 (red)
    discard SDL_SetRenderDrawColor(renderer1, 200, 50, 50, 255)
    discard SDL_RenderClear(renderer1)
    discard SDL_RenderPresent(renderer1)
    
    # Render window 2 (blue)
    discard SDL_SetRenderDrawColor(renderer2, 50, 50, 200, 255)
    discard SDL_RenderClear(renderer2)
    discard SDL_RenderPresent(renderer2)
    
    SDL_Delay(16)
  
  SDL_DestroyRenderer(renderer2)
  SDL_DestroyRenderer(renderer1)
  SDL_DestroyWindow(window2)
  SDL_DestroyWindow(window1)
  SDL_Quit()

# =============================================================================
# Example 7: Timer and Animation
# =============================================================================

proc example7_TimerAnimation() =
  echo "\n=== Example 7: Timer and Animation ==="
  
  if SDL_Init(SDL_INIT_VIDEO) == SDL_FALSE:
    return
  
  let window = SDL_CreateWindow("Timer Animation", 800, 600, 0)
  let renderer = SDL_CreateRenderer(window, nil)
  
  var running = true
  var event: SdlEvent
  let startTime = SDL_GetTicks()
  
  while running:
    while SDL_PollEvent(addr event) == SDL_TRUE:
      if event.type == SDL_EVENT_QUIT or
         (event.type == SDL_EVENT_KEY_DOWN and event.key.scancode == SDL_SCANCODE_ESCAPE):
        running = false
    
    let elapsed = (SDL_GetTicks() - startTime).float / 1000.0
    
    # Clear
    discard SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255)
    discard SDL_RenderClear(renderer)
    
    # Animated circle
    let centerX = 400.0
    let centerY = 300.0
    let radius = 100.0 + sin(elapsed * 2.0) * 50.0
    
    discard SDL_SetRenderDrawColor(renderer, 255, 255, 0, 255)
    
    # Draw circle using lines
    let steps = 64
    for i in 0..steps:
      let angle1 = (float(i) / float(steps)) * PI * 2.0
      let angle2 = (float(i + 1) / float(steps)) * PI * 2.0
      let x1 = centerX + cos(angle1) * radius
      let y1 = centerY + sin(angle1) * radius
      let x2 = centerX + cos(angle2) * radius
      let y2 = centerY + sin(angle2) * radius
      discard SDL_RenderLine(renderer, x1, y1, x2, y2)
    
    discard SDL_RenderPresent(renderer)
    SDL_Delay(16)
  
  SDL_DestroyRenderer(renderer)
  SDL_DestroyWindow(window)
  SDL_Quit()

# =============================================================================
# Main Menu
# =============================================================================

proc main() =
  echo "SDL3 Nim Wrapper - Code Examples"
  echo "================================="
  echo ""
  echo "Select an example to run:"
  echo "  1. Basic Window"
  echo "  2. Rendering Shapes"
  echo "  3. Keyboard Input"
  echo "  4. Mouse Input (Drawing)"
  echo "  5. Surface and Texture"
  echo "  6. Multiple Windows"
  echo "  7. Timer and Animation"
  echo "  0. Exit"
  echo ""
  
  stdout.write("Enter choice: ")
  let choice = readLine(stdin)
  
  case choice
  of "1":
    example1_BasicWindow()
  of "2":
    example2_RenderingShapes()
  of "3":
    example3_KeyboardInput()
  of "4":
    example4_MouseInput()
  of "5":
    example5_SurfaceTexture()
  of "6":
    example6_MultipleWindows()
  of "7":
    example7_TimerAnimation()
  of "0":
    echo "Goodbye!"
  else:
    echo "Invalid choice"

when isMainModule:
  main()
