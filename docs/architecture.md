# Architecture

This document provides a concise, diagram-first overview of the Modularized iOS App template. The diagrams are derived from the current codebase.

## System Overview

```mermaid
flowchart TB
  subgraph Apps
    MainApp["Movies\n(ApplicationNameApp)"]
    PreviewApp["CardPreviewApp\n(CardPreviewApp)"]
  end

  subgraph Presentation
    DesignSystem["DesignSystem"]
    AllMedias["Features_AllMedias"]
    Details["Features_DetailsScreen"]
    Favorites["Features_FavoritesScreen"]
    MainTab["Features_MainTabBar"]
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

## Layered Architecture (Conceptual Flow)

```mermaid
flowchart TB
  UI["Presentation\nViews + ViewModels"]
  Domain["Domain\nEntities + UseCases + Protocols"]
  Data["Data\nRepositories + DTOs"]
  Infra["Infrastructure\nNetworking + Persistence"]

  UI --> Domain
  UI --> Data
  Data --> Domain
  Data --> Infra
```

## App Startup and Dependency Wiring

```mermaid
flowchart LR
  App["ApplicationNameApp.init()"] --> Register["DIContainerRegistration.registerComponents()"]
  Register --> DI["DIContainer.shared"]

  DI --> UseMedias["MediasUseCase"]
  DI --> UseDetails["BreedDetailsUseCase"]
  DI --> UseFavorites["FetchFavoritesUseCase"]
  DI --> UseFavoriting["FavoritingUseCase"]

  UseMedias --> RepoMedias["MediasRepository"]
  UseDetails --> RepoDetails["BreedDetailsRepository"]
  UseFavorites --> RepoDetails
  UseFavoriting --> RepoDetails

  RepoMedias --> Web["WebService"]
  RepoDetails --> Web
  RepoDetails --> FavMgr["FavoritesManager.shared"]
```

## Main Flow: All Medias

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

## Details Flow (Images + Favorites Merge)

```mermaid
sequenceDiagram
  actor User
  participant View as BreedImagesScreen
  participant VM as BreedImagesViewModel
  participant UC as BreedDetailsUseCase
  participant Repo as BreedDetailsRepository
  participant Web as WebService
  participant Router as NetworkRouter
  participant API as dog.ceo
  participant Fav as FavoritesManager

  User->>View: Open Details
  View->>VM: onAppear
  VM->>UC: getBreedDetails(breedName)
  UC->>Repo: getRemoteBreedDetails(breedName)
  Repo->>Web: getBreedDetails(breedName)
  Web->>Router: request(BreedImagesRequest)
  Router->>API: HTTP GET /api/breed/{name}/images
  API-->>Router: JSON
  Router-->>Web: Data
  Web-->>Repo: [BreedDetailsDTO]
  Repo-->>UC: [BreedDetailsEntity]

  UC->>Repo: fetchFavorites()
  Repo->>Fav: fetchFavorites()
  Fav-->>Repo: Set<BreedDetailsDTO>
  Repo-->>UC: Set<BreedDetailsEntity>
  UC-->>VM: [BreedDetailsEntity with isFavorite]
  VM-->>View: state = idle([BreedImageViewModel])
```

## Favorites Toggle Flow

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

## Networking Pipeline

```mermaid
flowchart LR
  RequestType["RequestTypeProtocol.execute()"] --> Router["NetworkRouter.request()"]
  Router --> Build["buildRequest(RequestProtocol)"]
  Build --> URLReq["URLRequest"]
  URLReq --> URLSession["URLSession.data(fromURLRequest)"]
  URLSession --> Data["Data"]
  Data --> Decode["JSONDecoder.decode(ResponseType)"]
  Decode --> DTO["DTO(s)"]
```

## Data Mapping (DTO -> Domain)

```mermaid
flowchart LR
  BreedDTO -->|toBreedEntity| BreedEntity
  BreedDetailsDTO -->|toBreedDetailsEntity| BreedDetailsEntity
  BreedDetailsEntity -->|toBreedDetailsDTO| BreedDetailsDTO
```

## Domain Model

```mermaid
classDiagram
  class BreedEntity {
    +String name
    +[BreedDetailsEntity] breedImages
  }

  class BreedDetailsEntity {
    +URL url
    +Bool isFavorite
  }

  class ErrorEntity {
    <<enum>>
    +general
  }

  BreedEntity "1" --> "0..*" BreedDetailsEntity
```

## ViewState Lifecycle

```mermaid
stateDiagram-v2
  [*] --> idle
  idle --> loading : fetch
  loading --> idle : success
  loading --> error : failure
  error --> loading : retry
```
