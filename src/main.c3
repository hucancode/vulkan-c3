module hellovk;
import std::io;
import std::math::quaternion;
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
    glfw::Window* window = glfw::createWindow(WIDTH, HEIGHT, TITLE, null, null);
    if (window == null) {
        return -1;
    }
    io::printfn("Window created %x", window);
    defer glfw::destroyWindow(window);
    Engine* engine = createEngine(window)!!;
    defer destroyEngine(engine);
    Renderer* renderer = createRenderer(engine)!!;
    defer destroyRenderer(renderer);
    Scene scene = make_scene();
    Node cube = new_static_mesh_node(make_cube());
    add_child(scene.root, cube);
    while (!glfw::windowShouldClose(window)) {
        glfw::pollEvents();
        double t = scene.last_frame_timestamp.elapsed_seconds();
        cube.transform.rotation = quaternion::rotate_y(t);
        anyfault excuse = @catch(render(engine, renderer));
        if (excuse) {
            io::printfn("Error: while rendering");
        };
    }
    return 0;
}
