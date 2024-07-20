# SpaceX Launches App

![SpaceX Launches App](https://github.com/user-attachments/assets/fd202887-d67d-4863-b506-6bc724a8e854)

## Overview

The SpaceX Launches app is a SwiftUI-based application designed to display SpaceX launches using modern Swift technologies. This app utilizes the MVVM (Model-View-ViewModel) design pattern, SwiftData for data management, and URLSession for networking.

## Requirements

- **Xcode**: 15.4 or later
- **iOS**: 17.0 or later

## Architecture

### MVVM Design Pattern

The app adheres to the MVVM architecture, which organizes the code into three distinct layers:

- **Model**: Manages data and main business logic.
- **View**: Handles the UI and user interactions.
- **ViewModel**: Serves as an intermediary between the Model and View, managing presentation logic and data transformation.

### Folder Descriptions

- **`Models/`**: Contains data models used by the application. This includes representations of SpaceX launches, rockets, and related data.
- **`Network/`**: Includes networking components and protocols for handling API requests and responses.
- **`Preview Content/`**: Contains assets used for SwiftUI previews.
- **`Utils/`**: Utility files and extensions used across the application.
- **`ViewModels/`**: Contains the ViewModel classes that manage data and business logic for the views.
- **`Views/`**: Contains SwiftUI views and UI components used in the app.
- **`SpaceXLaunchesApp.swift`**: The main entry point of the application that sets up the app and initializes the `ModelContainer`.

### Components

#### Model

- **`Launch`**: Represents a SpaceX launch, including details such as launch date, mission name, rocket ID, and related links.
- **`Rocket`**: Contains details about a SpaceX rocket, including its ID, name, and type.
- **`LaunchFailure`, `LaunchLink`**: Additional data models related to launches.

These models are structured using SwiftData's `ModelContainer`.

#### View

- **`LaunchListView`**: Displays a list of launches. It uses `LaunchesViewModel` to fetch and present data and includes UI components like a launch picker and list.
- **`DetailView`**: Shows detailed information about a selected launch. It uses `LaunchDetailViewModel` to fetch and display rocket details along with other launch information.

#### ViewModel

- **`LaunchesViewModel`**: Handles fetching and filtering of launch data. It interacts with `NetworkService` to retrieve data and manage errors.
  - **`ModelContextProtocol`**: Protocol for managing data context, which is implemented by `SwiftDataModelContext`.
  - **`SwiftDataModelContext`**: Concrete implementation of `ModelContextProtocol` that interacts with SwiftData for data persistence.
- **`LaunchDetailViewModel`**: Manages the fetching and displaying of rocket details for a specific launch, ensuring that data is fetched only when needed.
  - **`ModelContextProtocol`**: Protocol for managing data context, which is implemented by `SwiftDataModelContext`.

### Networking

- **`NetworkService`**: Defines the protocol for network operations to fetch launches and rocket details.
- **`SpaceXNetworkService`**: Concrete implementation that interacts with the SpaceX API, using `URLSession` for network requests.
- **`URLSessionProtocol`**: Abstracts network requests and is implemented by `URLSession`.

### Data Management

- **SwiftData**: Manages local data storage using `ModelContainer`, with a schema to handle data persistence.

### Error Handling

- **`LaunchesViewModel`** and **`LaunchDetailViewModel`** include error handling mechanisms to manage and display error messages effectively.

### App Entry Point

- **`SpaceXLaunchesApp`**: The main entry point of the application. It initializes the `ModelContainer` and sets up the initial view with `LaunchListView`.

## Getting Started

To get started with the SpaceX Launches app:

1. **Clone the repository**: `git clone <repository-url>`
2. **Open the project** in Xcode 15.
3. **Ensure you have the necessary dependencies** and that you are running iOS 17.0 or later.

## Next Steps and Potential Improvements

Here are some areas for future enhancement:

1. **Enhance Error Handling**:
   - **Description**: Introduce a centralized error handling system or more detailed error reporting.

2. **Add Unit and Integration Tests**:
   - **Description**: Write comprehensive unit tests for ViewModels and integration tests for network interactions.

3. **Improve UI/UX**:
   - **Description**: Add loading indicators, animations, and more user feedback mechanisms. Explore accessibility improvements.

4. **Abstract Network Layer Further**:
   - **Description**: Enhance the abstraction of the network layer to support additional APIs or services.

5. **Implement Localization**:
   - **Description**: Add support for multiple languages by localizing error messages and other text elements.

