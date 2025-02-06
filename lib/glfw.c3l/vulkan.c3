module glfw @if(env::GLFW_INCLUDE_VULKAN);
import vk;
import std::collections::list;

extern fn vk::ProcVoidFunction getInstanceProcAddress(vk::Instance instance, ZString procname)
  @extern("glfwGetInstanceProcAddress");

extern fn int getPhysicalDevicePresentationSupport(vk::Instance instance, vk::PhysicalDevice device, uint queuefamily)
  @extern("glfwGetPhysicalDevicePresentationSupport");

extern fn vk::Result createWindowSurface(vk::Instance instance, Window* window, vk::AllocationCallbacks* allocator, vk::SurfaceKHR* surface)
  @extern("glfwCreateWindowSurface");

extern fn ZString* getRequiredInstanceExtensions(ulong* count) @extern("glfwGetRequiredInstanceExtensions");
