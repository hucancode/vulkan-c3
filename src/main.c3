module hellovk;
import std::io;
import glfw;
import mj;

const WIDTH = 1024;
const HEIGHT = 768;
const TITLE = "Hello Vulkan!";

fn int main(String[] args) {
    io::printfn("GLFW %s",glfw::getVersionString());
    glfw::setErrorCallback(fn void(int error, ZString description) => io::printfn("GLFW error: %s", description));
    if (!glfw::init()) {
        return -1;
    }
    defer glfw::terminate();
    glfw::windowHint(glfw::CLIENT_API, glfw::NO_API);
    mj::g_window = glfw::createWindow(WIDTH, HEIGHT, TITLE, null, null);
    if (mj::g_window == null) {
        return -1;
    }
    io::printfn("Window created %x", mj::g_window);
    defer glfw::destroyWindow(mj::g_window);
    mj::init()!!;
    defer mj::destroy();
    while (!glfw::windowShouldClose(mj::g_window)) {
        glfw::pollEvents();
        mj::update();
        anyfault excuse = @catch(mj::render());
        if (excuse) {
            io::printfn("Error: while rendering");
        };
    }
    return 0;
}
