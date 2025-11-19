# WeatherNotes

WeatherNotes — невеликий iOS-додаток, де користувач може створювати нотатки, а при створенні автоматично зберігається погода та локація в момент запису.

## Features

- Додавання нотаток
- Автоматичне визначення погоди через OpenWeather API
- GPS-локація або fallback на Kyiv
- Список нотаток із:
  - текстом
  - датою створення
  - температурою та іконкою
- Детальний екран однієї нотатки
- Локальне збереження (UserDefaults)
- Видалення свайпом
- Підтримка світлої/темної теми

## Tech Stack

- Swift 5
- SwiftUI
- MVVM
- URLSession
- CoreLocation
- UserDefaults

## Project Structure
App/
Models/
Services/
Storage/
ViewModels/
Views/

## Setup

1. Відкрити проект у Xcode 16+ / 26.1
2. В Info.plist знаходиться ключ:OPENWEATHER_API_KEY
3. Запустити на симуляторі або девайсі.
4. Для тестів локації: Xcode → Features → Location.

## Notes

- Якщо GPS недоступний — використовується аналог “Kyiv (default)”.
