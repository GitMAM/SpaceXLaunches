# SpaceX Launches App

## Overview

The SpaceX Launches app is a SwiftUI-based application designed to display SpaceX launches using modern Swift technologies. This app utilizes the MVVM (Model-View-ViewModel) design pattern, SwiftData for data management, and URLSession for networking.

## Requirements

- **Xcode**: 15 or later
- **iOS**: 17.0 or later

## Architecture

### MVVM Design Pattern

The app adheres to the MVVM architecture, which organizes the code into three distinct layers:

- **Model**: Manages data and business logic.
- **View**: Handles the UI and user interactions.
- **ViewModel**: Serves as an intermediary between the Model and View, managing presentation logic and data transformation.

### Components

#### Model

- **`Launch`**: Represents a SpaceX launch, including details like launch date, mission name, and related links.
- **`Rocket`**: Contains details about a SpaceX rocket.
- **`LaunchFailure`, `LaunchLink`**: Additional data models related to launches.

These models are structured using SwiftData's `ModelContainer`.

#### View

- **`LaunchListView`**: Displays a list of launches. It uses `LaunchesViewModel` to fetch and present data and includes UI components like a launch picker and list.
- **`DetailView`**: Shows detailed information about a selected launch. It uses `LaunchDetailViewModel` to fetch and display rocket details along with other launch information.

#### ViewModel

- **`LaunchesViewModel`**: Handles fetching and filtering of launch data. It interacts with `NetworkService` to retrieve data and manage errors.
- **`LaunchDetailViewModel`**: Manages the fetching and displaying of rocket details for a specific launch, ensuring that data is fetched only when needed.

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


