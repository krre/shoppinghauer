cmake_minimum_required(VERSION 4.0)

project(shoppinghauer VERSION 1.5.0 LANGUAGES CXX)

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
        qml/components/StyledToolButton.qml
        qml/components/PlusToolButton.qml
        qml/components/EditToolButton.qml
        qml/components/OkButton.qml
        qml/components/StyledCheckBox.qml
        qml/components/StyledLabel.qml
        qml/components/style.js
        qml/components/utils.js
        qml/components/BorderDelegate.qml
        qml/components/PageListView.qml
        qml/main/NavigationMenu.qml
        qml/main/OptionsMenuToolButton.qml
        qml/main/AboutDialog.qml
        qml/pages/NamedPage.qml
        qml/pages/shoppinglists/ShoppingListsPage.qml
        qml/pages/shoppinglists/ShoppingListEditorPage.qml
        qml/pages/products/ProductsPage.qml
        qml/pages/products/ProductEditorPage.qml
        qml/pages/shoppings/ShoppingsPage.qml

    SOURCES
        src/core/Application.cpp src/core/Application.h
        src/database/Database.cpp src/database/Database.h
        src/database/Migrater.cpp src/database/Migrater.h

    RESOURCES
        assets/icons/dots-vertical.svg
        assets/icons/arrow-left.svg
        assets/icons/archive.svg
        assets/icons/menu.svg
        assets/icons/square-plus.svg
        assets/icons/checks.svg
        assets/icons/edit.svg
        assets/logo/logo.png
        qtquickcontrols2.conf
        android/AndroidManifest.xml
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
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
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
