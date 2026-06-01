# ⚡ Pokémon Combat Analytics Dashboard

A professional-grade Pokémon stats tracker and combat analytics tool built with Flutter.

## Features

- **Smart Search**: Full-text search across Pokémon names and types
- **Offline-First**: Local caching with HiveDB for instant access
- **Combat Analytics**: Detailed performance analysis with custom scoring
- **Auto-Color Extraction**: Extracts dominant colors from Pokémon sprites
- **Head-to-Head**: Compare Pokémon stats and determine battle winners
- **Responsive UI**: Adaptive layout for different screen sizes

## Tech Stack

- **Framework**: Flutter 3
- **Architecture**: Clean Architecture (Separation of concerns)
- **State Management**: BLoC pattern with Flutter BLoC
- **Networking**: Dio with API versioning
- **Database**: Hive for local caching
- **Charts**: `fl_chart` library
- **Image Handling**: `cached_network_image` and `palette_generator`

## Getting Started

### Prerequisites

- Flutter SDK >= 3.10
- Dart SDK >= 3.0

### Installation

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

### Development

Run the app in development mode:
```bash
flutter run
```

## Project Structure

```
pokemon/
├── lib/
│   ├── core/
│   │   ├── network/         # API client and endpoints
│   │   └── theme/           # Theming and constants
│   ├── features/
│   │   └── pokemon/
│   │       ├── data/          # Models, repositories, data sources
│   │       ├── domain/        # Entities, use cases
│   │       └── presentation/  # Screens, widgets, BLoCs
│   ├── main.dart           # App entry point
│   └── injection_container.dart # Dependency injection
└── pubspec.yaml
```

## Screen Overview

### 1. Home Screen
- Displays list of Pokémon with quick stats
- Search functionality with type filtering
- "Hero" Pokémon feature with animation

### 2. Pokémon List Screen
- Grid view of all Pokémon
- Skeleton loaders during initial fetch
- Smooth transitions between screens

### 3. Combat Analytics Screen
- Detailed stat breakdown (HP, Attack, Defense, Speed)
- TCP (True Combat Power) calculation
- Bar charts for visualization
- Head-to-head comparison with winner declaration
- Type effectiveness analysis

## How It Works

1. **Initialization**: `injection_container.dart` sets up all dependencies
2. **Data Fetching**: Uses `RemoteDataSource` to get data from Pokémon API
3. **Caching**: Caches all Pokémon data locally using Hive for offline access
4. **State Management**: BLoCs manage UI state and user interactions
5. **UI Rendering**: Widgets display data with smooth animations and transitions

## Custom Features

### True Combat Power (TCP)
Calculates a comprehensive combat score using the formula:
```
TCP = (ATK * 1.5) + SP.ATK + DEF + SPD + HP
```

### Color Extraction
Extracts dominant colors from Pokémon sprites using `palette_generator` to create beautiful gradients for each Pokémon.

### Hero Banner
Features an animated hero section that transitions smoothly to the details screen, showcasing the top fighter in style.

## Dependencies

- `flutter_bloc`: State management
- `dio`: HTTP client
- `hive`, `hive_flutter`: Local database
- `fl_chart`: Charting library
- `cached_network_image`: Image caching
- `palette_generator`: Color extraction


## Contributing
Contributions are welcome! Please open an issue or submit a pull request.
