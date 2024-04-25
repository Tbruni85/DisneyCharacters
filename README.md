# DisneyCharacters
Test project to display a possible UI representation of the data provided by [Disney API](https://disneyapi.dev/)

## Architecture Approach
The project has been developed in SwiftUI using MVVM as the base design pattern.
The main components are:
* Interactor
* Model
* ViewModel
* Views

### Interactor
A generic class capable of requesting data based on the provided URL.

### Model
Data model mapping the API response.

### ViewModel
It's the logic unit of the project. It processes and handles data instructing the UI on what to display.

### Views
UI representation of the data provided by the ViewModel.

This approach, in my opinion, provides full separation of concerns allowing, via dependency injection, the testability of each component.
Due to the scope and size of the project, the ViewModel is shared as an EvironmenObject.

## Favourite data persistence
Data persistence has been implemented creating a file in the document folder. The file is a JSON representation of the favourite characters.
For the scope of this test project, I consider this a proper solution, taking advantage of the Model structure.
More complex solutions, such as CoreData, or SwiftData, are overly complicated for this project.

### Unit Test
The ViewModel has been fully tested via unit tests



### Preview
![preview](https://github.com/Tbruni85/DisneyCharacters/assets/13588914/bd9bcabd-1414-482b-bcf3-eb50d37a8a96)
