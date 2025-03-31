#include "Application.h"

Application::Application(int& argc, char* argv[]) : QGuiApplication(argc, argv) {
    setApplicationName(Name);
    setOrganizationName(Organization);
    setApplicationVersion(Version);
}
