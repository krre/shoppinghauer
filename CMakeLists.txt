cmake_minimum_required(VERSION 4.0)

project(shoppinghauer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(REQUIRED_QT_VERSION 6.8)

find_package(Qt6 ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES ${REQUIRED_QT_VERSION})

include_directories(${CMAKE_CURRENT_BINARY_DIR})

configure_file(cpp/config.h.in config.h @ONLY)

qt_add_executable(${PROJECT_NAME}
    cpp/main.cpp
)

qt_add_qml_module(${PROJECT_NAME}
    URI shoppinghauer
    NO_RESOURCE_TARGET_PATH

    QML_FILES
        qml/Main.qml

    SOURCES
        cpp/core/Application.cpp cpp/core/Application.h

    RESOURCES
        qtquickcontrols2.conf
)

# For visibility in IDE (e.g., Qt Creator)
add_custom_target(other
    SOURCES
    README.md
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(${PROJECT_NAME} PROPERTIES
    OUTPUT_NAME "Shoppinghauer"
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appshoppinghauer
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE Qt6::Quick
    Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
