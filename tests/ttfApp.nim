## SDL3 TTF Example Application
## =============================
##
## Demonstrates SDL_ttf font rendering capabilities

import libSDL
import std/[strformat, os]

const
  WINDOW_WIDTH = 800
  WINDOW_HEIGHT = 600
  WINDOW_TITLE = "SDL3 TTF Example"

proc fileExistsCheck(path: string): bool =
  ## Check if file exists using direct system call
  when defined(posix):
    proc access(path: cstring, mode: cint): cint {.importc, header: "<unistd.h>".}
    const F_OK = 0
    result = access(path.cstring, F_OK) == 0
  else:
    result = fileExists(path)

proc findSystemFont(): string =
  ## Try to find a system font
  # First check local directory (for sandboxed environments)
  let localFonts = [
    "./DejaVuSans.ttf",
    "./font.ttf", 
    "../fonts/DejaVuSans.ttf",
    "DejaVuSans.ttf"
  ]
  
  echo "Checking local fonts first..."
  for font in localFonts:
    if fileExistsCheck(font):
      echo &"  Found local font: {font}"
      return font
  
  # Check environment variable
  let envFont = getEnv("SDL_FONT_PATH")
  if envFont != "":
    echo &"Checking environment variable SDL_FONT_PATH: {envFont}"
    return envFont
  
  # Check command line argument
  if paramCount() > 0:
    let argFont = paramStr(1)
    echo &"Checking command line argument: {argFont}"
    return argFont
  
  when defined(windows):
    const fonts = [
      "C:\\Windows\\Fonts\\arial.ttf",
      "C:\\Windows\\Fonts\\calibri.ttf",
      "C:\\Windows\\Fonts\\segoeui.ttf",
      "C:\\Windows\\Fonts\\times.ttf",
      "C:\\Windows\\Fonts\\verdana.ttf",
      "C:\\Windows\\Fonts\\consola.ttf"
    ]
  elif defined(linux):
    const fonts = [
      # Fedora/RHEL paths
      "/usr/share/fonts/dejavu-sans-fonts/DejaVuSans.ttf",
      "/usr/share/fonts/dejavu-sans-mono-fonts/DejaVuSansMono.ttf",
      "/usr/share/fonts/liberation-sans/LiberationSans-Regular.ttf",
      "/usr/share/fonts/liberation-mono/LiberationMono-Regular.ttf",
      # Debian/Ubuntu paths
      "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
      "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
      "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
      "/usr/share/fonts/truetype/liberation2/LiberationSans-Regular.ttf",
      "/usr/share/fonts/truetype/ubuntu/Ubuntu-R.ttf",
      "/usr/share/fonts/TTF/DejaVuSans.ttf",
      "/usr/share/fonts/opentype/noto/NotoSans-Regular.ttf",
      "/usr/share/fonts/truetype/noto/NotoSans-Regular.ttf",
      # Generic paths
      "/usr/share/fonts/truetype/crosextra/Carlito-Regular.ttf"
    ]
  elif defined(macosx):
    const fonts = [
      "/System/Library/Fonts/Helvetica.ttc",
      "/System/Library/Fonts/SFNSDisplay.ttf",
      "/Library/Fonts/Arial.ttf"
    ]
  else:
    const fonts: array[0, string] = []
  
  echo "Checking system fonts..."
  for font in fonts:
    echo &"  Checking: {font}"
    if fileExistsCheck(font):
      echo &"  Found font: {font}"
      return font
  
  return ""

proc main() =
  echo "SDL3 TTF Example"
  echo "================"
  
  # Initialize SDL
  if SDL_Init(SDL_INIT_VIDEO) == SDL_FALSE:
    echo "SDL_Init failed: ", SDL_GetError()
    quit(1)
  
  echo "SDL initialized"
  
  # Initialize TTF
  if not initTTF():
    echo "TTF initialization failed"
    SDL_Quit()
    quit(1)
  
  echo "SDL_ttf initialized"
  
  # Create window
  let window = SDL_CreateWindow(WINDOW_TITLE, WINDOW_WIDTH, WINDOW_HEIGHT, 0)
  if window.isNil:
    echo "SDL_CreateWindow failed: ", SDL_GetError()
    quitTTF()
    SDL_Quit()
    quit(1)
  
  echo "Window created"
  
  # Create renderer
  let renderer = SDL_CreateRenderer(window, nil)
  if renderer.isNil:
    echo "SDL_CreateRenderer failed: ", SDL_GetError()
    SDL_DestroyWindow(window)
    quitTTF()
    SDL_Quit()
    quit(1)
  
  echo "Renderer created"
  
  # Find and load font
  echo "Searching for system fonts..."
  let fontPath = findSystemFont()
  
  if fontPath == "":
    echo "ERROR: No system fonts found!"
    echo "Please manually specify a font path in the code."
    echo ""
    echo "Press ENTER to exit..."
    discard stdin.readLine()
    SDL_DestroyRenderer(renderer)
    SDL_DestroyWindow(window)
    quitTTF()
    SDL_Quit()
    quit(1)
  
  let font = loadFont(fontPath, 32)
  if font.isNil:
    echo &"Failed to load font: {fontPath}"
    echo ""
    echo "Press ENTER to exit..."
    discard stdin.readLine()
    SDL_DestroyRenderer(renderer)
    SDL_DestroyWindow(window)
    quitTTF()
    SDL_Quit()
    quit(1)
  
  echo "Font loaded successfully"
  
  # Check font size
  let fontSize = TTF_GetFontSize(font)
  echo &"Font size: {fontSize}"
  
  # Define colors
  var white = SdlColor(r: 255, g: 255, b: 255, a: 255)
  var red = SdlColor(r: 255, g: 100, b: 100, a: 255)
  var green = SdlColor(r: 100, g: 255, b: 100, a: 255)
  var blue = SdlColor(r: 100, g: 150, b: 255, a: 255)
  var black = SdlColor(r: 0, g: 0, b: 0, a: 255)
  
  # Render different text samples
  echo "Rendering text samples..."
  
  # Title - Blended (high quality)
  echo "Rendering title..."
  let titleSurface = renderTextBlended(font, "SDL_ttf Font Rendering", white)
  if titleSurface.isNil:
    echo "ERROR: Failed to render title text"
    echo "SDL Error: ", SDL_GetError()
  else:
    echo "Title rendered successfully"
  
  # Solid text (fastest)
  echo "Rendering solid text..."
  let solidSurface = renderTextSolid(font, "Solid Rendering (Fast)", red)
  if solidSurface.isNil:
    echo "ERROR: Failed to render solid text"
  else:
    echo "Solid text rendered successfully"
  
  # Shaded text (with background)
  echo "Rendering shaded text..."
  let shadedSurface = renderTextShaded(font, "Shaded Rendering", green, black)
  if shadedSurface.isNil:
    echo "ERROR: Failed to render shaded text"
  else:
    echo "Shaded text rendered successfully"
  
  # Blended text (high quality)
  echo "Rendering blended text..."
  let blendedSurface = renderTextBlended(font, "Blended Rendering (Best)", blue)
  if blendedSurface.isNil:
    echo "ERROR: Failed to render blended text"
  else:
    echo "Blended text rendered successfully"
  
  # Get text size example
  echo "Getting text size..."
  let (textW, textH) = getTextSize(font, "Text Size Test")
  echo &"Text dimensions: {textW}x{textH}"
  
  # Create textures from surfaces - only if surfaces are valid
  echo "Creating textures..."
  var titleTexture: SdlTexture = nil
  var solidTexture: SdlTexture = nil
  var shadedTexture: SdlTexture = nil
  var blendedTexture: SdlTexture = nil
  
  if not titleSurface.isNil:
    echo "Creating title texture..."
    titleTexture = SDL_CreateTextureFromSurface(renderer, titleSurface)
    if titleTexture.isNil:
      echo "ERROR: Failed to create title texture: ", SDL_GetError()
    SDL_DestroySurface(titleSurface)
  
  if not solidSurface.isNil:
    echo "Creating solid texture..."
    solidTexture = SDL_CreateTextureFromSurface(renderer, solidSurface)
    if solidTexture.isNil:
      echo "ERROR: Failed to create solid texture: ", SDL_GetError()
    SDL_DestroySurface(solidSurface)
  
  if not shadedSurface.isNil:
    echo "Creating shaded texture..."
    shadedTexture = SDL_CreateTextureFromSurface(renderer, shadedSurface)
    if shadedTexture.isNil:
      echo "ERROR: Failed to create shaded texture: ", SDL_GetError()
    SDL_DestroySurface(shadedSurface)
  
  if not blendedSurface.isNil:
    echo "Creating blended texture..."
    blendedTexture = SDL_CreateTextureFromSurface(renderer, blendedSurface)
    if blendedTexture.isNil:
      echo "ERROR: Failed to create blended texture: ", SDL_GetError()
    SDL_DestroySurface(blendedSurface)
  
  # Check if we have at least one texture
  if titleTexture.isNil and solidTexture.isNil and shadedTexture.isNil and blendedTexture.isNil:
    echo ""
    echo "ERROR: Failed to create any textures!"
    echo "This might be a compatibility issue with SDL3_ttf."
    echo ""
    echo "Press ENTER to exit..."
    discard stdin.readLine()
    TTF_CloseFont(font)
    SDL_DestroyRenderer(renderer)
    SDL_DestroyWindow(window)
    quitTTF()
    SDL_Quit()
    quit(1)
  
  echo "Textures created, entering main loop"
  echo "Press ESC to quit"
  
  # Main loop
  var running = true
  var event: SdlEvent
  
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
    
    # Clear screen
    discard SDL_SetRenderDrawColor(renderer, 30, 30, 40, 255)
    discard SDL_RenderClear(renderer)
    
    # Render textures
    var y = 50.0
    let spacing = 80.0
    
    if not titleTexture.isNil:
      var w, h: cfloat
      discard SDL_GetTextureSize(titleTexture, addr w, addr h)
      var dstRect = SdlFRect(x: 50, y: y, w: w, h: h)
      discard SDL_RenderTexture(renderer, titleTexture, nil, addr dstRect)
      y += spacing + 20
    
    if not solidTexture.isNil:
      var w, h: cfloat
      discard SDL_GetTextureSize(solidTexture, addr w, addr h)
      var dstRect = SdlFRect(x: 50, y: y, w: w, h: h)
      discard SDL_RenderTexture(renderer, solidTexture, nil, addr dstRect)
      y += spacing
    
    if not shadedTexture.isNil:
      var w, h: cfloat
      discard SDL_GetTextureSize(shadedTexture, addr w, addr h)
      var dstRect = SdlFRect(x: 50, y: y, w: w, h: h)
      discard SDL_RenderTexture(renderer, shadedTexture, nil, addr dstRect)
      y += spacing
    
    if not blendedTexture.isNil:
      var w, h: cfloat
      discard SDL_GetTextureSize(blendedTexture, addr w, addr h)
      var dstRect = SdlFRect(x: 50, y: y, w: w, h: h)
      discard SDL_RenderTexture(renderer, blendedTexture, nil, addr dstRect)
    
    # Present
    discard SDL_RenderPresent(renderer)
    
    # Frame limiting
    SDL_Delay(16)
  
  # Cleanup
  echo "Cleaning up..."
  
  if not titleTexture.isNil:
    SDL_DestroyTexture(titleTexture)
  if not solidTexture.isNil:
    SDL_DestroyTexture(solidTexture)
  if not shadedTexture.isNil:
    SDL_DestroyTexture(shadedTexture)
  if not blendedTexture.isNil:
    SDL_DestroyTexture(blendedTexture)
  
  TTF_CloseFont(font)
  SDL_DestroyRenderer(renderer)
  SDL_DestroyWindow(window)
  quitTTF()
  SDL_Quit()
  
  echo "Application closed successfully"

when isMainModule:
  main()
