pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)  // ✅ FIXED
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "GGB"
include(":app")