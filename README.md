# Modulazied iOS App Tamplate

A demo for trying out new APIs and iOS ideas.
This project showcases the setup of a SwiftUI app with modularized Clean Architecture.
It can be used as a starting point for a project. Simply delete unneeded targets/packages and rename entities as needed.

## Key features

* Vanilla **SwiftUI** implementation
* Decoupled **Presentation**, **Business Logic**, and **Data Access** layers
* **Modularized** with SPM - Designed for scalability. It can be used as a reference for building large production apps
* Simple yet flexible vanila **Networking Layer** built on Generics
* Unit Test Coverage with **Swift Testing**
* Reactive State Management of shared state with **Combine**

## Architecture Quick View

### System Overview

```mermaid
flowchart TB
  subgraph Apps
    MainApp["Movies\n(ApplicationNameApp)"]
    PreviewApp["CardPreviewApp\n(CardPreviewApp)"]
  end

  subgraph Presentation
    DesignSystem["PresentationLayer_DesignSystem"]
    AllMedias["PresentationLayer_Features_AllMedias"]
    Details["PresentationLayer_Features_DetailsScreen"]
    Favorites["PresentationLayer_Features_FavoritesScreen"]
    MainTab["PresentationLayer_Features_MainTabBar"]
  end

  subgraph Domain
    DomainLayer["DomainLayer"]
  end

  subgraph Data
    DataLayer["DataLayer"]
  end

  subgraph Infra
    InfraLayer["InfrastructureLayer"]
  end

  MainApp --> MainTab
  MainApp --> DataLayer

  PreviewApp --> AllMedias
  PreviewApp --> DomainLayer

  MainTab --> AllMedias
  MainTab --> Favorites
  MainTab --> Details
  MainTab --> DesignSystem
  MainTab --> DomainLayer
  MainTab --> DataLayer

  AllMedias --> Details
  AllMedias --> DesignSystem
  AllMedias --> DomainLayer
  AllMedias --> DataLayer

  Favorites --> Details
  Favorites --> DesignSystem
  Favorites --> DomainLayer
  Favorites --> DataLayer

  Details --> DesignSystem
  Details --> DomainLayer
  Details --> DataLayer

  DataLayer --> DomainLayer
  DataLayer --> InfraLayer
```

For the full set of diagrams, see `docs/architecture.md`.

### Main Flow: All Medias

```mermaid
sequenceDiagram
  actor User
  participant View as MediasView
  participant VM as MediasViewModel
  participant UC as MediasUseCase
  participant Repo as MediasRepository
  participant Web as WebService
  participant Router as NetworkRouter
  participant API as dog.ceo

  User->>View: Open All Medias
  View->>VM: executeOnceOnAppear
  VM->>UC: getAllMedias()
  UC->>Repo: getAllMedias()
  Repo->>Web: getAllMedias()
  Web->>Router: request(BreedRequest)
  Router->>API: HTTP GET /api/medias/list/all
  API-->>Router: JSON
  Router-->>Web: Data
  Web-->>Repo: [BreedDTO]
  Repo-->>UC: [BreedEntity]
  UC-->>VM: [BreedEntity]
  VM-->>View: state = idle([BreedViewModel])
```

### Favorites Toggle

```mermaid
sequenceDiagram
  actor User
  participant View as BreedImageView
  participant VM as BreedImageViewModel
  participant UC as FavoritingUseCase
  participant Repo as BreedDetailsRepository
  participant Fav as FavoritesManager
  participant Store as UserDefaults

  User->>View: Tap heart
  View->>VM: likeButtonTapped()
  VM->>UC: toggleLiking(mediaDetails)
  UC->>Repo: toggleLiking(mediaDetails)
  Repo->>Fav: toggleLiking(mediaDetailsDTO)
  Fav->>Store: persist favorites (JSON)
  Fav-->>Repo: publishes updated favorites
```
  
