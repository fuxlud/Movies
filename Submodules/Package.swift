// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Submodules",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "DomainLayer", targets: ["DomainLayer"]),
        .library(name: "DataLayer", targets: ["DataLayer"]),
        .library(name: "InfrastructureLayer", targets: ["InfrastructureLayer"]),
        .library(name: "PresentationLayer_DesignSystem", targets: ["PresentationLayer_DesignSystem"]),
        .library(name: "PresentationLayer_Features_AllMedias", targets: ["PresentationLayer_Features_AllMedias"]),
        .library(name: "PresentationLayer_Features_MainTabBar", targets: ["PresentationLayer_Features_MainTabBar"]),
        .library(name: "PresentationLayer_Features_DetailsScreen", targets: ["PresentationLayer_Features_DetailsScreen"]),
        .library(name: "PresentationLayer_Features_FavoritesScreen", targets: ["PresentationLayer_Features_FavoritesScreen"]),
    ],
    targets: [
        .target(
            name: "DomainLayer",
            dependencies: []
        ),
        .testTarget(
            name: "DomainLayerTests",
            dependencies: ["DomainLayer"]
        ),
        .target(
            name: "InfrastructureLayer",
            dependencies: []
        ),
        .target(
            name: "DataLayer",
            dependencies: ["DomainLayer", "InfrastructureLayer"]
        ),
        .target(
            name: "PresentationLayer_DesignSystem",
            dependencies: [],
            path: "Sources/PresentationLayer/DesignSystem/DesignSystem"
        ),
        .target(
            name: "PresentationLayer_Features_AllMedias",
            dependencies: ["DataLayer",
                           "DomainLayer",
                           "PresentationLayer_DesignSystem",
                           "PresentationLayer_Features_DetailsScreen"], //DetailsScreen should be moved to coordinator. Data moved to dependeci container
            path: "Sources/PresentationLayer/Features/AllMedias"
        ),
        .target(
            name: "PresentationLayer_Features_MainTabBar",
            dependencies: ["DataLayer",
                           "DomainLayer",
                           "PresentationLayer_DesignSystem",
                           "PresentationLayer_Features_DetailsScreen",
                           "PresentationLayer_Features_AllMedias",
                           "PresentationLayer_Features_FavoritesScreen"], //DetailsScreen should be moved to coordinator. Data moved to dependeci container
            path: "Sources/PresentationLayer/Features/MainTabBar"
        ),
        .target(
            name: "PresentationLayer_Features_FavoritesScreen",
            dependencies: ["DataLayer",
                           "DomainLayer",
                           "PresentationLayer_DesignSystem",
                           "PresentationLayer_Features_DetailsScreen"],
            path: "Sources/PresentationLayer/Features/FavoritesScreen"
        ),
        .target(
            name: "PresentationLayer_Features_DetailsScreen",
            dependencies: ["DomainLayer", "PresentationLayer_DesignSystem", "DataLayer"],
            path: "Sources/PresentationLayer/Features/DetailsScreen"
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["InfrastructureLayer"]
        ),
        .testTarget(
            name: "PresentationLayer_Features_AllMediasTests",
            dependencies: ["DomainLayer", "PresentationLayer_Features_AllMedias"]
        )
    ]
)
