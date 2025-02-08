module helloglfw;
import glfw;

fn int main() {
    glfw::init();
    defer glfw::terminate();
    glfw::windowHint(glfw::CLIENT_API, glfw::NO_API);
    glfw::Window* window = glfw::createWindow(800, 600, "GLFW Test", null, null);
    defer glfw::destroyWindow(window);
    glfw::makeContextCurrent(window);
    while (!glfw::windowShouldClose(window)) {
        glfw::pollEvents();
    }
    return 0;
}
