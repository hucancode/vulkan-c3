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
    Engine engine;
    Scene scene;
    engine.renderer.init(window)!!;
    defer engine.destroy();
    scene.init(engine)!!;
    defer scene.destroy();
    MeshHandle cube_mesh_handle = engine.resource.malloc_mesh();
    engine.resource.meshes.get(cube_mesh_handle).init_cube(scene.renderer);
    Mesh* cube_mesh = engine.resource.meshes.get(cube_mesh_handle);
    defer cube_mesh.destroy();
    NodeHandle cube_handle = engine.resource.malloc_static_mesh_node(cube_mesh_handle);
    defer engine.resource.nodes.free(cube_handle);
    engine.resource.nodes.parent(scene.root, cube_handle);
    Node* cube = engine.resource.nodes.get(cube_handle);
    while (!glfw::windowShouldClose(window)) {
        glfw::pollEvents();
        float t = (float)scene.last_frame_timestamp.elapsed_seconds();
        cube.transform.rotation = quaternion::rotate_y(t);
        anyfault excuse = @catch(renderer.render());
        if (excuse) {
            io::printfn("Error: while rendering");
        };
    }
    return 0;
}
