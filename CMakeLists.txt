cmake_minimum_required(VERSION 4.0)

project(shoppinghauer VERSION 0.1.0 LANGUAGES CXX)

set(PROJECT_TITLE Shoppinghauer)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(REQUIRED_QT_VERSION 6.9)

find_package(Qt6 ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS Quick QuickControls2 LinguistTools)

qt_standard_project_setup(
    REQUIRES ${REQUIRED_QT_VERSION}
    I18N_TRANSLATED_LANGUAGES ru
)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

configure_file(src/config.h.in config.h @ONLY)

qt_add_executable(${PROJECT_NAME}
    src/main.cpp
)

qt_add_qml_module(${PROJECT_NAME}
    URI ${PROJECT_NAME}
    NO_RESOURCE_TARGET_PATH

    QML_FILES
        qml/Main.qml
        qml/main/OptionsMenuToolButton.qml
        qml/dialogs/AboutDialog.qml

    SOURCES
        src/core/Application.cpp src/core/Application.h

    RESOURCES
        assets/icons/dots-vertical.svg
        qtquickcontrols2.conf
)

qt_add_translations(${PROJECT_NAME}
    SOURCE_TARGETS ${PROJECT_NAME}
    NO_GENERATE_PLURALS_TS_FILE
    TS_OUTPUT_DIRECTORY i18n
    # LUPDATE_OPTIONS -no-obsolete
)

# For visibility in IDE (e.g., Qt Creator)
add_custom_target(other
    SOURCES
    src/config.h.in
    README.md
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(${PROJECT_NAME} PROPERTIES
    OUTPUT_NAME ${PROJECT_TITLE}
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
