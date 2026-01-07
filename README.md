# weather-app
iOS application that uses the WeatherApi API where you can view the weather of a location, as well as the forecast for the following days.

## Characteristics

- **Real-time city search**: Search cities and locations with live suggestions as you type, including proper handling of error and empty states.
- **Current and extended forecast**: Displays current weather conditions (temperature, feels-like, humidity, wind), along with hourly and daily forecasts.
- **Persistent favorites**: Add and remove favorite locations with local persistence.
- **Reactive UI with SwiftUI**: views and reusable components.
- **Results caching**: Reduces unnecessary network calls to improve performance and responsiveness.
- **Robust networking layer**: Typed API layer with safe decoding, timeout handling, and retry mechanisms.
- **Testing**: Includes unit tests for domain and networking layers.
- **Linting and resource generation**: Integrated with **SwiftLint** and **SwiftGen** to ensure code consistency and type-safe resources.


## Key Features

- **Modular architecture**: Organized into layers that separate responsibilities (Data, Domain, UI, etc.).
- **Modern compatibility**: Built with SwiftUI and compatible with Apple’s latest tools.
- **Advanced testing support**: Includes tools like **Swift Testing** and **SwiftLint**, along with unit testing.



# Modules

Weather-app is designed as a multimodular system to enhance scalability and maintainability. Below is a description of the available modules:

### 1. Features
The main module orchestrating the core operations and functionalities.

### 2. Common
Includes structures, utilities, and reusable classes across the project.

### 3. Core
Includes Coordinator pattern to navigation management in the App.

### 4. DataLayer
Responsible for data management. Includes services, repositories, and logic related to data persistence and consumption.

### 5. DomainLayer
Contains the entities, use cases, and business logic defining the application domain.

### 6. LocalizedString
Manages the texts and wordings used in the application, centralizing localization for multiple languages.

### 7. Networking
Handles network requests and responses, including validations and service-specific configurations.



# Architecture

- **Presentation (SwiftUI)**:  
  - **Views**: Render application state and handle user interaction.  
  - **ViewModels**: Orchestrate presentation logic, expose `@Published` / `@State`, and coordinate navigation flows.

- **Domain**:  
  - **Use cases / Services**: Encapsulate business rules and compose repositories.  
  - **Domain models**: Framework-agnostic entities representing core concepts.

- **Data**:  
  - **Repositories**: Abstractions over data sources (network, cache, persistence).  
  - **Data sources**: Concrete implementations such as APIs and local storage.

- **Infrastructure**:  
  - **Networking**: HTTP client (`URLSession` with `async/await`), decoders, and endpoints.  
  - **Persistence**: Local storage using UserDefaults, SwiftData, or CoreData depending on the use case.

- **Utilities**:  
  - **Helpers and extensions**: Mappers, formatters, and shared utility components.

- **Configuration**:  
  - **Tooling and setup**: SwiftGen, SwiftLint, build schemes, and environment configuration.




# Code Style

The project uses SwiftLint to ensure consistency and adherence to code conventions.


# Requirements

- **Xcode 15+**
- **iOS 16+**


## How to Run

1. Open the project in **Xcode**.
2. Select the **Weather** scheme.
3. Run the application using **Cmd + R**.

### Running Tests
- To run unit tests, go to **Product → Test** or press **Cmd + U**.

<img width="400" alt="Test success" src="https://github.com/user-attachments/assets/1124e50a-7c19-43d7-a3b8-286cf0e83072" />


### Development Tools Setup

This project uses additional tools to ensure code quality and type-safe resources.  
Make sure you have them installed locally before building the project.

#### Install Homebrew (required)
If you don’t have Homebrew installed:

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#### Install SwiftLint (required)
Used to enforce code style and best practices.

brew install swiftlint

#### Install SwiftGen (required)
Used to generate type-safe access to localized strings and other resources.

brew install swiftgen

# Screenshots

<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-01-05 at 23 30 44" src="https://github.com/user-attachments/assets/a1198349-1fc7-4f5e-9567-19064f7ccd7c" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-01-05 at 23 30 47" src="https://github.com/user-attachments/assets/a12f5e21-a716-4e8b-9c5f-40ed46bdd56d" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-01-05 at 23 30 57" src="https://github.com/user-attachments/assets/b891e8d1-ab17-4228-98a9-245a14a6468f" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-01-05 at 23 31 01" src="https://github.com/user-attachments/assets/a17e797b-2630-4a90-95cb-d83c4a75cae7" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-01-05 at 23 31 13" src="https://github.com/user-attachments/assets/45d89199-bdbd-4675-bdbc-2cd983d1e62f" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-01-05 at 23 31 40" src="https://github.com/user-attachments/assets/34b83095-edc9-4048-9865-1c43e4825cd0" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-01-05 at 23 32 24" src="https://github.com/user-attachments/assets/8fd97c64-5cff-4f5e-94fd-4e9f0a36385a" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-01-05 at 23 41 05" src="https://github.com/user-attachments/assets/882b2f8f-d789-4d9f-98d2-a424b3673c0b" />
<img height="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-01-05 at 23 31 21" src="https://github.com/user-attachments/assets/3eacd5aa-3676-4816-b8ac-52a2382bb882" />
<img height="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-01-05 at 23 31 45" src="https://github.com/user-attachments/assets/a369448d-fb8c-4bce-a048-d48b2ac1f1a2" />
<img height="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-01-05 at 23 32 29" src="https://github.com/user-attachments/assets/ed0408ee-4cd2-4e4d-bf6f-0270855d03e6" />

