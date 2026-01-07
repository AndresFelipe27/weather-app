# weather-app
iOS application that uses the WeatherApi API where you can view the weather of a location, as well as the forecast for the following days.

## Características

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




