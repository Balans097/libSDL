# libSDL - API Reference

Полный справочник по API обёртки SDL3 для Nim с примерами кода.

**Версия:** 0.1 | **Дата:** 2026-02-13

> 💡 **Совет:** Используйте Ctrl+F для поиска нужной функции

---

## 📑 Содержание

- [Основные типы и константы](#основные-типы-и-константы)
- [Инициализация и завершение](#инициализация-и-завершение)
- [Обработка ошибок](#обработка-ошибок)
- [Работа с окнами](#работа-с-окнами)
- [Рендеринг](#рендеринг)
- [Текстуры и поверхности](#текстуры-и-поверхности)
- [События](#события)
- [Клавиатура](#клавиатура)
- [Мышь](#мышь)
- [Геймпад и джойстик](#геймпад-и-джойстик)
- [Таймеры и время](#таймеры-и-время)
- [SDL_ttf - Работа со шрифтами](#sdl_ttf---работа-со-шрифтами)
- [Аудио](#аудио)
- [GPU (Новый SDL3 API)](#gpu-новый-sdl3-api)
- [Файловый ввод-вывод](#файловый-ввод-вывод)
- [Потоки и синхронизация](#потоки-и-синхронизация)
- [Дополнительно](#дополнительно)

---

## Основные типы и константы

### Базовые типы

```nim
type
  Sint8* = int8          # 8-bit signed
  Uint8* = uint8         # 8-bit unsigned
  Sint16* = int16        # 16-bit signed
  Uint16* = uint16       # 16-bit unsigned
  Sint32* = int32        # 32-bit signed  
  Uint32* = uint32       # 32-bit unsigned
  Sint64* = int64        # 64-bit signed
  Uint64* = uint64       # 64-bit unsigned
  SdlBool* = uint8       # Boolean type

const
  SDL_TRUE* = 1'u8
  SDL_FALSE* = 0'u8
```

### Основные объекты

```nim
type
  SdlWindow* = ptr object              # Окно
  SdlRenderer* = ptr object            # Рендерер
  SdlTexture* = ptr object             # Текстура
  SdlSurface* = ptr SdlSurfaceObj      # Поверхность
  
  # Цвет RGBA
  SdlColor* {.bycopy.} = object
    r*, g*, b*, a*: uint8
  
  # Прямоугольник (float)
  SdlFRect* {.bycopy.} = object
    x*, y*, w*, h*: cfloat
  
  # Прямоугольник (int)
  SdlRect* {.bycopy.} = object
    x*, y*, w*, h*: cint
```

**Пример:**
```nim
let red = SdlColor(r: 255, g: 0, b: 0, a: 255)
var rect = SdlFRect(x: 100, y: 100, w: 200, h: 150)
```

---

## Инициализация и завершение

### Флаги инициализации

```nim
const
  SDL_INIT_AUDIO* = SdlInitFlags(0x00000010)
  SDL_INIT_VIDEO* = SdlInitFlags(0x00000020)
  SDL_INIT_JOYSTICK* = SdlInitFlags(0x00000200)
  SDL_INIT_HAPTIC* = SdlInitFlags(0x00001000)
  SDL_INIT_GAMEPAD* = SdlInitFlags(0x00002000)
  SDL_INIT_EVENTS* = SdlInitFlags(0x00004000)
  SDL_INIT_SENSOR* = SdlInitFlags(0x00008000)
  SDL_INIT_CAMERA* = SdlInitFlags(0x00010000)
```

### Функции

```nim
proc SDL_Init*(flags: SdlInitFlags): SdlBool
proc SDL_InitSubSystem*(flags: SdlInitFlags): SdlBool
proc SDL_QuitSubSystem*(flags: SdlInitFlags)
proc SDL_WasInit*(flags: SdlInitFlags): SdlInitFlags
proc SDL_Quit*()
```

**Пример:**
```nim
if SDL_Init(SDL_INIT_VIDEO or SDL_INIT_AUDIO) == SDL_FALSE:
  echo "SDL_Init failed: ", SDL_GetError()
  quit(1)

# Ваш код

SDL_Quit()
```

---

## Обработка ошибок

```nim
proc SDL_GetError*(): cstring                  # Получить текст ошибки
proc SDL_SetError*(fmt: cstring): cint         # Установить ошибку
proc SDL_ClearError*(): SdlBool                # Очистить ошибку
```

**Пример:**
```nim
let window = SDL_CreateWindow("Test", 800, 600, 0)
if window.isNil:
  echo "Error: ", SDL_GetError()
  quit(1)
```

---

## Работа с окнами

### Флаги окон

```nim
const
  SDL_WINDOW_FULLSCREEN* = 0x00000001'u64          # Полный экран
  SDL_WINDOW_OPENGL* = 0x00000002'u64              # OpenGL контекст
  SDL_WINDOW_HIDDEN* = 0x00000008'u64              # Скрыто
  SDL_WINDOW_BORDERLESS* = 0x00000010'u64          # Без рамки
  SDL_WINDOW_RESIZABLE* = 0x00000020'u64           # Изменяемый размер
  SDL_WINDOW_MINIMIZED* = 0x00000040'u64           # Минимизировано
  SDL_WINDOW_MAXIMIZED* = 0x00000080'u64           # Максимизировано
  SDL_WINDOW_HIGH_PIXEL_DENSITY* = 0x00002000'u64  # Высокая плотность пикселей
  SDL_WINDOW_VULKAN* = 0x10000000'u64              # Vulkan
  SDL_WINDOW_METAL* = 0x20000000'u64               # Metal
```

### Создание и управление

```nim
proc SDL_CreateWindow*(title: cstring, w, h: cint, flags: uint64): SdlWindow
proc SDL_DestroyWindow*(window: SdlWindow)
proc SDL_GetWindowID*(window: SdlWindow): SdlWindowID
proc SDL_GetWindowFromID*(id: SdlWindowID): SdlWindow
```

**Пример:**
```nim
let window = SDL_CreateWindow("My Game", 1280, 720, 
                              SDL_WINDOW_RESIZABLE or SDL_WINDOW_HIGH_PIXEL_DENSITY)
# ...
SDL_DestroyWindow(window)
```

### Размер и позиция

```nim
proc SDL_SetWindowSize*(window: SdlWindow, w, h: cint): SdlBool
proc SDL_GetWindowSize*(window: SdlWindow, w, h: ptr cint): SdlBool
proc SDL_SetWindowPosition*(window: SdlWindow, x, y: cint): SdlBool
proc SDL_GetWindowPosition*(window: SdlWindow, x, y: ptr cint): SdlBool
```

### Состояние

```nim
proc SDL_ShowWindow*(window: SdlWindow): SdlBool
proc SDL_HideWindow*(window: SdlWindow): SdlBool
proc SDL_MaximizeWindow*(window: SdlWindow): SdlBool
proc SDL_MinimizeWindow*(window: SdlWindow): SdlBool
proc SDL_RestoreWindow*(window: SdlWindow): SdlBool
proc SDL_SetWindowFullscreen*(window: SdlWindow, fullscreen: SdlBool): SdlBool
```

### Свойства

```nim
proc SDL_SetWindowTitle*(window: SdlWindow, title: cstring): SdlBool
proc SDL_GetWindowTitle*(window: SdlWindow): cstring
proc SDL_SetWindowIcon*(window: SdlWindow, icon: SdlSurface): SdlBool
proc SDL_SetWindowOpacity*(window: SdlWindow, opacity: cfloat): SdlBool
```

**Полный пример:**
```nim
let window = SDL_CreateWindow("Game", 800, 600, SDL_WINDOW_RESIZABLE)

# Установка минимального размера
discard SDL_SetWindowMinimumSize(window, 640, 480)

# Центрирование
const SDL_WINDOWPOS_CENTERED = 0x2FFF0000
discard SDL_SetWindowPosition(window, SDL_WINDOWPOS_CENTERED.cint, 
                              SDL_WINDOWPOS_CENTERED.cint)

# Полупрозрачность
discard SDL_SetWindowOpacity(window, 0.9)
```

---

## Рендеринг

### Создание рендерера

```nim
proc SDL_CreateRenderer*(window: SdlWindow, name: cstring): SdlRenderer
proc SDL_DestroyRenderer*(renderer: SdlRenderer)
proc SDL_GetRenderer*(window: SdlWindow): SdlRenderer
```

**Пример:**
```nim
let renderer = SDL_CreateRenderer(window, nil)
# ...
SDL_DestroyRenderer(renderer)
```

### Очистка и отображение

```nim
proc SDL_RenderClear*(renderer: SdlRenderer): SdlBool
proc SDL_RenderPresent*(renderer: SdlRenderer): SdlBool
```

### Цвета

```nim
proc SDL_SetRenderDrawColor*(renderer: SdlRenderer, r, g, b, a: uint8): SdlBool
proc SDL_SetRenderDrawColorFloat*(renderer: SdlRenderer, r, g, b, a: cfloat): SdlBool
```

### Примитивы

```nim
proc SDL_RenderPoint*(renderer: SdlRenderer, x, y: cfloat): SdlBool
proc SDL_RenderPoints*(renderer: SdlRenderer, points: ptr SdlFPoint, count: cint): SdlBool
proc SDL_RenderLine*(renderer: SdlRenderer, x1, y1, x2, y2: cfloat): SdlBool
proc SDL_RenderLines*(renderer: SdlRenderer, points: ptr SdlFPoint, count: cint): SdlBool
proc SDL_RenderRect*(renderer: SdlRenderer, rect: ptr SdlFRect): SdlBool
proc SDL_RenderFillRect*(renderer: SdlRenderer, rect: ptr SdlFRect): SdlBool
```

**Пример:**
```nim
# Очистка черным
discard SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255)
discard SDL_RenderClear(renderer)

# Красный прямоугольник
discard SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255)
var rect = SdlFRect(x: 100, y: 100, w: 200, h: 150)
discard SDL_RenderFillRect(renderer, addr rect)

# Синяя линия
discard SDL_SetRenderDrawColor(renderer, 0, 0, 255, 255)
discard SDL_RenderLine(renderer, 0, 0, 800, 600)

discard SDL_RenderPresent(renderer)
```

### VSync

```nim
proc SDL_SetRenderVSync*(renderer: SdlRenderer, vsync: cint): SdlBool
```

**Пример:**
```nim
discard SDL_SetRenderVSync(renderer, 1)  # Включить VSync
```

---

## Текстуры и поверхности

### Текстуры

```nim
proc SDL_CreateTexture*(renderer: SdlRenderer, format: uint32, access: cint, 
                        w, h: cint): SdlTexture
proc SDL_CreateTextureFromSurface*(renderer: SdlRenderer, surface: SdlSurface): SdlTexture
proc SDL_DestroyTexture*(texture: SdlTexture)
proc SDL_GetTextureSize*(texture: SdlTexture, w, h: ptr cfloat): SdlBool
proc SDL_SetTextureColorMod*(texture: SdlTexture, r, g, b: uint8): SdlBool
proc SDL_SetTextureAlphaMod*(texture: SdlTexture, alpha: uint8): SdlBool
```

### Рендеринг текстур

```nim
proc SDL_RenderTexture*(renderer: SdlRenderer, texture: SdlTexture, 
                        srcrect, dstrect: ptr SdlFRect): SdlBool
proc SDL_RenderTextureRotated*(renderer: SdlRenderer, texture: SdlTexture, 
                                srcrect, dstrect: ptr SdlFRect, 
                                angle: cdouble, center: ptr SdlFPoint, 
                                flip: SdlFlipMode): SdlBool
```

**Пример:**
```nim
let surface = SDL_LoadBMP("image.bmp")
let texture = SDL_CreateTextureFromSurface(renderer, surface)
SDL_DestroySurface(surface)

# Отображение
var dstRect = SdlFRect(x: 100, y: 100, w: 200, h: 200)
discard SDL_RenderTexture(renderer, texture, nil, addr dstRect)

SDL_DestroyTexture(texture)
```

### Поверхности

```nim
proc SDL_CreateSurface*(w, h: cint, format: uint32): SdlSurface
proc SDL_DestroySurface*(surface: SdlSurface)
proc SDL_LoadBMP*(file: cstring): SdlSurface
proc SDL_SaveBMP*(surface: SdlSurface, file: cstring): SdlBool
proc SDL_BlitSurface*(src: SdlSurface, srcrect: ptr SdlRect, 
                     dst: SdlSurface, dstrect: ptr SdlRect): SdlBool
```

---

## События

### Типы событий

```nim
const
  SDL_EVENT_QUIT* = 0x100
  SDL_EVENT_KEY_DOWN* = 0x300
  SDL_EVENT_KEY_UP* = 0x301
  SDL_EVENT_TEXT_INPUT* = 0x303
  SDL_EVENT_MOUSE_MOTION* = 0x400
  SDL_EVENT_MOUSE_BUTTON_DOWN* = 0x401
  SDL_EVENT_MOUSE_BUTTON_UP* = 0x402
  SDL_EVENT_MOUSE_WHEEL* = 0x403
  SDL_EVENT_WINDOW_RESIZED* = 0x206
```

### Структура события

```nim
type
  SdlEvent* {.union.} = object
    type*: uint32
    key*: SdlKeyboardEvent
    motion*: SdlMouseMotionEvent
    button*: SdlMouseButtonEvent
    wheel*: SdlMouseWheelEvent
    # ... другие типы
```

### Функции

```nim
proc SDL_PollEvent*(event: ptr SdlEvent): SdlBool
proc SDL_WaitEvent*(event: ptr SdlEvent): SdlBool
proc SDL_WaitEventTimeout*(event: ptr SdlEvent, timeoutMS: Sint32): SdlBool
proc SDL_PushEvent*(event: ptr SdlEvent): SdlBool
```

**Пример:**
```nim
var running = true
var event: SdlEvent

while running:
  while SDL_PollEvent(addr event) == SDL_TRUE:
    case event.type
    of SDL_EVENT_QUIT:
      running = false
    
    of SDL_EVENT_KEY_DOWN:
      if event.key.scancode == SDL_SCANCODE_ESCAPE:
        running = false
      echo "Key: ", event.key.scancode
    
    of SDL_EVENT_MOUSE_BUTTON_DOWN:
      echo &"Mouse at ({event.button.x}, {event.button.y})"
    
    of SDL_EVENT_MOUSE_MOTION:
      # Движение мыши
      discard
    
    else:
      discard
```

---

## Клавиатура

### Сканкоды

```nim
const
  SDL_SCANCODE_A* = 4
  SDL_SCANCODE_ESCAPE* = 41
  SDL_SCANCODE_SPACE* = 44
  SDL_SCANCODE_RETURN* = 40
  SDL_SCANCODE_LEFT* = 80
  SDL_SCANCODE_RIGHT* = 79
  SDL_SCANCODE_UP* = 82
  SDL_SCANCODE_DOWN* = 81
```

### Функции

```nim
proc SDL_GetKeyboardState*(numkeys: ptr cint): ptr uint8
proc SDL_GetModState*(): SdlKeymod
proc SDL_StartTextInput*(window: SdlWindow): SdlBool
proc SDL_StopTextInput*(window: SdlWindow): SdlBool
```

**Пример:**
```nim
# Проверка состояния клавиш
var numKeys: cint
let keyState = SDL_GetKeyboardState(addr numKeys)

if keyState[SDL_SCANCODE_W.ord] != 0:
  player.y -= speed

if keyState[SDL_SCANCODE_SPACE.ord] != 0:
  jump()

# Ввод текста
var textBuffer = ""
discard SDL_StartTextInput(window)

# В цикле событий
of SDL_EVENT_TEXT_INPUT:
  textBuffer.add($cast[cstring](addr event.text.text[0]))
```

---

## Мышь

### Кнопки

```nim
const
  SDL_BUTTON_LEFT* = 1'u8
  SDL_BUTTON_MIDDLE* = 2'u8
  SDL_BUTTON_RIGHT* = 3'u8
```

### Функции

```nim
proc SDL_GetMouseState*(x, y: ptr cfloat): SdlMouseButtonFlags
proc SDL_GetGlobalMouseState*(x, y: ptr cfloat): SdlMouseButtonFlags
proc SDL_WarpMouseInWindow*(window: SdlWindow, x, y: cfloat)
proc SDL_SetWindowRelativeMouseMode*(window: SdlWindow, enabled: SdlBool): SdlBool
proc SDL_ShowCursor*(): SdlBool
proc SDL_HideCursor*(): SdlBool
```

**Пример:**
```nim
var x, y: cfloat
let buttons = SDL_GetMouseState(addr x, addr y)

if (buttons and SDL_BUTTON_LMASK()) != 0:
  echo "Left button pressed"

# Относительный режим (для FPS)
discard SDL_SetWindowRelativeMouseMode(window, SDL_TRUE)
```

---

## Геймпад и джойстик

### Кнопки геймпада

```nim
const
  SDL_GAMEPAD_BUTTON_SOUTH* = 0        # A/Cross
  SDL_GAMEPAD_BUTTON_EAST* = 1         # B/Circle
  SDL_GAMEPAD_BUTTON_WEST* = 2         # X/Square
  SDL_GAMEPAD_BUTTON_NORTH* = 3        # Y/Triangle
```

### Оси

```nim
const
  SDL_GAMEPAD_AXIS_LEFTX* = 0
  SDL_GAMEPAD_AXIS_LEFTY* = 1
  SDL_GAMEPAD_AXIS_RIGHTX* = 2
  SDL_GAMEPAD_AXIS_RIGHTY* = 3
  SDL_GAMEPAD_AXIS_LEFT_TRIGGER* = 4
  SDL_GAMEPAD_AXIS_RIGHT_TRIGGER* = 5
```

### Функции

```nim
proc SDL_OpenGamepad*(instance_id: SdlJoystickID): SdlGamepad
proc SDL_CloseGamepad*(gamepad: SdlGamepad)
proc SDL_GetGamepadButton*(gamepad: SdlGamepad, button: SdlGamepadButton): SdlBool
proc SDL_GetGamepadAxis*(gamepad: SdlGamepad, axis: SdlGamepadAxis): Sint16
proc SDL_RumbleGamepad*(gamepad: SdlGamepad, low, high: uint16, duration_ms: uint32): SdlBool
```

**Пример:**
```nim
var count: cint
let gamepads = SDL_GetGamepads(addr count)

if count > 0:
  let gamepad = SDL_OpenGamepad(gamepads[0])
  
  # Проверка кнопок
  if SDL_GetGamepadButton(gamepad, SDL_GAMEPAD_BUTTON_SOUTH) == SDL_TRUE:
    jump()
  
  # Оси (от -32768 до 32767)
  let leftX = SDL_GetGamepadAxis(gamepad, SDL_GAMEPAD_AXIS_LEFTX)
  let leftY = SDL_GetGamepadAxis(gamepad, SDL_GAMEPAD_AXIS_LEFTY)
  
  if abs(leftX) > 8000:
    player.x += (leftX.float / 32768.0) * speed
  
  # Вибрация
  discard SDL_RumbleGamepad(gamepad, 32000, 32000, 100)
  
  SDL_CloseGamepad(gamepad)
```

---

## Таймеры и время

### Функции времени

```nim
proc SDL_GetTicks*(): uint64                      # Миллисекунды
proc SDL_GetTicksNS*(): uint64                    # Наносекунды
proc SDL_GetPerformanceCounter*(): uint64         # Высокоточный счётчик
proc SDL_GetPerformanceFrequency*(): uint64       # Частота счётчика
proc SDL_Delay*(ms: uint32)                       # Задержка
```

**Примеры:**
```nim
# Измерение времени
let startTime = SDL_GetTicks()
# ... код ...
let elapsed = SDL_GetTicks() - startTime
echo &"Elapsed: {elapsed} ms"

# FPS ограничение
SDL_Delay(16)  # ~60 FPS

# Delta time
var lastTime = SDL_GetTicks()
var deltaTime: float32

while running:
  let currentTime = SDL_GetTicks()
  deltaTime = (currentTime - lastTime).float32 / 1000.0
  lastTime = currentTime
  
  player.x += velocity.x * deltaTime
```

### Таймеры

```nim
proc SDL_AddTimer*(interval: uint32, callback: SdlTimerCallback, 
                   userdata: pointer): SdlTimerID
proc SDL_RemoveTimer*(id: SdlTimerID): SdlBool
```

---

## SDL_ttf - Работа со шрифтами

### Инициализация

```nim
proc TTF_Init*(): bool
proc TTF_Quit*()

# Helper функции
proc initTTF*(): bool
proc quitTTF*()
```

**Пример:**
```nim
if not initTTF():
  echo "TTF init failed"
  quit(1)

# В конце
quitTTF()
```

### Загрузка шрифтов

```nim
proc TTF_OpenFont*(file: cstring, ptsize: cfloat): TTF_Font
proc TTF_CloseFont*(font: TTF_Font)

# Helper
proc loadFont*(filename: string, size: float): TTF_Font
```

**Пример:**
```nim
let font = loadFont("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 24)
if font.isNil:
  echo "Failed to load font"
  quit(1)

# В конце
TTF_CloseFont(font)
```

### Свойства шрифта

```nim
proc TTF_SetFontSize*(font: TTF_Font, ptsize: cfloat): bool
proc TTF_GetFontSize*(font: TTF_Font): cfloat
proc TTF_SetFontStyle*(font: TTF_Font, style: cint)
proc TTF_GetFontStyle*(font: TTF_Font): cint
proc TTF_SetFontOutline*(font: TTF_Font, outline: cint): bool

# Метрики
proc TTF_GetFontHeight*(font: TTF_Font): cint
proc TTF_GetFontAscent*(font: TTF_Font): cint
proc TTF_GetFontDescent*(font: TTF_Font): cint
```

### Рендеринг текста

```nim
proc TTF_RenderText_Solid*(font: TTF_Font, text: cstring, length: csize_t, 
                           fg: SdlColor): SdlSurface
proc TTF_RenderText_Shaded*(font: TTF_Font, text: cstring, length: csize_t, 
                            fg, bg: SdlColor): SdlSurface
proc TTF_RenderText_Blended*(font: TTF_Font, text: cstring, length: csize_t, 
                             fg: SdlColor): SdlSurface

# Helper функции
proc renderTextSolid*(font: TTF_Font, text: string, color: SdlColor): SdlSurface
proc renderTextShaded*(font: TTF_Font, text: string, fg, bg: SdlColor): SdlSurface
proc renderTextBlended*(font: TTF_Font, text: string, color: SdlColor): SdlSurface
proc getTextSize*(font: TTF_Font, text: string): tuple[w, h: int]
```

**Полный пример:**
```nim
# Инициализация
if not initTTF():
  quit(1)

# Загрузка шрифта
let font = loadFont("font.ttf", 24)

# Рендеринг
let white = SdlColor(r: 255, g: 255, b: 255, a: 255)
let surface = renderTextBlended(font, "Hello, World!", white)
let texture = SDL_CreateTextureFromSurface(renderer, surface)
SDL_DestroySurface(surface)

# Отображение
var w, h: cfloat
discard SDL_GetTextureSize(texture, addr w, addr h)
var rect = SdlFRect(x: 100, y: 100, w: w, h: h)
discard SDL_RenderTexture(renderer, texture, nil, addr rect)

# Получение размера
let (textW, textH) = getTextSize(font, "Test")

# Очистка
SDL_DestroyTexture(texture)
TTF_CloseFont(font)
quitTTF()
```

---

## Аудио

### Форматы

```nim
const
  SDL_AUDIO_U8* = 0x0008      # Unsigned 8-bit
  SDL_AUDIO_S16* = 0x8010     # Signed 16-bit
  SDL_AUDIO_S32* = 0x8020     # Signed 32-bit
  SDL_AUDIO_F32* = 0x8120     # Float 32-bit
```

### Спецификация аудио

```nim
type
  SdlAudioSpec* {.bycopy.} = object
    format*: uint32
    channels*: cint
    freq*: cint
```

### Функции

```nim
proc SDL_OpenAudioDevice*(devid: SdlAudioDeviceID, spec: ptr SdlAudioSpec): SdlAudioDeviceID
proc SDL_CloseAudioDevice*(dev: SdlAudioDeviceID)
proc SDL_PauseAudioDevice*(dev: SdlAudioDeviceID): SdlBool
proc SDL_ResumeAudioDevice*(dev: SdlAudioDeviceID): SdlBool
```

### Аудиопотоки

```nim
proc SDL_CreateAudioStream*(src_spec, dst_spec: ptr SdlAudioSpec): SdlAudioStream
proc SDL_DestroyAudioStream*(stream: SdlAudioStream)
proc SDL_PutAudioStreamData*(stream: SdlAudioStream, buf: pointer, len: cint): SdlBool
proc SDL_GetAudioStreamData*(stream: SdlAudioStream, buf: pointer, len: cint): cint
```

---

## GPU (Новый SDL3 API)

```nim
proc SDL_CreateGPUDevice*(format_flags: SdlGpuShaderFormat, debug_mode: bool, 
                          name: cstring): SdlGpuDevice
proc SDL_DestroyGPUDevice*(device: SdlGpuDevice)
proc SDL_CreateGPUBuffer*(device: SdlGpuDevice, 
                          createinfo: ptr SdlGpuBufferCreateInfo): SdlGpuBuffer
proc SDL_CreateGPUTexture*(device: SdlGpuDevice, 
                           createinfo: ptr SdlGpuTextureCreateInfo): SdlGpuTexture
proc SDL_AcquireGPUCommandBuffer*(device: SdlGpuDevice): SdlGpuCommandBuffer
proc SDL_SubmitGPUCommandBuffer*(command_buffer: SdlGpuCommandBuffer): SdlBool
```

---

## Файловый ввод-вывод

```nim
const
  SDL_IO_SEEK_SET* = 0
  SDL_IO_SEEK_CUR* = 1
  SDL_IO_SEEK_END* = 2

proc SDL_IOFromFile*(file: cstring, mode: cstring): SdlIOStream
proc SDL_CloseIO*(context: SdlIOStream): SdlBool
proc SDL_ReadIO*(context: SdlIOStream, ptr_: pointer, size: csize_t): csize_t
proc SDL_WriteIO*(context: SdlIOStream, ptr_: pointer, size: csize_t): csize_t
proc SDL_SeekIO*(context: SdlIOStream, offset: Sint64, whence: SdlIOWhence): Sint64
proc SDL_TellIO*(context: SdlIOStream): Sint64
```

**Пример:**
```nim
let file = SDL_IOFromFile("data.bin", "rb")
if not file.isNil:
  var buffer: array[1024, byte]
  let bytesRead = SDL_ReadIO(file, addr buffer[0], buffer.len.csize_t)
  echo &"Read {bytesRead} bytes"
  discard SDL_CloseIO(file)
```

---

## Потоки и синхронизация

### Потоки

```nim
proc SDL_CreateThread*(fn: SdlThreadFunction, name: cstring, 
                       data: pointer): SdlThread
proc SDL_WaitThread*(thread: SdlThread, status: ptr cint)
proc SDL_DetachThread*(thread: SdlThread)
```

### Мьютексы

```nim
proc SDL_CreateMutex*(): SdlMutex
proc SDL_DestroyMutex*(mutex: SdlMutex)
proc SDL_LockMutex*(mutex: SdlMutex): SdlBool
proc SDL_TryLockMutex*(mutex: SdlMutex): SdlBool
proc SDL_UnlockMutex*(mutex: SdlMutex): SdlBool
```

### Семафоры

```nim
proc SDL_CreateSemaphore*(initial_value: uint32): SdlSemaphore
proc SDL_DestroySemaphore*(sem: SdlSemaphore)
proc SDL_WaitSemaphore*(sem: SdlSemaphore): SdlBool
proc SDL_PostSemaphore*(sem: SdlSemaphore): SdlBool
```

---

## Дополнительно

### Камера

```nim
proc SDL_GetCameras*(count: ptr cint): ptr SdlCameraID
proc SDL_OpenCamera*(instance_id: SdlCameraID, spec: ptr SdlCameraSpec): SdlCamera
proc SDL_CloseCamera*(camera: SdlCamera)
proc SDL_AcquireCameraFrame*(camera: SdlCamera, timestampNS: ptr uint64): SdlSurface
proc SDL_ReleaseCameraFrame*(camera: SdlCamera, frame: SdlSurface)
```

### Сенсоры

```nim
proc SDL_GetSensors*(count: ptr cint): ptr SdlSensorID
proc SDL_OpenSensor*(instance_id: SdlSensorID): SdlSensor
proc SDL_CloseSensor*(sensor: SdlSensor)
proc SDL_GetSensorData*(sensor: SdlSensor, data: ptr cfloat, num_values: cint): SdlBool
```

### Буфер обмена

```nim
proc SDL_SetClipboardText*(text: cstring): SdlBool
proc SDL_GetClipboardText*(): cstring
proc SDL_HasClipboardText*(): SdlBool
```

### Системная информация

```nim
proc SDL_GetPlatform*(): cstring
proc SDL_GetCPUCount*(): cint
proc SDL_GetCPUCacheLineSize*(): cint
proc SDL_GetSystemRAM*(): cint
```

---

## 📚 Дополнительные ресурсы

- [Официальная документация SDL3](https://wiki.libsdl.org/SDL3/FrontPage)
- [SDL3_ttf документация](https://wiki.libsdl.org/SDL3_ttf)
- [GitHub репозиторий SDL3](https://github.com/libsdl-org/SDL)
- [Примеры кода](examples/)

---

**Версия:** 0.1 | **Дата:** 2026-02-13 | **Автор:** [Balans097](https://github.com/Balans097)
