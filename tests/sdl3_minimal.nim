## SDL3 Minimal Example
## =====================
##
## A minimal "Hello World" style application using SDL3 Nim wrapper.
## Creates a window, renders colored rectangles, and handles basic input.



import math
import libSDL

const
  WINDOW_WIDTH = 800
  WINDOW_HEIGHT = 600
  WINDOW_TITLE = "SDL3 Minimal Example"

proc main() =
  # Initialize SDL
  if SDL_Init(SDL_INIT_VIDEO) == SDL_FALSE:
    echo "SDL_Init Error: ", SDL_GetError()
    quit(1)
  
  echo "SDL3 Version: ", SDL_GetRevision()
  
  # Create window
  let window = SDL_CreateWindow(WINDOW_TITLE, WINDOW_WIDTH, WINDOW_HEIGHT, 
                                  SDL_WINDOW_RESIZABLE)
  if window.isNil:
    echo "SDL_CreateWindow Error: ", SDL_GetError()
    SDL_Quit()
    quit(1)
  
  # Create renderer
  let renderer = SDL_CreateRenderer(window, nil)
  if renderer.isNil:
    echo "SDL_CreateRenderer Error: ", SDL_GetError()
    SDL_DestroyWindow(window)
    SDL_Quit()
    quit(1)
  
  echo "Window and Renderer created successfully"
  echo "Press ESC to quit"
  
  # Main loop
  var running = true
  var event: SdlEvent
  var frameCount = 0
  
  while running:
    # Handle events
    while SDL_PollEvent(addr event) == SDL_TRUE:
      case event.type
      of SDL_EVENT_QUIT:
        running = false
      of SDL_EVENT_KEY_DOWN:
        if event.key.scancode == SDL_SCANCODE_ESCAPE:
          running = false
      else:
        discard
    
    # Render
    # Clear with dark blue background
    discard SDL_SetRenderDrawColor(renderer, 20, 40, 80, 255)
    discard SDL_RenderClear(renderer)
    
    # Draw animated rectangles
    for i in 0..4:
      let offset = float(frameCount + i * 20) * 0.02
      let x = 100.0 + float(i) * 140.0
      let y = 200.0 + 50.0 * sin(offset)
      
      var rect = SdlFRect(x: x, y: y, w: 100.0, h: 100.0)
      
      # Set color based on rectangle index
      let r = uint8((i * 60) mod 256)
      let g = uint8(((4 - i) * 60) mod 256)
      let b = uint8(128 + (i * 30) mod 128)
      
      discard SDL_SetRenderDrawColor(renderer, r, g, b, 255)
      discard SDL_RenderFillRect(renderer, addr rect)
    
    # Present frame
    discard SDL_RenderPresent(renderer)
    
    # Simple frame limiting
    SDL_Delay(16)  # ~60 FPS
    frameCount.inc
  
  # Cleanup
  SDL_DestroyRenderer(renderer)
  SDL_DestroyWindow(window)
  SDL_Quit()
  
  echo "Application closed successfully"

when isMainModule:
  main()







# nim c -d:release sdl3_minimal.nim

