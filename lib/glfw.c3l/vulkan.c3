module glfw;
import vk;

extern fn VkProc getInstanceProcAddress(vk::Instance instance, ZString procname)
  @extern("glfwGetInstanceProcAddress");

extern fn int getPhysicalDevicePresentationSupport(vk::Instance instance, vk::PhysicalDevice device, uint queuefamily)
  @extern("glfwGetPhysicalDevicePresentationSupport");

extern fn vk::Result createWindowSurface(vk::Instance instance, Window* window, vk::AllocationCallbacks* allocator, vk::SurfaceKHR* surface)
  @extern("glfwCreateWindowSurface");
