cmake_minimum_required(VERSION 4.0)

project(shoppinghauer VERSION 0.1.0 LANGUAGES CXX)

set(PROJECT_TITLE Shoppinghauer)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(REQUIRED_QT_VERSION 6.9)

find_package(Qt6 ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS
    Quick
    QuickControls2
    Sql
    LinguistTools
)

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
        qml/components/StyleToolButton.qml
        qml/main/NavigationMenu.qml
        qml/main/OptionsMenu.qml
        qml/main/OptionsMenuToolButton.qml
        qml/main/AboutDialog.qml

    SOURCES
        src/core/Application.cpp src/core/Application.h
        src/database/Database.cpp src/database/Database.h

    RESOURCES
        assets/icons/dots-vertical.svg
        assets/icons/arrow-left.svg
        assets/icons/menu.svg
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

set_target_properties(${PROJECT_NAME} PROPERTIES
    OUTPUT_NAME ${PROJECT_TITLE}
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Sql
)

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
