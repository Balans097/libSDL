# SDL3 Nim Wrapper - Test Applications

Тестовые приложения для проверки работы обёртки SDL3 для Nim.

## Файлы

- **libSDL.nim** - Полная обёртка SDL3 для Nim
- **sdl3_minimal.nim** - Минимальный пример использования (рекомендуется для начала)
- **sdl3_test.nim** - Комплексное тестовое приложение со всеми подсистемами
- **README.md** - Этот файл

## Требования

### Системные зависимости

Вам нужно установить SDL3 в вашей системе:

#### Linux (Ubuntu/Debian)
```bash
# SDL3 пока не в основных репозиториях, нужно собрать из исходников
git clone https://github.com/libsdl-org/SDL.git
cd SDL
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install
sudo ldconfig
```

#### macOS
```bash
# Через Homebrew (если доступно)
brew install sdl3

# Или собрать из исходников
git clone https://github.com/libsdl-org/SDL.git
cd SDL
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(sysctl -n hw.ncpu)
sudo make install
```

#### Windows
1. Скачайте SDL3 development libraries с https://github.com/libsdl-org/SDL/releases
2. Извлеките SDL3.dll в папку с исполняемым файлом
3. Или добавьте путь к SDL3.dll в PATH

### Nim

Убедитесь, что у вас установлен Nim (версия 2.0 или выше):
```bash
nim --version
```

## Компиляция и запуск

### Минимальный пример (рекомендуется начать с него)

```bash
# Компиляция
nim c -r sdl3_minimal.nim

# Или с оптимизацией
nim c -d:release -r sdl3_minimal.nim
```

**Что делает минимальный пример:**
- Инициализирует SDL3
- Создаёт окно 800x600
- Отображает 5 анимированных цветных прямоугольников
- Обрабатывает события (ESC для выхода)
- Демонстрирует базовый рендеринг

### Комплексное тестовое приложение

```bash
# Компиляция
nim c -r sdl3_test.nim

# Или с оптимизацией
nim c -d:release -r sdl3_test.nim
```

**Что тестирует комплексное приложение:**
- ✅ Версия SDL и информация о ревизии
- ✅ Информация о CPU (количество ядер, кэш, SIMD инструкции)
- ✅ Информация о дисплеях (разрешение, частота обновления)
- ✅ Таймеры высокой точности
- ✅ Файловая система (пути приложения, пользовательские папки)
- ✅ Буфер обмена (установка и получение текста)
- ✅ Аудио устройства (перечисление, открытие)
- ✅ Джойстики и геймпады
- ✅ Создание окна и рендерера
- ✅ Обработка событий (клавиатура, мышь, окно)
- ✅ 2D рендеринг (прямоугольники, линии, примитивы)
- ✅ Анимация
- ✅ Подсчёт FPS

**Управление в тестовом приложении:**
- `ESC` - Выход
- `F` - Переключение полноэкранного режима
- `Левая кнопка мыши` - Рисование круга вокруг курсора

## Ожидаемый вывод

### При успешном запуске вы должны увидеть:

```
SDL3 Nim Wrapper - Comprehensive Test Application
==================================================

=== Testing SDL Version ===
SDL Version: 3.5.0
SDL Revision: release-3.2.0-0-gabcdef12
Platform: Linux

=== Testing CPU Information ===
CPU Count: 8
CPU Cache Line Size: 64
System RAM: 16384 MB
CPU Features:
  - SSE
  - SSE2
  - SSE3
  - SSE4.1
  - SSE4.2
  - AVX
  - AVX2

=== Testing Display Information ===
Number of displays: 1

Display 0:
  Name: Built-in Display
  Bounds: 0x0 - 1920x1080
  Current Mode: 1920x1080 @ 60.00Hz
  Pixel Format: RGB888

... (и так далее)

=== Running Main Loop ===
Controls:
  ESC - Quit
  F - Toggle Fullscreen
  Left Mouse - Draw circle at cursor

FPS: 60.02
FPS: 59.98
FPS: 60.01
...
```

### Визуально вы должны увидеть:
- Окно с анимированным градиентным фоном
- 5 цветных прямоугольников, двигающихся вверх-вниз
- Вращающиеся линии в центре экрана
- Крестик на позиции курсора мыши
- Круг вокруг курсора при нажатии левой кнопки мыши

## Устранение неполадок

### Ошибка: "could not load: libSDL3.so"

**Решение:**
```bash
# Проверьте, установлена ли SDL3
ldconfig -p | grep SDL3

# Если не найдена, установите или добавьте в LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
```

### Ошибка: "SDL_Init failed: No available video device"

**Решение:**
- Убедитесь, что у вас есть графическая среда (X11/Wayland)
- Проверьте переменную DISPLAY: `echo $DISPLAY`
- Для удалённого подключения используйте X forwarding: `ssh -X`

### Ошибка компиляции Nim

**Решение:**
```bash
# Убедитесь, что libSDL.nim находится в той же папке
ls -la libSDL.nim

# Или укажите путь явно
nim c --path:. sdl3_test.nim
```

### Низкий FPS или медленная работа

**Решение:**
```bash
# Компилируйте с оптимизациями
nim c -d:release --opt:speed sdl3_test.nim

# Проверьте, включён ли VSync
# В тестовом приложении VSync включается автоматически
```

## Структура обёртки

### Покрытые подсистемы SDL3:

#### Основные подсистемы
- ✅ Инициализация и конфигурация
- ✅ Обработка ошибок
- ✅ Система свойств (Properties)
- ✅ Логирование

#### Видео и рендеринг
- ✅ Дисплеи и мониторы
- ✅ Окна (создание, управление, события)
- ✅ OpenGL/Vulkan/Metal контексты
- ✅ 2D рендеринг (примитивы, текстуры, геометрия)
- ✅ Поверхности и пиксельные форматы

#### Ввод
- ✅ События (Event System)
- ✅ Клавиатура (scancodes, keycodes, текстовый ввод)
- ✅ Мышь (движение, кнопки, колесико, курсоры)
- ✅ Джойстики (оси, кнопки, вибрация)
- ✅ Геймпады (стандартизированный API)

#### Аудио
- ✅ Устройства воспроизведения и записи
- ✅ Аудио потоки (Audio Streams)
- ✅ Загрузка WAV файлов
- ✅ Микширование

#### Системные функции
- ✅ Таймеры высокой точности
- ✅ Потоки (Threads, Mutex, Semaphore, etc.)
- ✅ Файловый ввод-вывод (SDL_IOStream)
- ✅ Файловая система
- ✅ Буфер обмена
- ✅ Информация о CPU и системе
- ✅ Управление питанием
- ✅ Локализация

## Дополнительные примеры

### Создание текстуры из поверхности

```nim
import libSDL

# Загрузить изображение
let surface = SDL_LoadBMP("image.bmp")
if surface.isNil:
  echo "Error loading BMP: ", SDL_GetError()
else:
  # Создать текстуру
  let texture = SDL_CreateTextureFromSurface(renderer, surface)
  SDL_DestroySurface(surface)
  
  if not texture.isNil:
    # Отрисовать текстуру
    discard SDL_RenderTexture(renderer, texture, nil, nil)
    SDL_DestroyTexture(texture)
```

### Обработка клавиатуры

```nim
var event: SdlEvent
while SDL_PollEvent(addr event) == SDL_TRUE:
  if event.type == SDL_EVENT_KEY_DOWN:
    case event.key.scancode
    of SDL_SCANCODE_UP:
      echo "Up arrow pressed"
    of SDL_SCANCODE_DOWN:
      echo "Down arrow pressed"
    of SDL_SCANCODE_SPACE:
      echo "Space pressed"
    else:
      discard
```

### Работа с аудио

```nim
# Открыть аудио устройство
var spec: SdlAudioSpec
spec.format = SDL_AUDIO_F32
spec.channels = 2
spec.freq = 48000

let device = SDL_OpenAudioDevice(0, addr spec)
if device != 0:
  # Создать аудио поток
  let stream = SDL_OpenAudioDeviceStream(device, addr spec, nil, nil)
  
  # ... использовать поток ...
  
  SDL_DestroyAudioStream(stream)
  SDL_CloseAudioDevice(device)
```

## Документация

Полная документация SDL3 доступна на:
- https://wiki.libsdl.org/SDL3/FrontPage
- https://github.com/libsdl-org/SDL

## Лицензия

SDL3 распространяется под лицензией zlib.
Эта обёртка создана для использования с SDL3 и следует той же лицензии.

## Вклад

Если вы нашли ошибку или хотите улучшить обёртку:
1. Проверьте, что ошибка воспроизводится
2. Создайте минимальный пример, демонстрирующий проблему
3. Опишите ожидаемое и фактическое поведение

## Автор

SDL3 Nim Wrapper создан в 2026 году.
SDL3 разработан Sam Lantinga и сообществом SDL.
