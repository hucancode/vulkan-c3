module vk;
import std::core::cinterop;

fn void! createInstance(InstanceCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, Instance* pInstance) @inline {
	vk::check(internal::createInstance(pCreateInfo, pAllocator, pInstance))!;
}

fn uint debugUtilsMessengerCallbackEXT(DebugUtilsMessageSeverityFlagsEXT messageSeverity, DebugUtilsMessageTypeFlagsEXT messageTypes, DebugUtilsMessengerCallbackDataEXT* pCallbackData, void* pUserData) @inline {
	return internal::debugUtilsMessengerCallbackEXT(messageSeverity, messageTypes, pCallbackData, pUserData);
}

fn void deviceMemoryReportCallbackEXT(DeviceMemoryReportCallbackDataEXT* pCallbackData, void* pUserData) @inline {
	internal::deviceMemoryReportCallbackEXT(pCallbackData, pUserData);
}

fn ExtensionProperties[]! enumerateInstanceExtensionProperties(ZString pLayerName) {
	uint n;
	vk::check(internal::enumerateInstanceExtensionProperties(pLayerName, &n, null))!;
	ExtensionProperties* ret = (ExtensionProperties*) malloc(n * ExtensionProperties.sizeof);
	vk::check(internal::enumerateInstanceExtensionProperties(pLayerName, &n, ret))!;
	return ret[:n];
}

fn LayerProperties[]! enumerateInstanceLayerProperties() {
	uint n;
	vk::check(internal::enumerateInstanceLayerProperties(&n, null))!;
	LayerProperties* ret = (LayerProperties*) malloc(n * LayerProperties.sizeof);
	vk::check(internal::enumerateInstanceLayerProperties(&n, ret))!;
	return ret[:n];
}

fn void! enumerateInstanceVersion(uint* pApiVersion) @inline {
	vk::check(internal::enumerateInstanceVersion(pApiVersion))!;
}

fn void freeFunction(void* pUserData, void* pMemory) @inline {
	internal::freeFunction(pUserData, pMemory);
}

fn ProcVoidFunction getInstanceProcAddr(Instance instance, ZString pName) @inline {
	return internal::getInstanceProcAddr(instance, pName);
}

fn void internalAllocationNotification(void* pUserData, usz size, InternalAllocationType allocationType, SystemAllocationScope allocationScope) @inline {
	internal::internalAllocationNotification(pUserData, size, allocationType, allocationScope);
}

fn void internalFreeNotification(void* pUserData, usz size, InternalAllocationType allocationType, SystemAllocationScope allocationScope) @inline {
	internal::internalFreeNotification(pUserData, size, allocationType, allocationScope);
}

fn void! acquireDrmDisplayEXT(PhysicalDevice physicalDevice, int drmFd, DisplayKHR display) @inline {
	vk::check(internal::acquireDrmDisplayEXT(physicalDevice, drmFd, display))!;
}

fn void! acquireWinrtDisplayNV(PhysicalDevice physicalDevice, DisplayKHR display) @inline {
	vk::check(internal::acquireWinrtDisplayNV(physicalDevice, display))!;
}

fn void! createDebugReportCallbackEXT(Instance instance, DebugReportCallbackCreateInfoEXT* pCreateInfo, AllocationCallbacks* pAllocator, DebugReportCallbackEXT* pCallback) @inline {
	vk::check(internal::createDebugReportCallbackEXT(instance, pCreateInfo, pAllocator, pCallback))!;
}

fn void! createDebugUtilsMessengerEXT(Instance instance, DebugUtilsMessengerCreateInfoEXT* pCreateInfo, AllocationCallbacks* pAllocator, DebugUtilsMessengerEXT* pMessenger) @inline {
	vk::check(internal::createDebugUtilsMessengerEXT(instance, pCreateInfo, pAllocator, pMessenger))!;
}

fn void! createDevice(PhysicalDevice physicalDevice, DeviceCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, Device* pDevice) @inline {
	vk::check(internal::createDevice(physicalDevice, pCreateInfo, pAllocator, pDevice))!;
}

fn void! createDisplayModeKHR(PhysicalDevice physicalDevice, DisplayKHR display, DisplayModeCreateInfoKHR* pCreateInfo, AllocationCallbacks* pAllocator, DisplayModeKHR* pMode) @inline {
	vk::check(internal::createDisplayModeKHR(physicalDevice, display, pCreateInfo, pAllocator, pMode))!;
}

fn void! createDisplayPlaneSurfaceKHR(Instance instance, DisplaySurfaceCreateInfoKHR* pCreateInfo, AllocationCallbacks* pAllocator, SurfaceKHR* pSurface) @inline {
	vk::check(internal::createDisplayPlaneSurfaceKHR(instance, pCreateInfo, pAllocator, pSurface))!;
}

fn void! createHeadlessSurfaceEXT(Instance instance, HeadlessSurfaceCreateInfoEXT* pCreateInfo, AllocationCallbacks* pAllocator, SurfaceKHR* pSurface) @inline {
	vk::check(internal::createHeadlessSurfaceEXT(instance, pCreateInfo, pAllocator, pSurface))!;
}

fn void! createIOSSurfaceMVK(Instance instance, IOSSurfaceCreateInfoMVK* pCreateInfo, AllocationCallbacks* pAllocator, SurfaceKHR* pSurface) @inline {
	vk::check(internal::createIOSSurfaceMVK(instance, pCreateInfo, pAllocator, pSurface))!;
}

fn void! createMacOSSurfaceMVK(Instance instance, MacOSSurfaceCreateInfoMVK* pCreateInfo, AllocationCallbacks* pAllocator, SurfaceKHR* pSurface) @inline {
	vk::check(internal::createMacOSSurfaceMVK(instance, pCreateInfo, pAllocator, pSurface))!;
}

fn void! createMetalSurfaceEXT(Instance instance, MetalSurfaceCreateInfoEXT* pCreateInfo, AllocationCallbacks* pAllocator, SurfaceKHR* pSurface) @inline {
	vk::check(internal::createMetalSurfaceEXT(instance, pCreateInfo, pAllocator, pSurface))!;
}

fn void! createWaylandSurfaceKHR(Instance instance, WaylandSurfaceCreateInfoKHR* pCreateInfo, AllocationCallbacks* pAllocator, SurfaceKHR* pSurface) @inline {
	vk::check(internal::createWaylandSurfaceKHR(instance, pCreateInfo, pAllocator, pSurface))!;
}

fn void! createWin32SurfaceKHR(Instance instance, Win32SurfaceCreateInfoKHR* pCreateInfo, AllocationCallbacks* pAllocator, SurfaceKHR* pSurface) @inline {
	vk::check(internal::createWin32SurfaceKHR(instance, pCreateInfo, pAllocator, pSurface))!;
}

fn void! createXcbSurfaceKHR(Instance instance, XcbSurfaceCreateInfoKHR* pCreateInfo, AllocationCallbacks* pAllocator, SurfaceKHR* pSurface) @inline {
	vk::check(internal::createXcbSurfaceKHR(instance, pCreateInfo, pAllocator, pSurface))!;
}

fn void! createXlibSurfaceKHR(Instance instance, XlibSurfaceCreateInfoKHR* pCreateInfo, AllocationCallbacks* pAllocator, SurfaceKHR* pSurface) @inline {
	vk::check(internal::createXlibSurfaceKHR(instance, pCreateInfo, pAllocator, pSurface))!;
}

fn void debugReportMessageEXT(Instance instance, DebugReportFlagsEXT flags, DebugReportObjectTypeEXT objectType, ulong object, usz location, int messageCode, ZString pLayerPrefix, ZString pMessage) @inline {
	internal::debugReportMessageEXT(instance, flags, objectType, object, location, messageCode, pLayerPrefix, pMessage);
}

fn void destroyDebugReportCallbackEXT(Instance instance, DebugReportCallbackEXT callback, AllocationCallbacks* pAllocator) @inline {
	internal::destroyDebugReportCallbackEXT(instance, callback, pAllocator);
}

fn void destroyDebugUtilsMessengerEXT(Instance instance, DebugUtilsMessengerEXT messenger, AllocationCallbacks* pAllocator) @inline {
	internal::destroyDebugUtilsMessengerEXT(instance, messenger, pAllocator);
}

fn void destroyInstance(Instance instance, AllocationCallbacks* pAllocator) @inline {
	internal::destroyInstance(instance, pAllocator);
}

fn void destroySurfaceKHR(Instance instance, SurfaceKHR surface, AllocationCallbacks* pAllocator) @inline {
	internal::destroySurfaceKHR(instance, surface, pAllocator);
}

fn ExtensionProperties[]! enumerateDeviceExtensionProperties(PhysicalDevice physicalDevice, ZString pLayerName) {
	uint n;
	vk::check(internal::enumerateDeviceExtensionProperties(physicalDevice, pLayerName, &n, null))!;
	ExtensionProperties* ret = (ExtensionProperties*) malloc(n * ExtensionProperties.sizeof);
	vk::check(internal::enumerateDeviceExtensionProperties(physicalDevice, pLayerName, &n, ret))!;
	return ret[:n];
}

fn LayerProperties[]! enumerateDeviceLayerProperties(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::enumerateDeviceLayerProperties(physicalDevice, &n, null))!;
	LayerProperties* ret = (LayerProperties*) malloc(n * LayerProperties.sizeof);
	vk::check(internal::enumerateDeviceLayerProperties(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn PhysicalDeviceGroupProperties[]! enumeratePhysicalDeviceGroups(Instance instance) {
	uint n;
	vk::check(internal::enumeratePhysicalDeviceGroups(instance, &n, null))!;
	PhysicalDeviceGroupProperties* ret = (PhysicalDeviceGroupProperties*) malloc(n * PhysicalDeviceGroupProperties.sizeof);
	vk::check(internal::enumeratePhysicalDeviceGroups(instance, &n, ret))!;
	return ret[:n];
}

fn PhysicalDeviceGroupProperties[]! enumeratePhysicalDeviceGroupsKHR(Instance instance) {
	uint n;
	vk::check(internal::enumeratePhysicalDeviceGroupsKHR(instance, &n, null))!;
	PhysicalDeviceGroupProperties* ret = (PhysicalDeviceGroupProperties*) malloc(n * PhysicalDeviceGroupProperties.sizeof);
	vk::check(internal::enumeratePhysicalDeviceGroupsKHR(instance, &n, ret))!;
	return ret[:n];
}

fn void! enumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR(PhysicalDevice physicalDevice, uint queueFamilyIndex, uint* pCounterCount, PerformanceCounterKHR* pCounters, PerformanceCounterDescriptionKHR* pCounterDescriptions) @inline {
	vk::check(internal::enumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR(physicalDevice, queueFamilyIndex, pCounterCount, pCounters, pCounterDescriptions))!;
}

fn PhysicalDevice[]! enumeratePhysicalDevices(Instance instance) {
	uint n;
	vk::check(internal::enumeratePhysicalDevices(instance, &n, null))!;
	PhysicalDevice* ret = (PhysicalDevice*) malloc(n * PhysicalDevice.sizeof);
	vk::check(internal::enumeratePhysicalDevices(instance, &n, ret))!;
	return ret[:n];
}

fn DisplayModeProperties2KHR[]! getDisplayModeProperties2KHR(PhysicalDevice physicalDevice, DisplayKHR display) {
	uint n;
	vk::check(internal::getDisplayModeProperties2KHR(physicalDevice, display, &n, null))!;
	DisplayModeProperties2KHR* ret = (DisplayModeProperties2KHR*) malloc(n * DisplayModeProperties2KHR.sizeof);
	vk::check(internal::getDisplayModeProperties2KHR(physicalDevice, display, &n, ret))!;
	return ret[:n];
}

fn DisplayModePropertiesKHR[]! getDisplayModePropertiesKHR(PhysicalDevice physicalDevice, DisplayKHR display) {
	uint n;
	vk::check(internal::getDisplayModePropertiesKHR(physicalDevice, display, &n, null))!;
	DisplayModePropertiesKHR* ret = (DisplayModePropertiesKHR*) malloc(n * DisplayModePropertiesKHR.sizeof);
	vk::check(internal::getDisplayModePropertiesKHR(physicalDevice, display, &n, ret))!;
	return ret[:n];
}

fn void! getDisplayPlaneCapabilities2KHR(PhysicalDevice physicalDevice, DisplayPlaneInfo2KHR* pDisplayPlaneInfo, DisplayPlaneCapabilities2KHR* pCapabilities) @inline {
	vk::check(internal::getDisplayPlaneCapabilities2KHR(physicalDevice, pDisplayPlaneInfo, pCapabilities))!;
}

fn void! getDisplayPlaneCapabilitiesKHR(PhysicalDevice physicalDevice, DisplayModeKHR mode, uint planeIndex, DisplayPlaneCapabilitiesKHR* pCapabilities) @inline {
	vk::check(internal::getDisplayPlaneCapabilitiesKHR(physicalDevice, mode, planeIndex, pCapabilities))!;
}

fn DisplayKHR[]! getDisplayPlaneSupportedDisplaysKHR(PhysicalDevice physicalDevice, uint planeIndex) {
	uint n;
	vk::check(internal::getDisplayPlaneSupportedDisplaysKHR(physicalDevice, planeIndex, &n, null))!;
	DisplayKHR* ret = (DisplayKHR*) malloc(n * DisplayKHR.sizeof);
	vk::check(internal::getDisplayPlaneSupportedDisplaysKHR(physicalDevice, planeIndex, &n, ret))!;
	return ret[:n];
}

fn void! getDrmDisplayEXT(PhysicalDevice physicalDevice, int drmFd, uint connectorId, DisplayKHR* display) @inline {
	vk::check(internal::getDrmDisplayEXT(physicalDevice, drmFd, connectorId, display))!;
}

fn ProcVoidFunction getInstanceProcAddrLUNARG(Instance instance, ZString pName) @inline {
	return internal::getInstanceProcAddrLUNARG(instance, pName);
}

fn TimeDomainKHR[]! getPhysicalDeviceCalibrateableTimeDomainsEXT(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::getPhysicalDeviceCalibrateableTimeDomainsEXT(physicalDevice, &n, null))!;
	TimeDomainKHR* ret = (TimeDomainKHR*) malloc(n * TimeDomainKHR.sizeof);
	vk::check(internal::getPhysicalDeviceCalibrateableTimeDomainsEXT(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn TimeDomainKHR[]! getPhysicalDeviceCalibrateableTimeDomainsKHR(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::getPhysicalDeviceCalibrateableTimeDomainsKHR(physicalDevice, &n, null))!;
	TimeDomainKHR* ret = (TimeDomainKHR*) malloc(n * TimeDomainKHR.sizeof);
	vk::check(internal::getPhysicalDeviceCalibrateableTimeDomainsKHR(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn CooperativeMatrixFlexibleDimensionsPropertiesNV[]! getPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::getPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV(physicalDevice, &n, null))!;
	CooperativeMatrixFlexibleDimensionsPropertiesNV* ret = (CooperativeMatrixFlexibleDimensionsPropertiesNV*) malloc(n * CooperativeMatrixFlexibleDimensionsPropertiesNV.sizeof);
	vk::check(internal::getPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn CooperativeMatrixPropertiesKHR[]! getPhysicalDeviceCooperativeMatrixPropertiesKHR(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::getPhysicalDeviceCooperativeMatrixPropertiesKHR(physicalDevice, &n, null))!;
	CooperativeMatrixPropertiesKHR* ret = (CooperativeMatrixPropertiesKHR*) malloc(n * CooperativeMatrixPropertiesKHR.sizeof);
	vk::check(internal::getPhysicalDeviceCooperativeMatrixPropertiesKHR(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn CooperativeMatrixPropertiesNV[]! getPhysicalDeviceCooperativeMatrixPropertiesNV(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::getPhysicalDeviceCooperativeMatrixPropertiesNV(physicalDevice, &n, null))!;
	CooperativeMatrixPropertiesNV* ret = (CooperativeMatrixPropertiesNV*) malloc(n * CooperativeMatrixPropertiesNV.sizeof);
	vk::check(internal::getPhysicalDeviceCooperativeMatrixPropertiesNV(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn CooperativeVectorPropertiesNV[]! getPhysicalDeviceCooperativeVectorPropertiesNV(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::getPhysicalDeviceCooperativeVectorPropertiesNV(physicalDevice, &n, null))!;
	CooperativeVectorPropertiesNV* ret = (CooperativeVectorPropertiesNV*) malloc(n * CooperativeVectorPropertiesNV.sizeof);
	vk::check(internal::getPhysicalDeviceCooperativeVectorPropertiesNV(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn DisplayPlaneProperties2KHR[]! getPhysicalDeviceDisplayPlaneProperties2KHR(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::getPhysicalDeviceDisplayPlaneProperties2KHR(physicalDevice, &n, null))!;
	DisplayPlaneProperties2KHR* ret = (DisplayPlaneProperties2KHR*) malloc(n * DisplayPlaneProperties2KHR.sizeof);
	vk::check(internal::getPhysicalDeviceDisplayPlaneProperties2KHR(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn DisplayPlanePropertiesKHR[]! getPhysicalDeviceDisplayPlanePropertiesKHR(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::getPhysicalDeviceDisplayPlanePropertiesKHR(physicalDevice, &n, null))!;
	DisplayPlanePropertiesKHR* ret = (DisplayPlanePropertiesKHR*) malloc(n * DisplayPlanePropertiesKHR.sizeof);
	vk::check(internal::getPhysicalDeviceDisplayPlanePropertiesKHR(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn DisplayProperties2KHR[]! getPhysicalDeviceDisplayProperties2KHR(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::getPhysicalDeviceDisplayProperties2KHR(physicalDevice, &n, null))!;
	DisplayProperties2KHR* ret = (DisplayProperties2KHR*) malloc(n * DisplayProperties2KHR.sizeof);
	vk::check(internal::getPhysicalDeviceDisplayProperties2KHR(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn DisplayPropertiesKHR[]! getPhysicalDeviceDisplayPropertiesKHR(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::getPhysicalDeviceDisplayPropertiesKHR(physicalDevice, &n, null))!;
	DisplayPropertiesKHR* ret = (DisplayPropertiesKHR*) malloc(n * DisplayPropertiesKHR.sizeof);
	vk::check(internal::getPhysicalDeviceDisplayPropertiesKHR(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn void getPhysicalDeviceExternalBufferProperties(PhysicalDevice physicalDevice, PhysicalDeviceExternalBufferInfo* pExternalBufferInfo, ExternalBufferProperties* pExternalBufferProperties) @inline {
	internal::getPhysicalDeviceExternalBufferProperties(physicalDevice, pExternalBufferInfo, pExternalBufferProperties);
}

fn void getPhysicalDeviceExternalBufferPropertiesKHR(PhysicalDevice physicalDevice, PhysicalDeviceExternalBufferInfo* pExternalBufferInfo, ExternalBufferProperties* pExternalBufferProperties) @inline {
	internal::getPhysicalDeviceExternalBufferPropertiesKHR(physicalDevice, pExternalBufferInfo, pExternalBufferProperties);
}

fn void getPhysicalDeviceExternalFenceProperties(PhysicalDevice physicalDevice, PhysicalDeviceExternalFenceInfo* pExternalFenceInfo, ExternalFenceProperties* pExternalFenceProperties) @inline {
	internal::getPhysicalDeviceExternalFenceProperties(physicalDevice, pExternalFenceInfo, pExternalFenceProperties);
}

fn void getPhysicalDeviceExternalFencePropertiesKHR(PhysicalDevice physicalDevice, PhysicalDeviceExternalFenceInfo* pExternalFenceInfo, ExternalFenceProperties* pExternalFenceProperties) @inline {
	internal::getPhysicalDeviceExternalFencePropertiesKHR(physicalDevice, pExternalFenceInfo, pExternalFenceProperties);
}

fn void! getPhysicalDeviceExternalImageFormatPropertiesNV(PhysicalDevice physicalDevice, Format format, ImageType type, ImageTiling tiling, ImageUsageFlags usage, ImageCreateFlags flags, ExternalMemoryHandleTypeFlagsNV externalHandleType, ExternalImageFormatPropertiesNV* pExternalImageFormatProperties) @inline {
	vk::check(internal::getPhysicalDeviceExternalImageFormatPropertiesNV(physicalDevice, format, type, tiling, usage, flags, externalHandleType, pExternalImageFormatProperties))!;
}

fn void getPhysicalDeviceExternalSemaphoreProperties(PhysicalDevice physicalDevice, PhysicalDeviceExternalSemaphoreInfo* pExternalSemaphoreInfo, ExternalSemaphoreProperties* pExternalSemaphoreProperties) @inline {
	internal::getPhysicalDeviceExternalSemaphoreProperties(physicalDevice, pExternalSemaphoreInfo, pExternalSemaphoreProperties);
}

fn void getPhysicalDeviceExternalSemaphorePropertiesKHR(PhysicalDevice physicalDevice, PhysicalDeviceExternalSemaphoreInfo* pExternalSemaphoreInfo, ExternalSemaphoreProperties* pExternalSemaphoreProperties) @inline {
	internal::getPhysicalDeviceExternalSemaphorePropertiesKHR(physicalDevice, pExternalSemaphoreInfo, pExternalSemaphoreProperties);
}

fn void getPhysicalDeviceFeatures(PhysicalDevice physicalDevice, PhysicalDeviceFeatures* pFeatures) @inline {
	internal::getPhysicalDeviceFeatures(physicalDevice, pFeatures);
}

fn void getPhysicalDeviceFeatures2(PhysicalDevice physicalDevice, PhysicalDeviceFeatures2* pFeatures) @inline {
	internal::getPhysicalDeviceFeatures2(physicalDevice, pFeatures);
}

fn void getPhysicalDeviceFeatures2KHR(PhysicalDevice physicalDevice, PhysicalDeviceFeatures2* pFeatures) @inline {
	internal::getPhysicalDeviceFeatures2KHR(physicalDevice, pFeatures);
}

fn void getPhysicalDeviceFormatProperties(PhysicalDevice physicalDevice, Format format, FormatProperties* pFormatProperties) @inline {
	internal::getPhysicalDeviceFormatProperties(physicalDevice, format, pFormatProperties);
}

fn void getPhysicalDeviceFormatProperties2(PhysicalDevice physicalDevice, Format format, FormatProperties2* pFormatProperties) @inline {
	internal::getPhysicalDeviceFormatProperties2(physicalDevice, format, pFormatProperties);
}

fn void getPhysicalDeviceFormatProperties2KHR(PhysicalDevice physicalDevice, Format format, FormatProperties2* pFormatProperties) @inline {
	internal::getPhysicalDeviceFormatProperties2KHR(physicalDevice, format, pFormatProperties);
}

fn PhysicalDeviceFragmentShadingRateKHR[]! getPhysicalDeviceFragmentShadingRatesKHR(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::getPhysicalDeviceFragmentShadingRatesKHR(physicalDevice, &n, null))!;
	PhysicalDeviceFragmentShadingRateKHR* ret = (PhysicalDeviceFragmentShadingRateKHR*) malloc(n * PhysicalDeviceFragmentShadingRateKHR.sizeof);
	vk::check(internal::getPhysicalDeviceFragmentShadingRatesKHR(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn void! getPhysicalDeviceImageFormatProperties(PhysicalDevice physicalDevice, Format format, ImageType type, ImageTiling tiling, ImageUsageFlags usage, ImageCreateFlags flags, ImageFormatProperties* pImageFormatProperties) @inline {
	vk::check(internal::getPhysicalDeviceImageFormatProperties(physicalDevice, format, type, tiling, usage, flags, pImageFormatProperties))!;
}

fn void! getPhysicalDeviceImageFormatProperties2(PhysicalDevice physicalDevice, PhysicalDeviceImageFormatInfo2* pImageFormatInfo, ImageFormatProperties2* pImageFormatProperties) @inline {
	vk::check(internal::getPhysicalDeviceImageFormatProperties2(physicalDevice, pImageFormatInfo, pImageFormatProperties))!;
}

fn void! getPhysicalDeviceImageFormatProperties2KHR(PhysicalDevice physicalDevice, PhysicalDeviceImageFormatInfo2* pImageFormatInfo, ImageFormatProperties2* pImageFormatProperties) @inline {
	vk::check(internal::getPhysicalDeviceImageFormatProperties2KHR(physicalDevice, pImageFormatInfo, pImageFormatProperties))!;
}

fn void getPhysicalDeviceMemoryProperties(PhysicalDevice physicalDevice, PhysicalDeviceMemoryProperties* pMemoryProperties) @inline {
	internal::getPhysicalDeviceMemoryProperties(physicalDevice, pMemoryProperties);
}

fn void getPhysicalDeviceMemoryProperties2(PhysicalDevice physicalDevice, PhysicalDeviceMemoryProperties2* pMemoryProperties) @inline {
	internal::getPhysicalDeviceMemoryProperties2(physicalDevice, pMemoryProperties);
}

fn void getPhysicalDeviceMemoryProperties2KHR(PhysicalDevice physicalDevice, PhysicalDeviceMemoryProperties2* pMemoryProperties) @inline {
	internal::getPhysicalDeviceMemoryProperties2KHR(physicalDevice, pMemoryProperties);
}

fn void getPhysicalDeviceMultisamplePropertiesEXT(PhysicalDevice physicalDevice, SampleCountFlags samples, MultisamplePropertiesEXT* pMultisampleProperties) @inline {
	internal::getPhysicalDeviceMultisamplePropertiesEXT(physicalDevice, samples, pMultisampleProperties);
}

fn OpticalFlowImageFormatPropertiesNV[]! getPhysicalDeviceOpticalFlowImageFormatsNV(PhysicalDevice physicalDevice, OpticalFlowImageFormatInfoNV* pOpticalFlowImageFormatInfo) {
	uint n;
	vk::check(internal::getPhysicalDeviceOpticalFlowImageFormatsNV(physicalDevice, pOpticalFlowImageFormatInfo, &n, null))!;
	OpticalFlowImageFormatPropertiesNV* ret = (OpticalFlowImageFormatPropertiesNV*) malloc(n * OpticalFlowImageFormatPropertiesNV.sizeof);
	vk::check(internal::getPhysicalDeviceOpticalFlowImageFormatsNV(physicalDevice, pOpticalFlowImageFormatInfo, &n, ret))!;
	return ret[:n];
}

fn Rect2D[]! getPhysicalDevicePresentRectanglesKHR(PhysicalDevice physicalDevice, SurfaceKHR surface) {
	uint n;
	vk::check(internal::getPhysicalDevicePresentRectanglesKHR(physicalDevice, surface, &n, null))!;
	Rect2D* ret = (Rect2D*) malloc(n * Rect2D.sizeof);
	vk::check(internal::getPhysicalDevicePresentRectanglesKHR(physicalDevice, surface, &n, ret))!;
	return ret[:n];
}

fn void getPhysicalDeviceProperties(PhysicalDevice physicalDevice, PhysicalDeviceProperties* pProperties) @inline {
	internal::getPhysicalDeviceProperties(physicalDevice, pProperties);
}

fn void getPhysicalDeviceProperties2(PhysicalDevice physicalDevice, PhysicalDeviceProperties2* pProperties) @inline {
	internal::getPhysicalDeviceProperties2(physicalDevice, pProperties);
}

fn void getPhysicalDeviceProperties2KHR(PhysicalDevice physicalDevice, PhysicalDeviceProperties2* pProperties) @inline {
	internal::getPhysicalDeviceProperties2KHR(physicalDevice, pProperties);
}

fn void getPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR(PhysicalDevice physicalDevice, QueryPoolPerformanceCreateInfoKHR* pPerformanceQueryCreateInfo, uint* pNumPasses) @inline {
	internal::getPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR(physicalDevice, pPerformanceQueryCreateInfo, pNumPasses);
}

fn QueueFamilyProperties[] getPhysicalDeviceQueueFamilyProperties(PhysicalDevice physicalDevice) {
	uint n;
	internal::getPhysicalDeviceQueueFamilyProperties(physicalDevice, &n, null);
	QueueFamilyProperties* ret = (QueueFamilyProperties*) malloc(n * QueueFamilyProperties.sizeof);
	internal::getPhysicalDeviceQueueFamilyProperties(physicalDevice, &n, ret);
	return ret[:n];
}

fn QueueFamilyProperties2[] getPhysicalDeviceQueueFamilyProperties2(PhysicalDevice physicalDevice) {
	uint n;
	internal::getPhysicalDeviceQueueFamilyProperties2(physicalDevice, &n, null);
	QueueFamilyProperties2* ret = (QueueFamilyProperties2*) malloc(n * QueueFamilyProperties2.sizeof);
	internal::getPhysicalDeviceQueueFamilyProperties2(physicalDevice, &n, ret);
	return ret[:n];
}

fn QueueFamilyProperties2[] getPhysicalDeviceQueueFamilyProperties2KHR(PhysicalDevice physicalDevice) {
	uint n;
	internal::getPhysicalDeviceQueueFamilyProperties2KHR(physicalDevice, &n, null);
	QueueFamilyProperties2* ret = (QueueFamilyProperties2*) malloc(n * QueueFamilyProperties2.sizeof);
	internal::getPhysicalDeviceQueueFamilyProperties2KHR(physicalDevice, &n, ret);
	return ret[:n];
}

fn SparseImageFormatProperties[] getPhysicalDeviceSparseImageFormatProperties(PhysicalDevice physicalDevice, Format format, ImageType type, SampleCountFlags samples, ImageUsageFlags usage, ImageTiling tiling) {
	uint n;
	internal::getPhysicalDeviceSparseImageFormatProperties(physicalDevice, format, type, samples, usage, tiling, &n, null);
	SparseImageFormatProperties* ret = (SparseImageFormatProperties*) malloc(n * SparseImageFormatProperties.sizeof);
	internal::getPhysicalDeviceSparseImageFormatProperties(physicalDevice, format, type, samples, usage, tiling, &n, ret);
	return ret[:n];
}

fn SparseImageFormatProperties2[] getPhysicalDeviceSparseImageFormatProperties2(PhysicalDevice physicalDevice, PhysicalDeviceSparseImageFormatInfo2* pFormatInfo) {
	uint n;
	internal::getPhysicalDeviceSparseImageFormatProperties2(physicalDevice, pFormatInfo, &n, null);
	SparseImageFormatProperties2* ret = (SparseImageFormatProperties2*) malloc(n * SparseImageFormatProperties2.sizeof);
	internal::getPhysicalDeviceSparseImageFormatProperties2(physicalDevice, pFormatInfo, &n, ret);
	return ret[:n];
}

fn SparseImageFormatProperties2[] getPhysicalDeviceSparseImageFormatProperties2KHR(PhysicalDevice physicalDevice, PhysicalDeviceSparseImageFormatInfo2* pFormatInfo) {
	uint n;
	internal::getPhysicalDeviceSparseImageFormatProperties2KHR(physicalDevice, pFormatInfo, &n, null);
	SparseImageFormatProperties2* ret = (SparseImageFormatProperties2*) malloc(n * SparseImageFormatProperties2.sizeof);
	internal::getPhysicalDeviceSparseImageFormatProperties2KHR(physicalDevice, pFormatInfo, &n, ret);
	return ret[:n];
}

fn FramebufferMixedSamplesCombinationNV[]! getPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::getPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV(physicalDevice, &n, null))!;
	FramebufferMixedSamplesCombinationNV* ret = (FramebufferMixedSamplesCombinationNV*) malloc(n * FramebufferMixedSamplesCombinationNV.sizeof);
	vk::check(internal::getPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn void! getPhysicalDeviceSurfaceCapabilities2EXT(PhysicalDevice physicalDevice, SurfaceKHR surface, SurfaceCapabilities2EXT* pSurfaceCapabilities) @inline {
	vk::check(internal::getPhysicalDeviceSurfaceCapabilities2EXT(physicalDevice, surface, pSurfaceCapabilities))!;
}

fn void! getPhysicalDeviceSurfaceCapabilities2KHR(PhysicalDevice physicalDevice, PhysicalDeviceSurfaceInfo2KHR* pSurfaceInfo, SurfaceCapabilities2KHR* pSurfaceCapabilities) @inline {
	vk::check(internal::getPhysicalDeviceSurfaceCapabilities2KHR(physicalDevice, pSurfaceInfo, pSurfaceCapabilities))!;
}

fn void! getPhysicalDeviceSurfaceCapabilitiesKHR(PhysicalDevice physicalDevice, SurfaceKHR surface, SurfaceCapabilitiesKHR* pSurfaceCapabilities) @inline {
	vk::check(internal::getPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface, pSurfaceCapabilities))!;
}

fn SurfaceFormat2KHR[]! getPhysicalDeviceSurfaceFormats2KHR(PhysicalDevice physicalDevice, PhysicalDeviceSurfaceInfo2KHR* pSurfaceInfo) {
	uint n;
	vk::check(internal::getPhysicalDeviceSurfaceFormats2KHR(physicalDevice, pSurfaceInfo, &n, null))!;
	SurfaceFormat2KHR* ret = (SurfaceFormat2KHR*) malloc(n * SurfaceFormat2KHR.sizeof);
	vk::check(internal::getPhysicalDeviceSurfaceFormats2KHR(physicalDevice, pSurfaceInfo, &n, ret))!;
	return ret[:n];
}

fn SurfaceFormatKHR[]! getPhysicalDeviceSurfaceFormatsKHR(PhysicalDevice physicalDevice, SurfaceKHR surface) {
	uint n;
	vk::check(internal::getPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, &n, null))!;
	SurfaceFormatKHR* ret = (SurfaceFormatKHR*) malloc(n * SurfaceFormatKHR.sizeof);
	vk::check(internal::getPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, &n, ret))!;
	return ret[:n];
}

fn PresentModeKHR[]! getPhysicalDeviceSurfacePresentModes2EXT(PhysicalDevice physicalDevice, PhysicalDeviceSurfaceInfo2KHR* pSurfaceInfo) {
	uint n;
	vk::check(internal::getPhysicalDeviceSurfacePresentModes2EXT(physicalDevice, pSurfaceInfo, &n, null))!;
	PresentModeKHR* ret = (PresentModeKHR*) malloc(n * PresentModeKHR.sizeof);
	vk::check(internal::getPhysicalDeviceSurfacePresentModes2EXT(physicalDevice, pSurfaceInfo, &n, ret))!;
	return ret[:n];
}

fn PresentModeKHR[]! getPhysicalDeviceSurfacePresentModesKHR(PhysicalDevice physicalDevice, SurfaceKHR surface) {
	uint n;
	vk::check(internal::getPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &n, null))!;
	PresentModeKHR* ret = (PresentModeKHR*) malloc(n * PresentModeKHR.sizeof);
	vk::check(internal::getPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &n, ret))!;
	return ret[:n];
}

fn void! getPhysicalDeviceSurfaceSupportKHR(PhysicalDevice physicalDevice, uint queueFamilyIndex, SurfaceKHR surface, uint* pSupported) @inline {
	vk::check(internal::getPhysicalDeviceSurfaceSupportKHR(physicalDevice, queueFamilyIndex, surface, pSupported))!;
}

fn PhysicalDeviceToolProperties[]! getPhysicalDeviceToolProperties(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::getPhysicalDeviceToolProperties(physicalDevice, &n, null))!;
	PhysicalDeviceToolProperties* ret = (PhysicalDeviceToolProperties*) malloc(n * PhysicalDeviceToolProperties.sizeof);
	vk::check(internal::getPhysicalDeviceToolProperties(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn PhysicalDeviceToolProperties[]! getPhysicalDeviceToolPropertiesEXT(PhysicalDevice physicalDevice) {
	uint n;
	vk::check(internal::getPhysicalDeviceToolPropertiesEXT(physicalDevice, &n, null))!;
	PhysicalDeviceToolProperties* ret = (PhysicalDeviceToolProperties*) malloc(n * PhysicalDeviceToolProperties.sizeof);
	vk::check(internal::getPhysicalDeviceToolPropertiesEXT(physicalDevice, &n, ret))!;
	return ret[:n];
}

fn void! getPhysicalDeviceVideoCapabilitiesKHR(PhysicalDevice physicalDevice, VideoProfileInfoKHR* pVideoProfile, VideoCapabilitiesKHR* pCapabilities) @inline {
	vk::check(internal::getPhysicalDeviceVideoCapabilitiesKHR(physicalDevice, pVideoProfile, pCapabilities))!;
}

fn void! getPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR(PhysicalDevice physicalDevice, PhysicalDeviceVideoEncodeQualityLevelInfoKHR* pQualityLevelInfo, VideoEncodeQualityLevelPropertiesKHR* pQualityLevelProperties) @inline {
	vk::check(internal::getPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR(physicalDevice, pQualityLevelInfo, pQualityLevelProperties))!;
}

fn VideoFormatPropertiesKHR[]! getPhysicalDeviceVideoFormatPropertiesKHR(PhysicalDevice physicalDevice, PhysicalDeviceVideoFormatInfoKHR* pVideoFormatInfo) {
	uint n;
	vk::check(internal::getPhysicalDeviceVideoFormatPropertiesKHR(physicalDevice, pVideoFormatInfo, &n, null))!;
	VideoFormatPropertiesKHR* ret = (VideoFormatPropertiesKHR*) malloc(n * VideoFormatPropertiesKHR.sizeof);
	vk::check(internal::getPhysicalDeviceVideoFormatPropertiesKHR(physicalDevice, pVideoFormatInfo, &n, ret))!;
	return ret[:n];
}

fn uint getPhysicalDeviceWaylandPresentationSupportKHR(PhysicalDevice physicalDevice, uint queueFamilyIndex, WLDisplay* display) @inline {
	return internal::getPhysicalDeviceWaylandPresentationSupportKHR(physicalDevice, queueFamilyIndex, display);
}

fn uint getPhysicalDeviceWin32PresentationSupportKHR(PhysicalDevice physicalDevice, uint queueFamilyIndex) @inline {
	return internal::getPhysicalDeviceWin32PresentationSupportKHR(physicalDevice, queueFamilyIndex);
}

fn uint getPhysicalDeviceXcbPresentationSupportKHR(PhysicalDevice physicalDevice, uint queueFamilyIndex, XCBConnection* connection, XCBVisualID visual_id) @inline {
	return internal::getPhysicalDeviceXcbPresentationSupportKHR(physicalDevice, queueFamilyIndex, connection, visual_id);
}

fn uint getPhysicalDeviceXlibPresentationSupportKHR(PhysicalDevice physicalDevice, uint queueFamilyIndex, XlibDisplay* dpy, XlibVisualID visualID) @inline {
	return internal::getPhysicalDeviceXlibPresentationSupportKHR(physicalDevice, queueFamilyIndex, dpy, visualID);
}

fn void! getWinrtDisplayNV(PhysicalDevice physicalDevice, uint deviceRelativeId, DisplayKHR* pDisplay) @inline {
	vk::check(internal::getWinrtDisplayNV(physicalDevice, deviceRelativeId, pDisplay))!;
}

fn void! releaseDisplayEXT(PhysicalDevice physicalDevice, DisplayKHR display) @inline {
	vk::check(internal::releaseDisplayEXT(physicalDevice, display))!;
}

fn void submitDebugUtilsMessageEXT(Instance instance, DebugUtilsMessageSeverityFlagsEXT messageSeverity, DebugUtilsMessageTypeFlagsEXT messageTypes, DebugUtilsMessengerCallbackDataEXT* pCallbackData) @inline {
	internal::submitDebugUtilsMessageEXT(instance, messageSeverity, messageTypes, pCallbackData);
}

fn void! acquireFullScreenExclusiveModeEXT(Device device, SwapchainKHR swapchain) @inline {
	vk::check(internal::acquireFullScreenExclusiveModeEXT(device, swapchain))!;
}

fn void! acquireNextImage2KHR(Device device, AcquireNextImageInfoKHR* pAcquireInfo, uint* pImageIndex) @inline {
	vk::check(internal::acquireNextImage2KHR(device, pAcquireInfo, pImageIndex))!;
}

fn void! acquireNextImageKHR(Device device, SwapchainKHR swapchain, ulong timeout, Semaphore semaphore, Fence fence, uint* pImageIndex) @inline {
	vk::check(internal::acquireNextImageKHR(device, swapchain, timeout, semaphore, fence, pImageIndex))!;
}

fn void! acquirePerformanceConfigurationINTEL(Device device, PerformanceConfigurationAcquireInfoINTEL* pAcquireInfo, PerformanceConfigurationINTEL* pConfiguration) @inline {
	vk::check(internal::acquirePerformanceConfigurationINTEL(device, pAcquireInfo, pConfiguration))!;
}

fn void! acquireProfilingLockKHR(Device device, AcquireProfilingLockInfoKHR* pInfo) @inline {
	vk::check(internal::acquireProfilingLockKHR(device, pInfo))!;
}

fn void! allocateCommandBuffers(Device device, CommandBufferAllocateInfo* pAllocateInfo, CommandBuffer* pCommandBuffers) @inline {
	vk::check(internal::allocateCommandBuffers(device, pAllocateInfo, pCommandBuffers))!;
}

fn void! allocateDescriptorSets(Device device, DescriptorSetAllocateInfo* pAllocateInfo, DescriptorSet* pDescriptorSets) @inline {
	vk::check(internal::allocateDescriptorSets(device, pAllocateInfo, pDescriptorSets))!;
}

fn void! allocateMemory(Device device, MemoryAllocateInfo* pAllocateInfo, AllocationCallbacks* pAllocator, DeviceMemory* pMemory) @inline {
	vk::check(internal::allocateMemory(device, pAllocateInfo, pAllocator, pMemory))!;
}

fn void antiLagUpdateAMD(Device device, AntiLagDataAMD* pData) @inline {
	internal::antiLagUpdateAMD(device, pData);
}

fn void! beginCommandBuffer(CommandBuffer commandBuffer, CommandBufferBeginInfo* pBeginInfo) @inline {
	vk::check(internal::beginCommandBuffer(commandBuffer, pBeginInfo))!;
}

fn void! bindAccelerationStructureMemoryNV(Device device, uint bindInfoCount, BindAccelerationStructureMemoryInfoNV* pBindInfos) @inline {
	vk::check(internal::bindAccelerationStructureMemoryNV(device, bindInfoCount, pBindInfos))!;
}

fn void! bindBufferMemory(Device device, Buffer buffer, DeviceMemory memory, DeviceSize memoryOffset) @inline {
	vk::check(internal::bindBufferMemory(device, buffer, memory, memoryOffset))!;
}

fn void! bindBufferMemory2(Device device, uint bindInfoCount, BindBufferMemoryInfo* pBindInfos) @inline {
	vk::check(internal::bindBufferMemory2(device, bindInfoCount, pBindInfos))!;
}

fn void! bindBufferMemory2KHR(Device device, uint bindInfoCount, BindBufferMemoryInfo* pBindInfos) @inline {
	vk::check(internal::bindBufferMemory2KHR(device, bindInfoCount, pBindInfos))!;
}

fn void! bindImageMemory(Device device, Image image, DeviceMemory memory, DeviceSize memoryOffset) @inline {
	vk::check(internal::bindImageMemory(device, image, memory, memoryOffset))!;
}

fn void! bindImageMemory2(Device device, uint bindInfoCount, BindImageMemoryInfo* pBindInfos) @inline {
	vk::check(internal::bindImageMemory2(device, bindInfoCount, pBindInfos))!;
}

fn void! bindImageMemory2KHR(Device device, uint bindInfoCount, BindImageMemoryInfo* pBindInfos) @inline {
	vk::check(internal::bindImageMemory2KHR(device, bindInfoCount, pBindInfos))!;
}

fn void! bindOpticalFlowSessionImageNV(Device device, OpticalFlowSessionNV session, OpticalFlowSessionBindingPointNV bindingPoint, ImageView view, ImageLayout layout) @inline {
	vk::check(internal::bindOpticalFlowSessionImageNV(device, session, bindingPoint, view, layout))!;
}

fn void! bindVideoSessionMemoryKHR(Device device, VideoSessionKHR videoSession, uint bindSessionMemoryInfoCount, BindVideoSessionMemoryInfoKHR* pBindSessionMemoryInfos) @inline {
	vk::check(internal::bindVideoSessionMemoryKHR(device, videoSession, bindSessionMemoryInfoCount, pBindSessionMemoryInfos))!;
}

fn void! buildAccelerationStructuresKHR(Device device, DeferredOperationKHR deferredOperation, uint infoCount, AccelerationStructureBuildGeometryInfoKHR* pInfos, AccelerationStructureBuildRangeInfoKHR** ppBuildRangeInfos) @inline {
	vk::check(internal::buildAccelerationStructuresKHR(device, deferredOperation, infoCount, pInfos, ppBuildRangeInfos))!;
}

fn void! buildMicromapsEXT(Device device, DeferredOperationKHR deferredOperation, uint infoCount, MicromapBuildInfoEXT* pInfos) @inline {
	vk::check(internal::buildMicromapsEXT(device, deferredOperation, infoCount, pInfos))!;
}

fn void cmdBeginConditionalRenderingEXT(CommandBuffer commandBuffer, ConditionalRenderingBeginInfoEXT* pConditionalRenderingBegin) @inline {
	internal::cmdBeginConditionalRenderingEXT(commandBuffer, pConditionalRenderingBegin);
}

fn void cmdBeginDebugUtilsLabelEXT(CommandBuffer commandBuffer, DebugUtilsLabelEXT* pLabelInfo) @inline {
	internal::cmdBeginDebugUtilsLabelEXT(commandBuffer, pLabelInfo);
}

fn void cmdBeginQuery(CommandBuffer commandBuffer, QueryPool queryPool, uint query, QueryControlFlags flags) @inline {
	internal::cmdBeginQuery(commandBuffer, queryPool, query, flags);
}

fn void cmdBeginQueryIndexedEXT(CommandBuffer commandBuffer, QueryPool queryPool, uint query, QueryControlFlags flags, uint index) @inline {
	internal::cmdBeginQueryIndexedEXT(commandBuffer, queryPool, query, flags, index);
}

fn void cmdBeginRenderPass(CommandBuffer commandBuffer, RenderPassBeginInfo* pRenderPassBegin, SubpassContents contents) @inline {
	internal::cmdBeginRenderPass(commandBuffer, pRenderPassBegin, contents);
}

fn void cmdBeginRenderPass2(CommandBuffer commandBuffer, RenderPassBeginInfo* pRenderPassBegin, SubpassBeginInfo* pSubpassBeginInfo) @inline {
	internal::cmdBeginRenderPass2(commandBuffer, pRenderPassBegin, pSubpassBeginInfo);
}

fn void cmdBeginRenderPass2KHR(CommandBuffer commandBuffer, RenderPassBeginInfo* pRenderPassBegin, SubpassBeginInfo* pSubpassBeginInfo) @inline {
	internal::cmdBeginRenderPass2KHR(commandBuffer, pRenderPassBegin, pSubpassBeginInfo);
}

fn void cmdBeginRendering(CommandBuffer commandBuffer, RenderingInfo* pRenderingInfo) @inline {
	internal::cmdBeginRendering(commandBuffer, pRenderingInfo);
}

fn void cmdBeginRenderingKHR(CommandBuffer commandBuffer, RenderingInfo* pRenderingInfo) @inline {
	internal::cmdBeginRenderingKHR(commandBuffer, pRenderingInfo);
}

fn void cmdBeginTransformFeedbackEXT(CommandBuffer commandBuffer, uint firstCounterBuffer, uint counterBufferCount, Buffer* pCounterBuffers, DeviceSize* pCounterBufferOffsets) @inline {
	internal::cmdBeginTransformFeedbackEXT(commandBuffer, firstCounterBuffer, counterBufferCount, pCounterBuffers, pCounterBufferOffsets);
}

fn void cmdBeginVideoCodingKHR(CommandBuffer commandBuffer, VideoBeginCodingInfoKHR* pBeginInfo) @inline {
	internal::cmdBeginVideoCodingKHR(commandBuffer, pBeginInfo);
}

fn void cmdBindDescriptorBufferEmbeddedSamplers2EXT(CommandBuffer commandBuffer, BindDescriptorBufferEmbeddedSamplersInfoEXT* pBindDescriptorBufferEmbeddedSamplersInfo) @inline {
	internal::cmdBindDescriptorBufferEmbeddedSamplers2EXT(commandBuffer, pBindDescriptorBufferEmbeddedSamplersInfo);
}

fn void cmdBindDescriptorBufferEmbeddedSamplersEXT(CommandBuffer commandBuffer, PipelineBindPoint pipelineBindPoint, PipelineLayout layout, uint set) @inline {
	internal::cmdBindDescriptorBufferEmbeddedSamplersEXT(commandBuffer, pipelineBindPoint, layout, set);
}

fn void cmdBindDescriptorBuffersEXT(CommandBuffer commandBuffer, uint bufferCount, DescriptorBufferBindingInfoEXT* pBindingInfos) @inline {
	internal::cmdBindDescriptorBuffersEXT(commandBuffer, bufferCount, pBindingInfos);
}

fn void cmdBindDescriptorSets(CommandBuffer commandBuffer, PipelineBindPoint pipelineBindPoint, PipelineLayout layout, uint firstSet, uint descriptorSetCount, DescriptorSet* pDescriptorSets, uint dynamicOffsetCount, uint* pDynamicOffsets) @inline {
	internal::cmdBindDescriptorSets(commandBuffer, pipelineBindPoint, layout, firstSet, descriptorSetCount, pDescriptorSets, dynamicOffsetCount, pDynamicOffsets);
}

fn void cmdBindDescriptorSets2(CommandBuffer commandBuffer, BindDescriptorSetsInfo* pBindDescriptorSetsInfo) @inline {
	internal::cmdBindDescriptorSets2(commandBuffer, pBindDescriptorSetsInfo);
}

fn void cmdBindDescriptorSets2KHR(CommandBuffer commandBuffer, BindDescriptorSetsInfo* pBindDescriptorSetsInfo) @inline {
	internal::cmdBindDescriptorSets2KHR(commandBuffer, pBindDescriptorSetsInfo);
}

fn void cmdBindIndexBuffer(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, IndexType indexType) @inline {
	internal::cmdBindIndexBuffer(commandBuffer, buffer, offset, indexType);
}

fn void cmdBindIndexBuffer2(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, DeviceSize size, IndexType indexType) @inline {
	internal::cmdBindIndexBuffer2(commandBuffer, buffer, offset, size, indexType);
}

fn void cmdBindIndexBuffer2KHR(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, DeviceSize size, IndexType indexType) @inline {
	internal::cmdBindIndexBuffer2KHR(commandBuffer, buffer, offset, size, indexType);
}

fn void cmdBindInvocationMaskHUAWEI(CommandBuffer commandBuffer, ImageView imageView, ImageLayout imageLayout) @inline {
	internal::cmdBindInvocationMaskHUAWEI(commandBuffer, imageView, imageLayout);
}

fn void cmdBindPipeline(CommandBuffer commandBuffer, PipelineBindPoint pipelineBindPoint, Pipeline pipeline) @inline {
	internal::cmdBindPipeline(commandBuffer, pipelineBindPoint, pipeline);
}

fn void cmdBindPipelineShaderGroupNV(CommandBuffer commandBuffer, PipelineBindPoint pipelineBindPoint, Pipeline pipeline, uint groupIndex) @inline {
	internal::cmdBindPipelineShaderGroupNV(commandBuffer, pipelineBindPoint, pipeline, groupIndex);
}

fn void cmdBindShadersEXT(CommandBuffer commandBuffer, uint stageCount, ShaderStageFlags* pStages, ShaderEXT* pShaders) @inline {
	internal::cmdBindShadersEXT(commandBuffer, stageCount, pStages, pShaders);
}

fn void cmdBindShadingRateImageNV(CommandBuffer commandBuffer, ImageView imageView, ImageLayout imageLayout) @inline {
	internal::cmdBindShadingRateImageNV(commandBuffer, imageView, imageLayout);
}

fn void cmdBindTransformFeedbackBuffersEXT(CommandBuffer commandBuffer, uint firstBinding, uint bindingCount, Buffer* pBuffers, DeviceSize* pOffsets, DeviceSize* pSizes) @inline {
	internal::cmdBindTransformFeedbackBuffersEXT(commandBuffer, firstBinding, bindingCount, pBuffers, pOffsets, pSizes);
}

fn void cmdBindVertexBuffers(CommandBuffer commandBuffer, uint firstBinding, uint bindingCount, Buffer* pBuffers, DeviceSize* pOffsets) @inline {
	internal::cmdBindVertexBuffers(commandBuffer, firstBinding, bindingCount, pBuffers, pOffsets);
}

fn void cmdBindVertexBuffers2(CommandBuffer commandBuffer, uint firstBinding, uint bindingCount, Buffer* pBuffers, DeviceSize* pOffsets, DeviceSize* pSizes, DeviceSize* pStrides) @inline {
	internal::cmdBindVertexBuffers2(commandBuffer, firstBinding, bindingCount, pBuffers, pOffsets, pSizes, pStrides);
}

fn void cmdBindVertexBuffers2EXT(CommandBuffer commandBuffer, uint firstBinding, uint bindingCount, Buffer* pBuffers, DeviceSize* pOffsets, DeviceSize* pSizes, DeviceSize* pStrides) @inline {
	internal::cmdBindVertexBuffers2EXT(commandBuffer, firstBinding, bindingCount, pBuffers, pOffsets, pSizes, pStrides);
}

fn void cmdBlitImage(CommandBuffer commandBuffer, Image srcImage, ImageLayout srcImageLayout, Image dstImage, ImageLayout dstImageLayout, uint regionCount, ImageBlit* pRegions, Filter filter) @inline {
	internal::cmdBlitImage(commandBuffer, srcImage, srcImageLayout, dstImage, dstImageLayout, regionCount, pRegions, filter);
}

fn void cmdBlitImage2(CommandBuffer commandBuffer, BlitImageInfo2* pBlitImageInfo) @inline {
	internal::cmdBlitImage2(commandBuffer, pBlitImageInfo);
}

fn void cmdBlitImage2KHR(CommandBuffer commandBuffer, BlitImageInfo2* pBlitImageInfo) @inline {
	internal::cmdBlitImage2KHR(commandBuffer, pBlitImageInfo);
}

fn void cmdBuildAccelerationStructureNV(CommandBuffer commandBuffer, AccelerationStructureInfoNV* pInfo, Buffer instanceData, DeviceSize instanceOffset, uint update, AccelerationStructureNV dst, AccelerationStructureNV src, Buffer scratch, DeviceSize scratchOffset) @inline {
	internal::cmdBuildAccelerationStructureNV(commandBuffer, pInfo, instanceData, instanceOffset, update, dst, src, scratch, scratchOffset);
}

fn void cmdBuildAccelerationStructuresIndirectKHR(CommandBuffer commandBuffer, uint infoCount, AccelerationStructureBuildGeometryInfoKHR* pInfos, DeviceAddress* pIndirectDeviceAddresses, uint* pIndirectStrides, uint*[] ppMaxPrimitiveCounts) @inline {
	internal::cmdBuildAccelerationStructuresIndirectKHR(commandBuffer, infoCount, pInfos, pIndirectDeviceAddresses, pIndirectStrides, ppMaxPrimitiveCounts);
}

fn void cmdBuildAccelerationStructuresKHR(CommandBuffer commandBuffer, uint infoCount, AccelerationStructureBuildGeometryInfoKHR* pInfos, AccelerationStructureBuildRangeInfoKHR** ppBuildRangeInfos) @inline {
	internal::cmdBuildAccelerationStructuresKHR(commandBuffer, infoCount, pInfos, ppBuildRangeInfos);
}

fn void cmdBuildClusterAccelerationStructureIndirectNV(CommandBuffer commandBuffer, ClusterAccelerationStructureCommandsInfoNV* pCommandInfos) @inline {
	internal::cmdBuildClusterAccelerationStructureIndirectNV(commandBuffer, pCommandInfos);
}

fn void cmdBuildMicromapsEXT(CommandBuffer commandBuffer, uint infoCount, MicromapBuildInfoEXT* pInfos) @inline {
	internal::cmdBuildMicromapsEXT(commandBuffer, infoCount, pInfos);
}

fn void cmdBuildPartitionedAccelerationStructuresNV(CommandBuffer commandBuffer, BuildPartitionedAccelerationStructureInfoNV* pBuildInfo) @inline {
	internal::cmdBuildPartitionedAccelerationStructuresNV(commandBuffer, pBuildInfo);
}

fn void cmdClearAttachments(CommandBuffer commandBuffer, uint attachmentCount, ClearAttachment* pAttachments, uint rectCount, ClearRect* pRects) @inline {
	internal::cmdClearAttachments(commandBuffer, attachmentCount, pAttachments, rectCount, pRects);
}

fn void cmdClearColorImage(CommandBuffer commandBuffer, Image image, ImageLayout imageLayout, ClearColorValue* pColor, uint rangeCount, ImageSubresourceRange* pRanges) @inline {
	internal::cmdClearColorImage(commandBuffer, image, imageLayout, pColor, rangeCount, pRanges);
}

fn void cmdClearDepthStencilImage(CommandBuffer commandBuffer, Image image, ImageLayout imageLayout, ClearDepthStencilValue* pDepthStencil, uint rangeCount, ImageSubresourceRange* pRanges) @inline {
	internal::cmdClearDepthStencilImage(commandBuffer, image, imageLayout, pDepthStencil, rangeCount, pRanges);
}

fn void cmdControlVideoCodingKHR(CommandBuffer commandBuffer, VideoCodingControlInfoKHR* pCodingControlInfo) @inline {
	internal::cmdControlVideoCodingKHR(commandBuffer, pCodingControlInfo);
}

fn void cmdConvertCooperativeVectorMatrixNV(CommandBuffer commandBuffer, uint infoCount, ConvertCooperativeVectorMatrixInfoNV* pInfos) @inline {
	internal::cmdConvertCooperativeVectorMatrixNV(commandBuffer, infoCount, pInfos);
}

fn void cmdCopyAccelerationStructureKHR(CommandBuffer commandBuffer, CopyAccelerationStructureInfoKHR* pInfo) @inline {
	internal::cmdCopyAccelerationStructureKHR(commandBuffer, pInfo);
}

fn void cmdCopyAccelerationStructureNV(CommandBuffer commandBuffer, AccelerationStructureNV dst, AccelerationStructureNV src, CopyAccelerationStructureModeKHR mode) @inline {
	internal::cmdCopyAccelerationStructureNV(commandBuffer, dst, src, mode);
}

fn void cmdCopyAccelerationStructureToMemoryKHR(CommandBuffer commandBuffer, CopyAccelerationStructureToMemoryInfoKHR* pInfo) @inline {
	internal::cmdCopyAccelerationStructureToMemoryKHR(commandBuffer, pInfo);
}

fn void cmdCopyBuffer(CommandBuffer commandBuffer, Buffer srcBuffer, Buffer dstBuffer, uint regionCount, BufferCopy* pRegions) @inline {
	internal::cmdCopyBuffer(commandBuffer, srcBuffer, dstBuffer, regionCount, pRegions);
}

fn void cmdCopyBuffer2(CommandBuffer commandBuffer, CopyBufferInfo2* pCopyBufferInfo) @inline {
	internal::cmdCopyBuffer2(commandBuffer, pCopyBufferInfo);
}

fn void cmdCopyBuffer2KHR(CommandBuffer commandBuffer, CopyBufferInfo2* pCopyBufferInfo) @inline {
	internal::cmdCopyBuffer2KHR(commandBuffer, pCopyBufferInfo);
}

fn void cmdCopyBufferToImage(CommandBuffer commandBuffer, Buffer srcBuffer, Image dstImage, ImageLayout dstImageLayout, uint regionCount, BufferImageCopy* pRegions) @inline {
	internal::cmdCopyBufferToImage(commandBuffer, srcBuffer, dstImage, dstImageLayout, regionCount, pRegions);
}

fn void cmdCopyBufferToImage2(CommandBuffer commandBuffer, CopyBufferToImageInfo2* pCopyBufferToImageInfo) @inline {
	internal::cmdCopyBufferToImage2(commandBuffer, pCopyBufferToImageInfo);
}

fn void cmdCopyBufferToImage2KHR(CommandBuffer commandBuffer, CopyBufferToImageInfo2* pCopyBufferToImageInfo) @inline {
	internal::cmdCopyBufferToImage2KHR(commandBuffer, pCopyBufferToImageInfo);
}

fn void cmdCopyImage(CommandBuffer commandBuffer, Image srcImage, ImageLayout srcImageLayout, Image dstImage, ImageLayout dstImageLayout, uint regionCount, ImageCopy* pRegions) @inline {
	internal::cmdCopyImage(commandBuffer, srcImage, srcImageLayout, dstImage, dstImageLayout, regionCount, pRegions);
}

fn void cmdCopyImage2(CommandBuffer commandBuffer, CopyImageInfo2* pCopyImageInfo) @inline {
	internal::cmdCopyImage2(commandBuffer, pCopyImageInfo);
}

fn void cmdCopyImage2KHR(CommandBuffer commandBuffer, CopyImageInfo2* pCopyImageInfo) @inline {
	internal::cmdCopyImage2KHR(commandBuffer, pCopyImageInfo);
}

fn void cmdCopyImageToBuffer(CommandBuffer commandBuffer, Image srcImage, ImageLayout srcImageLayout, Buffer dstBuffer, uint regionCount, BufferImageCopy* pRegions) @inline {
	internal::cmdCopyImageToBuffer(commandBuffer, srcImage, srcImageLayout, dstBuffer, regionCount, pRegions);
}

fn void cmdCopyImageToBuffer2(CommandBuffer commandBuffer, CopyImageToBufferInfo2* pCopyImageToBufferInfo) @inline {
	internal::cmdCopyImageToBuffer2(commandBuffer, pCopyImageToBufferInfo);
}

fn void cmdCopyImageToBuffer2KHR(CommandBuffer commandBuffer, CopyImageToBufferInfo2* pCopyImageToBufferInfo) @inline {
	internal::cmdCopyImageToBuffer2KHR(commandBuffer, pCopyImageToBufferInfo);
}

fn void cmdCopyMemoryIndirectNV(CommandBuffer commandBuffer, DeviceAddress copyBufferAddress, uint copyCount, uint stride) @inline {
	internal::cmdCopyMemoryIndirectNV(commandBuffer, copyBufferAddress, copyCount, stride);
}

fn void cmdCopyMemoryToAccelerationStructureKHR(CommandBuffer commandBuffer, CopyMemoryToAccelerationStructureInfoKHR* pInfo) @inline {
	internal::cmdCopyMemoryToAccelerationStructureKHR(commandBuffer, pInfo);
}

fn void cmdCopyMemoryToImageIndirectNV(CommandBuffer commandBuffer, DeviceAddress copyBufferAddress, uint copyCount, uint stride, Image dstImage, ImageLayout dstImageLayout, ImageSubresourceLayers* pImageSubresources) @inline {
	internal::cmdCopyMemoryToImageIndirectNV(commandBuffer, copyBufferAddress, copyCount, stride, dstImage, dstImageLayout, pImageSubresources);
}

fn void cmdCopyMemoryToMicromapEXT(CommandBuffer commandBuffer, CopyMemoryToMicromapInfoEXT* pInfo) @inline {
	internal::cmdCopyMemoryToMicromapEXT(commandBuffer, pInfo);
}

fn void cmdCopyMicromapEXT(CommandBuffer commandBuffer, CopyMicromapInfoEXT* pInfo) @inline {
	internal::cmdCopyMicromapEXT(commandBuffer, pInfo);
}

fn void cmdCopyMicromapToMemoryEXT(CommandBuffer commandBuffer, CopyMicromapToMemoryInfoEXT* pInfo) @inline {
	internal::cmdCopyMicromapToMemoryEXT(commandBuffer, pInfo);
}

fn void cmdCopyQueryPoolResults(CommandBuffer commandBuffer, QueryPool queryPool, uint firstQuery, uint queryCount, Buffer dstBuffer, DeviceSize dstOffset, DeviceSize stride, QueryResultFlags flags) @inline {
	internal::cmdCopyQueryPoolResults(commandBuffer, queryPool, firstQuery, queryCount, dstBuffer, dstOffset, stride, flags);
}

fn void cmdCuLaunchKernelNVX(CommandBuffer commandBuffer, CuLaunchInfoNVX* pLaunchInfo) @inline {
	internal::cmdCuLaunchKernelNVX(commandBuffer, pLaunchInfo);
}

fn void cmdCudaLaunchKernelNV(CommandBuffer commandBuffer, CudaLaunchInfoNV* pLaunchInfo) @inline {
	internal::cmdCudaLaunchKernelNV(commandBuffer, pLaunchInfo);
}

fn void cmdDebugMarkerBeginEXT(CommandBuffer commandBuffer, DebugMarkerMarkerInfoEXT* pMarkerInfo) @inline {
	internal::cmdDebugMarkerBeginEXT(commandBuffer, pMarkerInfo);
}

fn void cmdDebugMarkerEndEXT(CommandBuffer commandBuffer) @inline {
	internal::cmdDebugMarkerEndEXT(commandBuffer);
}

fn void cmdDebugMarkerInsertEXT(CommandBuffer commandBuffer, DebugMarkerMarkerInfoEXT* pMarkerInfo) @inline {
	internal::cmdDebugMarkerInsertEXT(commandBuffer, pMarkerInfo);
}

fn void cmdDecodeVideoKHR(CommandBuffer commandBuffer, VideoDecodeInfoKHR* pDecodeInfo) @inline {
	internal::cmdDecodeVideoKHR(commandBuffer, pDecodeInfo);
}

fn void cmdDecompressMemoryIndirectCountNV(CommandBuffer commandBuffer, DeviceAddress indirectCommandsAddress, DeviceAddress indirectCommandsCountAddress, uint stride) @inline {
	internal::cmdDecompressMemoryIndirectCountNV(commandBuffer, indirectCommandsAddress, indirectCommandsCountAddress, stride);
}

fn void cmdDecompressMemoryNV(CommandBuffer commandBuffer, uint decompressRegionCount, DecompressMemoryRegionNV* pDecompressMemoryRegions) @inline {
	internal::cmdDecompressMemoryNV(commandBuffer, decompressRegionCount, pDecompressMemoryRegions);
}

fn void cmdDispatch(CommandBuffer commandBuffer, uint groupCountX, uint groupCountY, uint groupCountZ) @inline {
	internal::cmdDispatch(commandBuffer, groupCountX, groupCountY, groupCountZ);
}

fn void cmdDispatchBase(CommandBuffer commandBuffer, uint baseGroupX, uint baseGroupY, uint baseGroupZ, uint groupCountX, uint groupCountY, uint groupCountZ) @inline {
	internal::cmdDispatchBase(commandBuffer, baseGroupX, baseGroupY, baseGroupZ, groupCountX, groupCountY, groupCountZ);
}

fn void cmdDispatchBaseKHR(CommandBuffer commandBuffer, uint baseGroupX, uint baseGroupY, uint baseGroupZ, uint groupCountX, uint groupCountY, uint groupCountZ) @inline {
	internal::cmdDispatchBaseKHR(commandBuffer, baseGroupX, baseGroupY, baseGroupZ, groupCountX, groupCountY, groupCountZ);
}

fn void cmdDispatchIndirect(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset) @inline {
	internal::cmdDispatchIndirect(commandBuffer, buffer, offset);
}

fn void cmdDraw(CommandBuffer commandBuffer, uint vertexCount, uint instanceCount, uint firstVertex, uint firstInstance) @inline {
	internal::cmdDraw(commandBuffer, vertexCount, instanceCount, firstVertex, firstInstance);
}

fn void cmdDrawClusterHUAWEI(CommandBuffer commandBuffer, uint groupCountX, uint groupCountY, uint groupCountZ) @inline {
	internal::cmdDrawClusterHUAWEI(commandBuffer, groupCountX, groupCountY, groupCountZ);
}

fn void cmdDrawClusterIndirectHUAWEI(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset) @inline {
	internal::cmdDrawClusterIndirectHUAWEI(commandBuffer, buffer, offset);
}

fn void cmdDrawIndexed(CommandBuffer commandBuffer, uint indexCount, uint instanceCount, uint firstIndex, int vertexOffset, uint firstInstance) @inline {
	internal::cmdDrawIndexed(commandBuffer, indexCount, instanceCount, firstIndex, vertexOffset, firstInstance);
}

fn void cmdDrawIndexedIndirect(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, uint drawCount, uint stride) @inline {
	internal::cmdDrawIndexedIndirect(commandBuffer, buffer, offset, drawCount, stride);
}

fn void cmdDrawIndexedIndirectCount(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, Buffer countBuffer, DeviceSize countBufferOffset, uint maxDrawCount, uint stride) @inline {
	internal::cmdDrawIndexedIndirectCount(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride);
}

fn void cmdDrawIndexedIndirectCountAMD(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, Buffer countBuffer, DeviceSize countBufferOffset, uint maxDrawCount, uint stride) @inline {
	internal::cmdDrawIndexedIndirectCountAMD(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride);
}

fn void cmdDrawIndexedIndirectCountKHR(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, Buffer countBuffer, DeviceSize countBufferOffset, uint maxDrawCount, uint stride) @inline {
	internal::cmdDrawIndexedIndirectCountKHR(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride);
}

fn void cmdDrawIndirect(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, uint drawCount, uint stride) @inline {
	internal::cmdDrawIndirect(commandBuffer, buffer, offset, drawCount, stride);
}

fn void cmdDrawIndirectByteCountEXT(CommandBuffer commandBuffer, uint instanceCount, uint firstInstance, Buffer counterBuffer, DeviceSize counterBufferOffset, uint counterOffset, uint vertexStride) @inline {
	internal::cmdDrawIndirectByteCountEXT(commandBuffer, instanceCount, firstInstance, counterBuffer, counterBufferOffset, counterOffset, vertexStride);
}

fn void cmdDrawIndirectCount(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, Buffer countBuffer, DeviceSize countBufferOffset, uint maxDrawCount, uint stride) @inline {
	internal::cmdDrawIndirectCount(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride);
}

fn void cmdDrawIndirectCountAMD(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, Buffer countBuffer, DeviceSize countBufferOffset, uint maxDrawCount, uint stride) @inline {
	internal::cmdDrawIndirectCountAMD(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride);
}

fn void cmdDrawIndirectCountKHR(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, Buffer countBuffer, DeviceSize countBufferOffset, uint maxDrawCount, uint stride) @inline {
	internal::cmdDrawIndirectCountKHR(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride);
}

fn void cmdDrawMeshTasksEXT(CommandBuffer commandBuffer, uint groupCountX, uint groupCountY, uint groupCountZ) @inline {
	internal::cmdDrawMeshTasksEXT(commandBuffer, groupCountX, groupCountY, groupCountZ);
}

fn void cmdDrawMeshTasksIndirectCountEXT(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, Buffer countBuffer, DeviceSize countBufferOffset, uint maxDrawCount, uint stride) @inline {
	internal::cmdDrawMeshTasksIndirectCountEXT(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride);
}

fn void cmdDrawMeshTasksIndirectCountNV(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, Buffer countBuffer, DeviceSize countBufferOffset, uint maxDrawCount, uint stride) @inline {
	internal::cmdDrawMeshTasksIndirectCountNV(commandBuffer, buffer, offset, countBuffer, countBufferOffset, maxDrawCount, stride);
}

fn void cmdDrawMeshTasksIndirectEXT(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, uint drawCount, uint stride) @inline {
	internal::cmdDrawMeshTasksIndirectEXT(commandBuffer, buffer, offset, drawCount, stride);
}

fn void cmdDrawMeshTasksIndirectNV(CommandBuffer commandBuffer, Buffer buffer, DeviceSize offset, uint drawCount, uint stride) @inline {
	internal::cmdDrawMeshTasksIndirectNV(commandBuffer, buffer, offset, drawCount, stride);
}

fn void cmdDrawMeshTasksNV(CommandBuffer commandBuffer, uint taskCount, uint firstTask) @inline {
	internal::cmdDrawMeshTasksNV(commandBuffer, taskCount, firstTask);
}

fn void cmdDrawMultiEXT(CommandBuffer commandBuffer, uint drawCount, MultiDrawInfoEXT* pVertexInfo, uint instanceCount, uint firstInstance, uint stride) @inline {
	internal::cmdDrawMultiEXT(commandBuffer, drawCount, pVertexInfo, instanceCount, firstInstance, stride);
}

fn void cmdDrawMultiIndexedEXT(CommandBuffer commandBuffer, uint drawCount, MultiDrawIndexedInfoEXT* pIndexInfo, uint instanceCount, uint firstInstance, uint stride, int* pVertexOffset) @inline {
	internal::cmdDrawMultiIndexedEXT(commandBuffer, drawCount, pIndexInfo, instanceCount, firstInstance, stride, pVertexOffset);
}

fn void cmdEncodeVideoKHR(CommandBuffer commandBuffer, VideoEncodeInfoKHR* pEncodeInfo) @inline {
	internal::cmdEncodeVideoKHR(commandBuffer, pEncodeInfo);
}

fn void cmdEndConditionalRenderingEXT(CommandBuffer commandBuffer) @inline {
	internal::cmdEndConditionalRenderingEXT(commandBuffer);
}

fn void cmdEndDebugUtilsLabelEXT(CommandBuffer commandBuffer) @inline {
	internal::cmdEndDebugUtilsLabelEXT(commandBuffer);
}

fn void cmdEndQuery(CommandBuffer commandBuffer, QueryPool queryPool, uint query) @inline {
	internal::cmdEndQuery(commandBuffer, queryPool, query);
}

fn void cmdEndQueryIndexedEXT(CommandBuffer commandBuffer, QueryPool queryPool, uint query, uint index) @inline {
	internal::cmdEndQueryIndexedEXT(commandBuffer, queryPool, query, index);
}

fn void cmdEndRenderPass(CommandBuffer commandBuffer) @inline {
	internal::cmdEndRenderPass(commandBuffer);
}

fn void cmdEndRenderPass2(CommandBuffer commandBuffer, SubpassEndInfo* pSubpassEndInfo) @inline {
	internal::cmdEndRenderPass2(commandBuffer, pSubpassEndInfo);
}

fn void cmdEndRenderPass2KHR(CommandBuffer commandBuffer, SubpassEndInfo* pSubpassEndInfo) @inline {
	internal::cmdEndRenderPass2KHR(commandBuffer, pSubpassEndInfo);
}

fn void cmdEndRendering(CommandBuffer commandBuffer) @inline {
	internal::cmdEndRendering(commandBuffer);
}

fn void cmdEndRenderingKHR(CommandBuffer commandBuffer) @inline {
	internal::cmdEndRenderingKHR(commandBuffer);
}

fn void cmdEndTransformFeedbackEXT(CommandBuffer commandBuffer, uint firstCounterBuffer, uint counterBufferCount, Buffer* pCounterBuffers, DeviceSize* pCounterBufferOffsets) @inline {
	internal::cmdEndTransformFeedbackEXT(commandBuffer, firstCounterBuffer, counterBufferCount, pCounterBuffers, pCounterBufferOffsets);
}

fn void cmdEndVideoCodingKHR(CommandBuffer commandBuffer, VideoEndCodingInfoKHR* pEndCodingInfo) @inline {
	internal::cmdEndVideoCodingKHR(commandBuffer, pEndCodingInfo);
}

fn void cmdExecuteCommands(CommandBuffer commandBuffer, uint commandBufferCount, CommandBuffer* pCommandBuffers) @inline {
	internal::cmdExecuteCommands(commandBuffer, commandBufferCount, pCommandBuffers);
}

fn void cmdExecuteGeneratedCommandsEXT(CommandBuffer commandBuffer, uint isPreprocessed, GeneratedCommandsInfoEXT* pGeneratedCommandsInfo) @inline {
	internal::cmdExecuteGeneratedCommandsEXT(commandBuffer, isPreprocessed, pGeneratedCommandsInfo);
}

fn void cmdExecuteGeneratedCommandsNV(CommandBuffer commandBuffer, uint isPreprocessed, GeneratedCommandsInfoNV* pGeneratedCommandsInfo) @inline {
	internal::cmdExecuteGeneratedCommandsNV(commandBuffer, isPreprocessed, pGeneratedCommandsInfo);
}

fn void cmdFillBuffer(CommandBuffer commandBuffer, Buffer dstBuffer, DeviceSize dstOffset, DeviceSize size, uint data) @inline {
	internal::cmdFillBuffer(commandBuffer, dstBuffer, dstOffset, size, data);
}

fn void cmdInsertDebugUtilsLabelEXT(CommandBuffer commandBuffer, DebugUtilsLabelEXT* pLabelInfo) @inline {
	internal::cmdInsertDebugUtilsLabelEXT(commandBuffer, pLabelInfo);
}

fn void cmdNextSubpass(CommandBuffer commandBuffer, SubpassContents contents) @inline {
	internal::cmdNextSubpass(commandBuffer, contents);
}

fn void cmdNextSubpass2(CommandBuffer commandBuffer, SubpassBeginInfo* pSubpassBeginInfo, SubpassEndInfo* pSubpassEndInfo) @inline {
	internal::cmdNextSubpass2(commandBuffer, pSubpassBeginInfo, pSubpassEndInfo);
}

fn void cmdNextSubpass2KHR(CommandBuffer commandBuffer, SubpassBeginInfo* pSubpassBeginInfo, SubpassEndInfo* pSubpassEndInfo) @inline {
	internal::cmdNextSubpass2KHR(commandBuffer, pSubpassBeginInfo, pSubpassEndInfo);
}

fn void cmdOpticalFlowExecuteNV(CommandBuffer commandBuffer, OpticalFlowSessionNV session, OpticalFlowExecuteInfoNV* pExecuteInfo) @inline {
	internal::cmdOpticalFlowExecuteNV(commandBuffer, session, pExecuteInfo);
}

fn void cmdPipelineBarrier(CommandBuffer commandBuffer, PipelineStageFlags srcStageMask, PipelineStageFlags dstStageMask, DependencyFlags dependencyFlags, uint memoryBarrierCount, MemoryBarrier* pMemoryBarriers, uint bufferMemoryBarrierCount, BufferMemoryBarrier* pBufferMemoryBarriers, uint imageMemoryBarrierCount, ImageMemoryBarrier* pImageMemoryBarriers) @inline {
	internal::cmdPipelineBarrier(commandBuffer, srcStageMask, dstStageMask, dependencyFlags, memoryBarrierCount, pMemoryBarriers, bufferMemoryBarrierCount, pBufferMemoryBarriers, imageMemoryBarrierCount, pImageMemoryBarriers);
}

fn void cmdPipelineBarrier2(CommandBuffer commandBuffer, DependencyInfo* pDependencyInfo) @inline {
	internal::cmdPipelineBarrier2(commandBuffer, pDependencyInfo);
}

fn void cmdPipelineBarrier2KHR(CommandBuffer commandBuffer, DependencyInfo* pDependencyInfo) @inline {
	internal::cmdPipelineBarrier2KHR(commandBuffer, pDependencyInfo);
}

fn void cmdPreprocessGeneratedCommandsEXT(CommandBuffer commandBuffer, GeneratedCommandsInfoEXT* pGeneratedCommandsInfo, CommandBuffer stateCommandBuffer) @inline {
	internal::cmdPreprocessGeneratedCommandsEXT(commandBuffer, pGeneratedCommandsInfo, stateCommandBuffer);
}

fn void cmdPreprocessGeneratedCommandsNV(CommandBuffer commandBuffer, GeneratedCommandsInfoNV* pGeneratedCommandsInfo) @inline {
	internal::cmdPreprocessGeneratedCommandsNV(commandBuffer, pGeneratedCommandsInfo);
}

fn void cmdPushConstants(CommandBuffer commandBuffer, PipelineLayout layout, ShaderStageFlags stageFlags, uint offset, uint size, void* pValues) @inline {
	internal::cmdPushConstants(commandBuffer, layout, stageFlags, offset, size, pValues);
}

fn void cmdPushConstants2(CommandBuffer commandBuffer, PushConstantsInfo* pPushConstantsInfo) @inline {
	internal::cmdPushConstants2(commandBuffer, pPushConstantsInfo);
}

fn void cmdPushConstants2KHR(CommandBuffer commandBuffer, PushConstantsInfo* pPushConstantsInfo) @inline {
	internal::cmdPushConstants2KHR(commandBuffer, pPushConstantsInfo);
}

fn void cmdPushDescriptorSet(CommandBuffer commandBuffer, PipelineBindPoint pipelineBindPoint, PipelineLayout layout, uint set, uint descriptorWriteCount, WriteDescriptorSet* pDescriptorWrites) @inline {
	internal::cmdPushDescriptorSet(commandBuffer, pipelineBindPoint, layout, set, descriptorWriteCount, pDescriptorWrites);
}

fn void cmdPushDescriptorSet2(CommandBuffer commandBuffer, PushDescriptorSetInfo* pPushDescriptorSetInfo) @inline {
	internal::cmdPushDescriptorSet2(commandBuffer, pPushDescriptorSetInfo);
}

fn void cmdPushDescriptorSet2KHR(CommandBuffer commandBuffer, PushDescriptorSetInfo* pPushDescriptorSetInfo) @inline {
	internal::cmdPushDescriptorSet2KHR(commandBuffer, pPushDescriptorSetInfo);
}

fn void cmdPushDescriptorSetKHR(CommandBuffer commandBuffer, PipelineBindPoint pipelineBindPoint, PipelineLayout layout, uint set, uint descriptorWriteCount, WriteDescriptorSet* pDescriptorWrites) @inline {
	internal::cmdPushDescriptorSetKHR(commandBuffer, pipelineBindPoint, layout, set, descriptorWriteCount, pDescriptorWrites);
}

fn void cmdPushDescriptorSetWithTemplate(CommandBuffer commandBuffer, DescriptorUpdateTemplate descriptorUpdateTemplate, PipelineLayout layout, uint set, void* pData) @inline {
	internal::cmdPushDescriptorSetWithTemplate(commandBuffer, descriptorUpdateTemplate, layout, set, pData);
}

fn void cmdPushDescriptorSetWithTemplate2(CommandBuffer commandBuffer, PushDescriptorSetWithTemplateInfo* pPushDescriptorSetWithTemplateInfo) @inline {
	internal::cmdPushDescriptorSetWithTemplate2(commandBuffer, pPushDescriptorSetWithTemplateInfo);
}

fn void cmdPushDescriptorSetWithTemplate2KHR(CommandBuffer commandBuffer, PushDescriptorSetWithTemplateInfo* pPushDescriptorSetWithTemplateInfo) @inline {
	internal::cmdPushDescriptorSetWithTemplate2KHR(commandBuffer, pPushDescriptorSetWithTemplateInfo);
}

fn void cmdPushDescriptorSetWithTemplateKHR(CommandBuffer commandBuffer, DescriptorUpdateTemplate descriptorUpdateTemplate, PipelineLayout layout, uint set, void* pData) @inline {
	internal::cmdPushDescriptorSetWithTemplateKHR(commandBuffer, descriptorUpdateTemplate, layout, set, pData);
}

fn void cmdResetEvent(CommandBuffer commandBuffer, Event event, PipelineStageFlags stageMask) @inline {
	internal::cmdResetEvent(commandBuffer, event, stageMask);
}

fn void cmdResetEvent2(CommandBuffer commandBuffer, Event event, PipelineStageFlags2 stageMask) @inline {
	internal::cmdResetEvent2(commandBuffer, event, stageMask);
}

fn void cmdResetEvent2KHR(CommandBuffer commandBuffer, Event event, PipelineStageFlags2 stageMask) @inline {
	internal::cmdResetEvent2KHR(commandBuffer, event, stageMask);
}

fn void cmdResetQueryPool(CommandBuffer commandBuffer, QueryPool queryPool, uint firstQuery, uint queryCount) @inline {
	internal::cmdResetQueryPool(commandBuffer, queryPool, firstQuery, queryCount);
}

fn void cmdResolveImage(CommandBuffer commandBuffer, Image srcImage, ImageLayout srcImageLayout, Image dstImage, ImageLayout dstImageLayout, uint regionCount, ImageResolve* pRegions) @inline {
	internal::cmdResolveImage(commandBuffer, srcImage, srcImageLayout, dstImage, dstImageLayout, regionCount, pRegions);
}

fn void cmdResolveImage2(CommandBuffer commandBuffer, ResolveImageInfo2* pResolveImageInfo) @inline {
	internal::cmdResolveImage2(commandBuffer, pResolveImageInfo);
}

fn void cmdResolveImage2KHR(CommandBuffer commandBuffer, ResolveImageInfo2* pResolveImageInfo) @inline {
	internal::cmdResolveImage2KHR(commandBuffer, pResolveImageInfo);
}

fn void cmdSetAlphaToCoverageEnableEXT(CommandBuffer commandBuffer, uint alphaToCoverageEnable) @inline {
	internal::cmdSetAlphaToCoverageEnableEXT(commandBuffer, alphaToCoverageEnable);
}

fn void cmdSetAlphaToOneEnableEXT(CommandBuffer commandBuffer, uint alphaToOneEnable) @inline {
	internal::cmdSetAlphaToOneEnableEXT(commandBuffer, alphaToOneEnable);
}

fn void cmdSetAttachmentFeedbackLoopEnableEXT(CommandBuffer commandBuffer, ImageAspectFlags aspectMask) @inline {
	internal::cmdSetAttachmentFeedbackLoopEnableEXT(commandBuffer, aspectMask);
}

fn void cmdSetBlendConstants(CommandBuffer commandBuffer, float*[4] blendConstants) @inline {
	internal::cmdSetBlendConstants(commandBuffer, blendConstants);
}

fn void cmdSetCheckpointNV(CommandBuffer commandBuffer, void* pCheckpointMarker) @inline {
	internal::cmdSetCheckpointNV(commandBuffer, pCheckpointMarker);
}

fn void cmdSetCoarseSampleOrderNV(CommandBuffer commandBuffer, CoarseSampleOrderTypeNV sampleOrderType, uint customSampleOrderCount, CoarseSampleOrderCustomNV* pCustomSampleOrders) @inline {
	internal::cmdSetCoarseSampleOrderNV(commandBuffer, sampleOrderType, customSampleOrderCount, pCustomSampleOrders);
}

fn void cmdSetColorBlendAdvancedEXT(CommandBuffer commandBuffer, uint firstAttachment, uint attachmentCount, ColorBlendAdvancedEXT* pColorBlendAdvanced) @inline {
	internal::cmdSetColorBlendAdvancedEXT(commandBuffer, firstAttachment, attachmentCount, pColorBlendAdvanced);
}

fn void cmdSetColorBlendEnableEXT(CommandBuffer commandBuffer, uint firstAttachment, uint attachmentCount, uint* pColorBlendEnables) @inline {
	internal::cmdSetColorBlendEnableEXT(commandBuffer, firstAttachment, attachmentCount, pColorBlendEnables);
}

fn void cmdSetColorBlendEquationEXT(CommandBuffer commandBuffer, uint firstAttachment, uint attachmentCount, ColorBlendEquationEXT* pColorBlendEquations) @inline {
	internal::cmdSetColorBlendEquationEXT(commandBuffer, firstAttachment, attachmentCount, pColorBlendEquations);
}

fn void cmdSetColorWriteMaskEXT(CommandBuffer commandBuffer, uint firstAttachment, uint attachmentCount, ColorComponentFlags* pColorWriteMasks) @inline {
	internal::cmdSetColorWriteMaskEXT(commandBuffer, firstAttachment, attachmentCount, pColorWriteMasks);
}

fn void cmdSetConservativeRasterizationModeEXT(CommandBuffer commandBuffer, ConservativeRasterizationModeEXT conservativeRasterizationMode) @inline {
	internal::cmdSetConservativeRasterizationModeEXT(commandBuffer, conservativeRasterizationMode);
}

fn void cmdSetCoverageModulationModeNV(CommandBuffer commandBuffer, CoverageModulationModeNV coverageModulationMode) @inline {
	internal::cmdSetCoverageModulationModeNV(commandBuffer, coverageModulationMode);
}

fn void cmdSetCoverageModulationTableEnableNV(CommandBuffer commandBuffer, uint coverageModulationTableEnable) @inline {
	internal::cmdSetCoverageModulationTableEnableNV(commandBuffer, coverageModulationTableEnable);
}

fn void cmdSetCoverageModulationTableNV(CommandBuffer commandBuffer, uint coverageModulationTableCount, float* pCoverageModulationTable) @inline {
	internal::cmdSetCoverageModulationTableNV(commandBuffer, coverageModulationTableCount, pCoverageModulationTable);
}

fn void cmdSetCoverageReductionModeNV(CommandBuffer commandBuffer, CoverageReductionModeNV coverageReductionMode) @inline {
	internal::cmdSetCoverageReductionModeNV(commandBuffer, coverageReductionMode);
}

fn void cmdSetCoverageToColorEnableNV(CommandBuffer commandBuffer, uint coverageToColorEnable) @inline {
	internal::cmdSetCoverageToColorEnableNV(commandBuffer, coverageToColorEnable);
}

fn void cmdSetCoverageToColorLocationNV(CommandBuffer commandBuffer, uint coverageToColorLocation) @inline {
	internal::cmdSetCoverageToColorLocationNV(commandBuffer, coverageToColorLocation);
}

fn void cmdSetCullMode(CommandBuffer commandBuffer, CullModeFlags cullMode) @inline {
	internal::cmdSetCullMode(commandBuffer, cullMode);
}

fn void cmdSetCullModeEXT(CommandBuffer commandBuffer, CullModeFlags cullMode) @inline {
	internal::cmdSetCullModeEXT(commandBuffer, cullMode);
}

fn void cmdSetDepthBias(CommandBuffer commandBuffer, float depthBiasConstantFactor, float depthBiasClamp, float depthBiasSlopeFactor) @inline {
	internal::cmdSetDepthBias(commandBuffer, depthBiasConstantFactor, depthBiasClamp, depthBiasSlopeFactor);
}

fn void cmdSetDepthBias2EXT(CommandBuffer commandBuffer, DepthBiasInfoEXT* pDepthBiasInfo) @inline {
	internal::cmdSetDepthBias2EXT(commandBuffer, pDepthBiasInfo);
}

fn void cmdSetDepthBiasEnable(CommandBuffer commandBuffer, uint depthBiasEnable) @inline {
	internal::cmdSetDepthBiasEnable(commandBuffer, depthBiasEnable);
}

fn void cmdSetDepthBiasEnableEXT(CommandBuffer commandBuffer, uint depthBiasEnable) @inline {
	internal::cmdSetDepthBiasEnableEXT(commandBuffer, depthBiasEnable);
}

fn void cmdSetDepthBounds(CommandBuffer commandBuffer, float minDepthBounds, float maxDepthBounds) @inline {
	internal::cmdSetDepthBounds(commandBuffer, minDepthBounds, maxDepthBounds);
}

fn void cmdSetDepthBoundsTestEnable(CommandBuffer commandBuffer, uint depthBoundsTestEnable) @inline {
	internal::cmdSetDepthBoundsTestEnable(commandBuffer, depthBoundsTestEnable);
}

fn void cmdSetDepthBoundsTestEnableEXT(CommandBuffer commandBuffer, uint depthBoundsTestEnable) @inline {
	internal::cmdSetDepthBoundsTestEnableEXT(commandBuffer, depthBoundsTestEnable);
}

fn void cmdSetDepthClampEnableEXT(CommandBuffer commandBuffer, uint depthClampEnable) @inline {
	internal::cmdSetDepthClampEnableEXT(commandBuffer, depthClampEnable);
}

fn void cmdSetDepthClampRangeEXT(CommandBuffer commandBuffer, DepthClampModeEXT depthClampMode, DepthClampRangeEXT* pDepthClampRange) @inline {
	internal::cmdSetDepthClampRangeEXT(commandBuffer, depthClampMode, pDepthClampRange);
}

fn void cmdSetDepthClipEnableEXT(CommandBuffer commandBuffer, uint depthClipEnable) @inline {
	internal::cmdSetDepthClipEnableEXT(commandBuffer, depthClipEnable);
}

fn void cmdSetDepthClipNegativeOneToOneEXT(CommandBuffer commandBuffer, uint negativeOneToOne) @inline {
	internal::cmdSetDepthClipNegativeOneToOneEXT(commandBuffer, negativeOneToOne);
}

fn void cmdSetDepthCompareOp(CommandBuffer commandBuffer, CompareOp depthCompareOp) @inline {
	internal::cmdSetDepthCompareOp(commandBuffer, depthCompareOp);
}

fn void cmdSetDepthCompareOpEXT(CommandBuffer commandBuffer, CompareOp depthCompareOp) @inline {
	internal::cmdSetDepthCompareOpEXT(commandBuffer, depthCompareOp);
}

fn void cmdSetDepthTestEnable(CommandBuffer commandBuffer, uint depthTestEnable) @inline {
	internal::cmdSetDepthTestEnable(commandBuffer, depthTestEnable);
}

fn void cmdSetDepthTestEnableEXT(CommandBuffer commandBuffer, uint depthTestEnable) @inline {
	internal::cmdSetDepthTestEnableEXT(commandBuffer, depthTestEnable);
}

fn void cmdSetDepthWriteEnable(CommandBuffer commandBuffer, uint depthWriteEnable) @inline {
	internal::cmdSetDepthWriteEnable(commandBuffer, depthWriteEnable);
}

fn void cmdSetDepthWriteEnableEXT(CommandBuffer commandBuffer, uint depthWriteEnable) @inline {
	internal::cmdSetDepthWriteEnableEXT(commandBuffer, depthWriteEnable);
}

fn void cmdSetDescriptorBufferOffsets2EXT(CommandBuffer commandBuffer, SetDescriptorBufferOffsetsInfoEXT* pSetDescriptorBufferOffsetsInfo) @inline {
	internal::cmdSetDescriptorBufferOffsets2EXT(commandBuffer, pSetDescriptorBufferOffsetsInfo);
}

fn void cmdSetDescriptorBufferOffsetsEXT(CommandBuffer commandBuffer, PipelineBindPoint pipelineBindPoint, PipelineLayout layout, uint firstSet, uint setCount, uint* pBufferIndices, DeviceSize* pOffsets) @inline {
	internal::cmdSetDescriptorBufferOffsetsEXT(commandBuffer, pipelineBindPoint, layout, firstSet, setCount, pBufferIndices, pOffsets);
}

fn void cmdSetDeviceMask(CommandBuffer commandBuffer, uint deviceMask) @inline {
	internal::cmdSetDeviceMask(commandBuffer, deviceMask);
}

fn void cmdSetDeviceMaskKHR(CommandBuffer commandBuffer, uint deviceMask) @inline {
	internal::cmdSetDeviceMaskKHR(commandBuffer, deviceMask);
}

fn void cmdSetDiscardRectangleEXT(CommandBuffer commandBuffer, uint firstDiscardRectangle, uint discardRectangleCount, Rect2D* pDiscardRectangles) @inline {
	internal::cmdSetDiscardRectangleEXT(commandBuffer, firstDiscardRectangle, discardRectangleCount, pDiscardRectangles);
}

fn void cmdSetDiscardRectangleEnableEXT(CommandBuffer commandBuffer, uint discardRectangleEnable) @inline {
	internal::cmdSetDiscardRectangleEnableEXT(commandBuffer, discardRectangleEnable);
}

fn void cmdSetDiscardRectangleModeEXT(CommandBuffer commandBuffer, DiscardRectangleModeEXT discardRectangleMode) @inline {
	internal::cmdSetDiscardRectangleModeEXT(commandBuffer, discardRectangleMode);
}

fn void cmdSetEvent(CommandBuffer commandBuffer, Event event, PipelineStageFlags stageMask) @inline {
	internal::cmdSetEvent(commandBuffer, event, stageMask);
}

fn void cmdSetEvent2(CommandBuffer commandBuffer, Event event, DependencyInfo* pDependencyInfo) @inline {
	internal::cmdSetEvent2(commandBuffer, event, pDependencyInfo);
}

fn void cmdSetEvent2KHR(CommandBuffer commandBuffer, Event event, DependencyInfo* pDependencyInfo) @inline {
	internal::cmdSetEvent2KHR(commandBuffer, event, pDependencyInfo);
}

fn void cmdSetExclusiveScissorEnableNV(CommandBuffer commandBuffer, uint firstExclusiveScissor, uint exclusiveScissorCount, uint* pExclusiveScissorEnables) @inline {
	internal::cmdSetExclusiveScissorEnableNV(commandBuffer, firstExclusiveScissor, exclusiveScissorCount, pExclusiveScissorEnables);
}

fn void cmdSetExclusiveScissorNV(CommandBuffer commandBuffer, uint firstExclusiveScissor, uint exclusiveScissorCount, Rect2D* pExclusiveScissors) @inline {
	internal::cmdSetExclusiveScissorNV(commandBuffer, firstExclusiveScissor, exclusiveScissorCount, pExclusiveScissors);
}

fn void cmdSetExtraPrimitiveOverestimationSizeEXT(CommandBuffer commandBuffer, float extraPrimitiveOverestimationSize) @inline {
	internal::cmdSetExtraPrimitiveOverestimationSizeEXT(commandBuffer, extraPrimitiveOverestimationSize);
}

fn void cmdSetFragmentShadingRateEnumNV(CommandBuffer commandBuffer, FragmentShadingRateNV shadingRate, FragmentShadingRateCombinerOpKHR*[2] combinerOps) @inline {
	internal::cmdSetFragmentShadingRateEnumNV(commandBuffer, shadingRate, combinerOps);
}

fn void cmdSetFragmentShadingRateKHR(CommandBuffer commandBuffer, Extent2D* pFragmentSize, FragmentShadingRateCombinerOpKHR*[2] combinerOps) @inline {
	internal::cmdSetFragmentShadingRateKHR(commandBuffer, pFragmentSize, combinerOps);
}

fn void cmdSetFrontFace(CommandBuffer commandBuffer, FrontFace frontFace) @inline {
	internal::cmdSetFrontFace(commandBuffer, frontFace);
}

fn void cmdSetFrontFaceEXT(CommandBuffer commandBuffer, FrontFace frontFace) @inline {
	internal::cmdSetFrontFaceEXT(commandBuffer, frontFace);
}

fn void cmdSetLineRasterizationModeEXT(CommandBuffer commandBuffer, LineRasterizationModeEXT lineRasterizationMode) @inline {
	internal::cmdSetLineRasterizationModeEXT(commandBuffer, lineRasterizationMode);
}

fn void cmdSetLineStipple(CommandBuffer commandBuffer, uint lineStippleFactor, ushort lineStipplePattern) @inline {
	internal::cmdSetLineStipple(commandBuffer, lineStippleFactor, lineStipplePattern);
}

fn void cmdSetLineStippleEXT(CommandBuffer commandBuffer, uint lineStippleFactor, ushort lineStipplePattern) @inline {
	internal::cmdSetLineStippleEXT(commandBuffer, lineStippleFactor, lineStipplePattern);
}

fn void cmdSetLineStippleEnableEXT(CommandBuffer commandBuffer, uint stippledLineEnable) @inline {
	internal::cmdSetLineStippleEnableEXT(commandBuffer, stippledLineEnable);
}

fn void cmdSetLineStippleKHR(CommandBuffer commandBuffer, uint lineStippleFactor, ushort lineStipplePattern) @inline {
	internal::cmdSetLineStippleKHR(commandBuffer, lineStippleFactor, lineStipplePattern);
}

fn void cmdSetLineWidth(CommandBuffer commandBuffer, float lineWidth) @inline {
	internal::cmdSetLineWidth(commandBuffer, lineWidth);
}

fn void cmdSetLogicOpEXT(CommandBuffer commandBuffer, LogicOp logicOp) @inline {
	internal::cmdSetLogicOpEXT(commandBuffer, logicOp);
}

fn void cmdSetLogicOpEnableEXT(CommandBuffer commandBuffer, uint logicOpEnable) @inline {
	internal::cmdSetLogicOpEnableEXT(commandBuffer, logicOpEnable);
}

fn void cmdSetPatchControlPointsEXT(CommandBuffer commandBuffer, uint patchControlPoints) @inline {
	internal::cmdSetPatchControlPointsEXT(commandBuffer, patchControlPoints);
}

fn void! cmdSetPerformanceMarkerINTEL(CommandBuffer commandBuffer, PerformanceMarkerInfoINTEL* pMarkerInfo) @inline {
	vk::check(internal::cmdSetPerformanceMarkerINTEL(commandBuffer, pMarkerInfo))!;
}

fn void! cmdSetPerformanceOverrideINTEL(CommandBuffer commandBuffer, PerformanceOverrideInfoINTEL* pOverrideInfo) @inline {
	vk::check(internal::cmdSetPerformanceOverrideINTEL(commandBuffer, pOverrideInfo))!;
}

fn void! cmdSetPerformanceStreamMarkerINTEL(CommandBuffer commandBuffer, PerformanceStreamMarkerInfoINTEL* pMarkerInfo) @inline {
	vk::check(internal::cmdSetPerformanceStreamMarkerINTEL(commandBuffer, pMarkerInfo))!;
}

fn void cmdSetPolygonModeEXT(CommandBuffer commandBuffer, PolygonMode polygonMode) @inline {
	internal::cmdSetPolygonModeEXT(commandBuffer, polygonMode);
}

fn void cmdSetPrimitiveRestartEnable(CommandBuffer commandBuffer, uint primitiveRestartEnable) @inline {
	internal::cmdSetPrimitiveRestartEnable(commandBuffer, primitiveRestartEnable);
}

fn void cmdSetPrimitiveRestartEnableEXT(CommandBuffer commandBuffer, uint primitiveRestartEnable) @inline {
	internal::cmdSetPrimitiveRestartEnableEXT(commandBuffer, primitiveRestartEnable);
}

fn void cmdSetPrimitiveTopology(CommandBuffer commandBuffer, PrimitiveTopology primitiveTopology) @inline {
	internal::cmdSetPrimitiveTopology(commandBuffer, primitiveTopology);
}

fn void cmdSetPrimitiveTopologyEXT(CommandBuffer commandBuffer, PrimitiveTopology primitiveTopology) @inline {
	internal::cmdSetPrimitiveTopologyEXT(commandBuffer, primitiveTopology);
}

fn void cmdSetProvokingVertexModeEXT(CommandBuffer commandBuffer, ProvokingVertexModeEXT provokingVertexMode) @inline {
	internal::cmdSetProvokingVertexModeEXT(commandBuffer, provokingVertexMode);
}

fn void cmdSetRasterizationSamplesEXT(CommandBuffer commandBuffer, SampleCountFlags rasterizationSamples) @inline {
	internal::cmdSetRasterizationSamplesEXT(commandBuffer, rasterizationSamples);
}

fn void cmdSetRasterizationStreamEXT(CommandBuffer commandBuffer, uint rasterizationStream) @inline {
	internal::cmdSetRasterizationStreamEXT(commandBuffer, rasterizationStream);
}

fn void cmdSetRasterizerDiscardEnable(CommandBuffer commandBuffer, uint rasterizerDiscardEnable) @inline {
	internal::cmdSetRasterizerDiscardEnable(commandBuffer, rasterizerDiscardEnable);
}

fn void cmdSetRasterizerDiscardEnableEXT(CommandBuffer commandBuffer, uint rasterizerDiscardEnable) @inline {
	internal::cmdSetRasterizerDiscardEnableEXT(commandBuffer, rasterizerDiscardEnable);
}

fn void cmdSetRayTracingPipelineStackSizeKHR(CommandBuffer commandBuffer, uint pipelineStackSize) @inline {
	internal::cmdSetRayTracingPipelineStackSizeKHR(commandBuffer, pipelineStackSize);
}

fn void cmdSetRenderingAttachmentLocations(CommandBuffer commandBuffer, RenderingAttachmentLocationInfo* pLocationInfo) @inline {
	internal::cmdSetRenderingAttachmentLocations(commandBuffer, pLocationInfo);
}

fn void cmdSetRenderingAttachmentLocationsKHR(CommandBuffer commandBuffer, RenderingAttachmentLocationInfo* pLocationInfo) @inline {
	internal::cmdSetRenderingAttachmentLocationsKHR(commandBuffer, pLocationInfo);
}

fn void cmdSetRenderingInputAttachmentIndices(CommandBuffer commandBuffer, RenderingInputAttachmentIndexInfo* pInputAttachmentIndexInfo) @inline {
	internal::cmdSetRenderingInputAttachmentIndices(commandBuffer, pInputAttachmentIndexInfo);
}

fn void cmdSetRenderingInputAttachmentIndicesKHR(CommandBuffer commandBuffer, RenderingInputAttachmentIndexInfo* pInputAttachmentIndexInfo) @inline {
	internal::cmdSetRenderingInputAttachmentIndicesKHR(commandBuffer, pInputAttachmentIndexInfo);
}

fn void cmdSetRepresentativeFragmentTestEnableNV(CommandBuffer commandBuffer, uint representativeFragmentTestEnable) @inline {
	internal::cmdSetRepresentativeFragmentTestEnableNV(commandBuffer, representativeFragmentTestEnable);
}

fn void cmdSetSampleLocationsEXT(CommandBuffer commandBuffer, SampleLocationsInfoEXT* pSampleLocationsInfo) @inline {
	internal::cmdSetSampleLocationsEXT(commandBuffer, pSampleLocationsInfo);
}

fn void cmdSetSampleLocationsEnableEXT(CommandBuffer commandBuffer, uint sampleLocationsEnable) @inline {
	internal::cmdSetSampleLocationsEnableEXT(commandBuffer, sampleLocationsEnable);
}

fn void cmdSetSampleMaskEXT(CommandBuffer commandBuffer, SampleCountFlags samples, SampleMask* pSampleMask) @inline {
	internal::cmdSetSampleMaskEXT(commandBuffer, samples, pSampleMask);
}

fn void cmdSetScissor(CommandBuffer commandBuffer, uint firstScissor, uint scissorCount, Rect2D* pScissors) @inline {
	internal::cmdSetScissor(commandBuffer, firstScissor, scissorCount, pScissors);
}

fn void cmdSetScissorWithCount(CommandBuffer commandBuffer, uint scissorCount, Rect2D* pScissors) @inline {
	internal::cmdSetScissorWithCount(commandBuffer, scissorCount, pScissors);
}

fn void cmdSetScissorWithCountEXT(CommandBuffer commandBuffer, uint scissorCount, Rect2D* pScissors) @inline {
	internal::cmdSetScissorWithCountEXT(commandBuffer, scissorCount, pScissors);
}

fn void cmdSetShadingRateImageEnableNV(CommandBuffer commandBuffer, uint shadingRateImageEnable) @inline {
	internal::cmdSetShadingRateImageEnableNV(commandBuffer, shadingRateImageEnable);
}

fn void cmdSetStencilCompareMask(CommandBuffer commandBuffer, StencilFaceFlags faceMask, uint compareMask) @inline {
	internal::cmdSetStencilCompareMask(commandBuffer, faceMask, compareMask);
}

fn void cmdSetStencilOp(CommandBuffer commandBuffer, StencilFaceFlags faceMask, StencilOp failOp, StencilOp passOp, StencilOp depthFailOp, CompareOp compareOp) @inline {
	internal::cmdSetStencilOp(commandBuffer, faceMask, failOp, passOp, depthFailOp, compareOp);
}

fn void cmdSetStencilOpEXT(CommandBuffer commandBuffer, StencilFaceFlags faceMask, StencilOp failOp, StencilOp passOp, StencilOp depthFailOp, CompareOp compareOp) @inline {
	internal::cmdSetStencilOpEXT(commandBuffer, faceMask, failOp, passOp, depthFailOp, compareOp);
}

fn void cmdSetStencilReference(CommandBuffer commandBuffer, StencilFaceFlags faceMask, uint reference) @inline {
	internal::cmdSetStencilReference(commandBuffer, faceMask, reference);
}

fn void cmdSetStencilTestEnable(CommandBuffer commandBuffer, uint stencilTestEnable) @inline {
	internal::cmdSetStencilTestEnable(commandBuffer, stencilTestEnable);
}

fn void cmdSetStencilTestEnableEXT(CommandBuffer commandBuffer, uint stencilTestEnable) @inline {
	internal::cmdSetStencilTestEnableEXT(commandBuffer, stencilTestEnable);
}

fn void cmdSetStencilWriteMask(CommandBuffer commandBuffer, StencilFaceFlags faceMask, uint writeMask) @inline {
	internal::cmdSetStencilWriteMask(commandBuffer, faceMask, writeMask);
}

fn void cmdSetTessellationDomainOriginEXT(CommandBuffer commandBuffer, TessellationDomainOrigin domainOrigin) @inline {
	internal::cmdSetTessellationDomainOriginEXT(commandBuffer, domainOrigin);
}

fn void cmdSetVertexInputEXT(CommandBuffer commandBuffer, uint vertexBindingDescriptionCount, VertexInputBindingDescription2EXT* pVertexBindingDescriptions, uint vertexAttributeDescriptionCount, VertexInputAttributeDescription2EXT* pVertexAttributeDescriptions) @inline {
	internal::cmdSetVertexInputEXT(commandBuffer, vertexBindingDescriptionCount, pVertexBindingDescriptions, vertexAttributeDescriptionCount, pVertexAttributeDescriptions);
}

fn void cmdSetViewport(CommandBuffer commandBuffer, uint firstViewport, uint viewportCount, Viewport* pViewports) @inline {
	internal::cmdSetViewport(commandBuffer, firstViewport, viewportCount, pViewports);
}

fn void cmdSetViewportShadingRatePaletteNV(CommandBuffer commandBuffer, uint firstViewport, uint viewportCount, ShadingRatePaletteNV* pShadingRatePalettes) @inline {
	internal::cmdSetViewportShadingRatePaletteNV(commandBuffer, firstViewport, viewportCount, pShadingRatePalettes);
}

fn void cmdSetViewportSwizzleNV(CommandBuffer commandBuffer, uint firstViewport, uint viewportCount, ViewportSwizzleNV* pViewportSwizzles) @inline {
	internal::cmdSetViewportSwizzleNV(commandBuffer, firstViewport, viewportCount, pViewportSwizzles);
}

fn void cmdSetViewportWScalingEnableNV(CommandBuffer commandBuffer, uint viewportWScalingEnable) @inline {
	internal::cmdSetViewportWScalingEnableNV(commandBuffer, viewportWScalingEnable);
}

fn void cmdSetViewportWScalingNV(CommandBuffer commandBuffer, uint firstViewport, uint viewportCount, ViewportWScalingNV* pViewportWScalings) @inline {
	internal::cmdSetViewportWScalingNV(commandBuffer, firstViewport, viewportCount, pViewportWScalings);
}

fn void cmdSetViewportWithCount(CommandBuffer commandBuffer, uint viewportCount, Viewport* pViewports) @inline {
	internal::cmdSetViewportWithCount(commandBuffer, viewportCount, pViewports);
}

fn void cmdSetViewportWithCountEXT(CommandBuffer commandBuffer, uint viewportCount, Viewport* pViewports) @inline {
	internal::cmdSetViewportWithCountEXT(commandBuffer, viewportCount, pViewports);
}

fn void cmdSubpassShadingHUAWEI(CommandBuffer commandBuffer) @inline {
	internal::cmdSubpassShadingHUAWEI(commandBuffer);
}

fn void cmdTraceRaysIndirect2KHR(CommandBuffer commandBuffer, DeviceAddress indirectDeviceAddress) @inline {
	internal::cmdTraceRaysIndirect2KHR(commandBuffer, indirectDeviceAddress);
}

fn void cmdTraceRaysIndirectKHR(CommandBuffer commandBuffer, StridedDeviceAddressRegionKHR* pRaygenShaderBindingTable, StridedDeviceAddressRegionKHR* pMissShaderBindingTable, StridedDeviceAddressRegionKHR* pHitShaderBindingTable, StridedDeviceAddressRegionKHR* pCallableShaderBindingTable, DeviceAddress indirectDeviceAddress) @inline {
	internal::cmdTraceRaysIndirectKHR(commandBuffer, pRaygenShaderBindingTable, pMissShaderBindingTable, pHitShaderBindingTable, pCallableShaderBindingTable, indirectDeviceAddress);
}

fn void cmdTraceRaysKHR(CommandBuffer commandBuffer, StridedDeviceAddressRegionKHR* pRaygenShaderBindingTable, StridedDeviceAddressRegionKHR* pMissShaderBindingTable, StridedDeviceAddressRegionKHR* pHitShaderBindingTable, StridedDeviceAddressRegionKHR* pCallableShaderBindingTable, uint width, uint height, uint depth) @inline {
	internal::cmdTraceRaysKHR(commandBuffer, pRaygenShaderBindingTable, pMissShaderBindingTable, pHitShaderBindingTable, pCallableShaderBindingTable, width, height, depth);
}

fn void cmdTraceRaysNV(CommandBuffer commandBuffer, Buffer raygenShaderBindingTableBuffer, DeviceSize raygenShaderBindingOffset, Buffer missShaderBindingTableBuffer, DeviceSize missShaderBindingOffset, DeviceSize missShaderBindingStride, Buffer hitShaderBindingTableBuffer, DeviceSize hitShaderBindingOffset, DeviceSize hitShaderBindingStride, Buffer callableShaderBindingTableBuffer, DeviceSize callableShaderBindingOffset, DeviceSize callableShaderBindingStride, uint width, uint height, uint depth) @inline {
	internal::cmdTraceRaysNV(commandBuffer, raygenShaderBindingTableBuffer, raygenShaderBindingOffset, missShaderBindingTableBuffer, missShaderBindingOffset, missShaderBindingStride, hitShaderBindingTableBuffer, hitShaderBindingOffset, hitShaderBindingStride, callableShaderBindingTableBuffer, callableShaderBindingOffset, callableShaderBindingStride, width, height, depth);
}

fn void cmdUpdateBuffer(CommandBuffer commandBuffer, Buffer dstBuffer, DeviceSize dstOffset, DeviceSize dataSize, void* pData) @inline {
	internal::cmdUpdateBuffer(commandBuffer, dstBuffer, dstOffset, dataSize, pData);
}

fn void cmdUpdatePipelineIndirectBufferNV(CommandBuffer commandBuffer, PipelineBindPoint pipelineBindPoint, Pipeline pipeline) @inline {
	internal::cmdUpdatePipelineIndirectBufferNV(commandBuffer, pipelineBindPoint, pipeline);
}

fn void cmdWaitEvents(CommandBuffer commandBuffer, uint eventCount, Event* pEvents, PipelineStageFlags srcStageMask, PipelineStageFlags dstStageMask, uint memoryBarrierCount, MemoryBarrier* pMemoryBarriers, uint bufferMemoryBarrierCount, BufferMemoryBarrier* pBufferMemoryBarriers, uint imageMemoryBarrierCount, ImageMemoryBarrier* pImageMemoryBarriers) @inline {
	internal::cmdWaitEvents(commandBuffer, eventCount, pEvents, srcStageMask, dstStageMask, memoryBarrierCount, pMemoryBarriers, bufferMemoryBarrierCount, pBufferMemoryBarriers, imageMemoryBarrierCount, pImageMemoryBarriers);
}

fn void cmdWaitEvents2(CommandBuffer commandBuffer, uint eventCount, Event* pEvents, DependencyInfo* pDependencyInfos) @inline {
	internal::cmdWaitEvents2(commandBuffer, eventCount, pEvents, pDependencyInfos);
}

fn void cmdWaitEvents2KHR(CommandBuffer commandBuffer, uint eventCount, Event* pEvents, DependencyInfo* pDependencyInfos) @inline {
	internal::cmdWaitEvents2KHR(commandBuffer, eventCount, pEvents, pDependencyInfos);
}

fn void cmdWriteAccelerationStructuresPropertiesKHR(CommandBuffer commandBuffer, uint accelerationStructureCount, AccelerationStructureKHR* pAccelerationStructures, QueryType queryType, QueryPool queryPool, uint firstQuery) @inline {
	internal::cmdWriteAccelerationStructuresPropertiesKHR(commandBuffer, accelerationStructureCount, pAccelerationStructures, queryType, queryPool, firstQuery);
}

fn void cmdWriteAccelerationStructuresPropertiesNV(CommandBuffer commandBuffer, uint accelerationStructureCount, AccelerationStructureNV* pAccelerationStructures, QueryType queryType, QueryPool queryPool, uint firstQuery) @inline {
	internal::cmdWriteAccelerationStructuresPropertiesNV(commandBuffer, accelerationStructureCount, pAccelerationStructures, queryType, queryPool, firstQuery);
}

fn void cmdWriteBufferMarker2AMD(CommandBuffer commandBuffer, PipelineStageFlags2 stage, Buffer dstBuffer, DeviceSize dstOffset, uint marker) @inline {
	internal::cmdWriteBufferMarker2AMD(commandBuffer, stage, dstBuffer, dstOffset, marker);
}

fn void cmdWriteBufferMarkerAMD(CommandBuffer commandBuffer, PipelineStageFlags pipelineStage, Buffer dstBuffer, DeviceSize dstOffset, uint marker) @inline {
	internal::cmdWriteBufferMarkerAMD(commandBuffer, pipelineStage, dstBuffer, dstOffset, marker);
}

fn void cmdWriteMicromapsPropertiesEXT(CommandBuffer commandBuffer, uint micromapCount, MicromapEXT* pMicromaps, QueryType queryType, QueryPool queryPool, uint firstQuery) @inline {
	internal::cmdWriteMicromapsPropertiesEXT(commandBuffer, micromapCount, pMicromaps, queryType, queryPool, firstQuery);
}

fn void cmdWriteTimestamp(CommandBuffer commandBuffer, PipelineStageFlags pipelineStage, QueryPool queryPool, uint query) @inline {
	internal::cmdWriteTimestamp(commandBuffer, pipelineStage, queryPool, query);
}

fn void cmdWriteTimestamp2(CommandBuffer commandBuffer, PipelineStageFlags2 stage, QueryPool queryPool, uint query) @inline {
	internal::cmdWriteTimestamp2(commandBuffer, stage, queryPool, query);
}

fn void cmdWriteTimestamp2KHR(CommandBuffer commandBuffer, PipelineStageFlags2 stage, QueryPool queryPool, uint query) @inline {
	internal::cmdWriteTimestamp2KHR(commandBuffer, stage, queryPool, query);
}

fn void! compileDeferredNV(Device device, Pipeline pipeline, uint shader) @inline {
	vk::check(internal::compileDeferredNV(device, pipeline, shader))!;
}

fn void! convertCooperativeVectorMatrixNV(Device device, ConvertCooperativeVectorMatrixInfoNV* pInfo) @inline {
	vk::check(internal::convertCooperativeVectorMatrixNV(device, pInfo))!;
}

fn void! copyAccelerationStructureKHR(Device device, DeferredOperationKHR deferredOperation, CopyAccelerationStructureInfoKHR* pInfo) @inline {
	vk::check(internal::copyAccelerationStructureKHR(device, deferredOperation, pInfo))!;
}

fn void! copyAccelerationStructureToMemoryKHR(Device device, DeferredOperationKHR deferredOperation, CopyAccelerationStructureToMemoryInfoKHR* pInfo) @inline {
	vk::check(internal::copyAccelerationStructureToMemoryKHR(device, deferredOperation, pInfo))!;
}

fn void! copyImageToImage(Device device, CopyImageToImageInfo* pCopyImageToImageInfo) @inline {
	vk::check(internal::copyImageToImage(device, pCopyImageToImageInfo))!;
}

fn void! copyImageToImageEXT(Device device, CopyImageToImageInfo* pCopyImageToImageInfo) @inline {
	vk::check(internal::copyImageToImageEXT(device, pCopyImageToImageInfo))!;
}

fn void! copyImageToMemory(Device device, CopyImageToMemoryInfo* pCopyImageToMemoryInfo) @inline {
	vk::check(internal::copyImageToMemory(device, pCopyImageToMemoryInfo))!;
}

fn void! copyImageToMemoryEXT(Device device, CopyImageToMemoryInfo* pCopyImageToMemoryInfo) @inline {
	vk::check(internal::copyImageToMemoryEXT(device, pCopyImageToMemoryInfo))!;
}

fn void! copyMemoryToAccelerationStructureKHR(Device device, DeferredOperationKHR deferredOperation, CopyMemoryToAccelerationStructureInfoKHR* pInfo) @inline {
	vk::check(internal::copyMemoryToAccelerationStructureKHR(device, deferredOperation, pInfo))!;
}

fn void! copyMemoryToImage(Device device, CopyMemoryToImageInfo* pCopyMemoryToImageInfo) @inline {
	vk::check(internal::copyMemoryToImage(device, pCopyMemoryToImageInfo))!;
}

fn void! copyMemoryToImageEXT(Device device, CopyMemoryToImageInfo* pCopyMemoryToImageInfo) @inline {
	vk::check(internal::copyMemoryToImageEXT(device, pCopyMemoryToImageInfo))!;
}

fn void! copyMemoryToMicromapEXT(Device device, DeferredOperationKHR deferredOperation, CopyMemoryToMicromapInfoEXT* pInfo) @inline {
	vk::check(internal::copyMemoryToMicromapEXT(device, deferredOperation, pInfo))!;
}

fn void! copyMicromapEXT(Device device, DeferredOperationKHR deferredOperation, CopyMicromapInfoEXT* pInfo) @inline {
	vk::check(internal::copyMicromapEXT(device, deferredOperation, pInfo))!;
}

fn void! copyMicromapToMemoryEXT(Device device, DeferredOperationKHR deferredOperation, CopyMicromapToMemoryInfoEXT* pInfo) @inline {
	vk::check(internal::copyMicromapToMemoryEXT(device, deferredOperation, pInfo))!;
}

fn void! createAccelerationStructureKHR(Device device, AccelerationStructureCreateInfoKHR* pCreateInfo, AllocationCallbacks* pAllocator, AccelerationStructureKHR* pAccelerationStructure) @inline {
	vk::check(internal::createAccelerationStructureKHR(device, pCreateInfo, pAllocator, pAccelerationStructure))!;
}

fn void! createAccelerationStructureNV(Device device, AccelerationStructureCreateInfoNV* pCreateInfo, AllocationCallbacks* pAllocator, AccelerationStructureNV* pAccelerationStructure) @inline {
	vk::check(internal::createAccelerationStructureNV(device, pCreateInfo, pAllocator, pAccelerationStructure))!;
}

fn void! createBuffer(Device device, BufferCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, Buffer* pBuffer) @inline {
	vk::check(internal::createBuffer(device, pCreateInfo, pAllocator, pBuffer))!;
}

fn void! createBufferView(Device device, BufferViewCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, BufferView* pView) @inline {
	vk::check(internal::createBufferView(device, pCreateInfo, pAllocator, pView))!;
}

fn void! createCommandPool(Device device, CommandPoolCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, CommandPool* pCommandPool) @inline {
	vk::check(internal::createCommandPool(device, pCreateInfo, pAllocator, pCommandPool))!;
}

fn void! createComputePipelines(Device device, PipelineCache pipelineCache, uint createInfoCount, ComputePipelineCreateInfo* pCreateInfos, AllocationCallbacks* pAllocator, Pipeline* pPipelines) @inline {
	vk::check(internal::createComputePipelines(device, pipelineCache, createInfoCount, pCreateInfos, pAllocator, pPipelines))!;
}

fn void! createCuFunctionNVX(Device device, CuFunctionCreateInfoNVX* pCreateInfo, AllocationCallbacks* pAllocator, CuFunctionNVX* pFunction) @inline {
	vk::check(internal::createCuFunctionNVX(device, pCreateInfo, pAllocator, pFunction))!;
}

fn void! createCuModuleNVX(Device device, CuModuleCreateInfoNVX* pCreateInfo, AllocationCallbacks* pAllocator, CuModuleNVX* pModule) @inline {
	vk::check(internal::createCuModuleNVX(device, pCreateInfo, pAllocator, pModule))!;
}

fn void! createCudaFunctionNV(Device device, CudaFunctionCreateInfoNV* pCreateInfo, AllocationCallbacks* pAllocator, CudaFunctionNV* pFunction) @inline {
	vk::check(internal::createCudaFunctionNV(device, pCreateInfo, pAllocator, pFunction))!;
}

fn void! createCudaModuleNV(Device device, CudaModuleCreateInfoNV* pCreateInfo, AllocationCallbacks* pAllocator, CudaModuleNV* pModule) @inline {
	vk::check(internal::createCudaModuleNV(device, pCreateInfo, pAllocator, pModule))!;
}

fn void! createDeferredOperationKHR(Device device, AllocationCallbacks* pAllocator, DeferredOperationKHR* pDeferredOperation) @inline {
	vk::check(internal::createDeferredOperationKHR(device, pAllocator, pDeferredOperation))!;
}

fn void! createDescriptorPool(Device device, DescriptorPoolCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, DescriptorPool* pDescriptorPool) @inline {
	vk::check(internal::createDescriptorPool(device, pCreateInfo, pAllocator, pDescriptorPool))!;
}

fn void! createDescriptorSetLayout(Device device, DescriptorSetLayoutCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, DescriptorSetLayout* pSetLayout) @inline {
	vk::check(internal::createDescriptorSetLayout(device, pCreateInfo, pAllocator, pSetLayout))!;
}

fn void! createDescriptorUpdateTemplate(Device device, DescriptorUpdateTemplateCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, DescriptorUpdateTemplate* pDescriptorUpdateTemplate) @inline {
	vk::check(internal::createDescriptorUpdateTemplate(device, pCreateInfo, pAllocator, pDescriptorUpdateTemplate))!;
}

fn void! createDescriptorUpdateTemplateKHR(Device device, DescriptorUpdateTemplateCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, DescriptorUpdateTemplate* pDescriptorUpdateTemplate) @inline {
	vk::check(internal::createDescriptorUpdateTemplateKHR(device, pCreateInfo, pAllocator, pDescriptorUpdateTemplate))!;
}

fn void! createEvent(Device device, EventCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, Event* pEvent) @inline {
	vk::check(internal::createEvent(device, pCreateInfo, pAllocator, pEvent))!;
}

fn void! createFence(Device device, FenceCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, Fence* pFence) @inline {
	vk::check(internal::createFence(device, pCreateInfo, pAllocator, pFence))!;
}

fn void! createFramebuffer(Device device, FramebufferCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, Framebuffer* pFramebuffer) @inline {
	vk::check(internal::createFramebuffer(device, pCreateInfo, pAllocator, pFramebuffer))!;
}

fn void! createGraphicsPipelines(Device device, PipelineCache pipelineCache, uint createInfoCount, GraphicsPipelineCreateInfo* pCreateInfos, AllocationCallbacks* pAllocator, Pipeline* pPipelines) @inline {
	vk::check(internal::createGraphicsPipelines(device, pipelineCache, createInfoCount, pCreateInfos, pAllocator, pPipelines))!;
}

fn void! createImage(Device device, ImageCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, Image* pImage) @inline {
	vk::check(internal::createImage(device, pCreateInfo, pAllocator, pImage))!;
}

fn void! createImageView(Device device, ImageViewCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, ImageView* pView) @inline {
	vk::check(internal::createImageView(device, pCreateInfo, pAllocator, pView))!;
}

fn void! createIndirectCommandsLayoutEXT(Device device, IndirectCommandsLayoutCreateInfoEXT* pCreateInfo, AllocationCallbacks* pAllocator, IndirectCommandsLayoutEXT* pIndirectCommandsLayout) @inline {
	vk::check(internal::createIndirectCommandsLayoutEXT(device, pCreateInfo, pAllocator, pIndirectCommandsLayout))!;
}

fn void! createIndirectCommandsLayoutNV(Device device, IndirectCommandsLayoutCreateInfoNV* pCreateInfo, AllocationCallbacks* pAllocator, IndirectCommandsLayoutNV* pIndirectCommandsLayout) @inline {
	vk::check(internal::createIndirectCommandsLayoutNV(device, pCreateInfo, pAllocator, pIndirectCommandsLayout))!;
}

fn void! createIndirectExecutionSetEXT(Device device, IndirectExecutionSetCreateInfoEXT* pCreateInfo, AllocationCallbacks* pAllocator, IndirectExecutionSetEXT* pIndirectExecutionSet) @inline {
	vk::check(internal::createIndirectExecutionSetEXT(device, pCreateInfo, pAllocator, pIndirectExecutionSet))!;
}

fn void! createMicromapEXT(Device device, MicromapCreateInfoEXT* pCreateInfo, AllocationCallbacks* pAllocator, MicromapEXT* pMicromap) @inline {
	vk::check(internal::createMicromapEXT(device, pCreateInfo, pAllocator, pMicromap))!;
}

fn void! createOpticalFlowSessionNV(Device device, OpticalFlowSessionCreateInfoNV* pCreateInfo, AllocationCallbacks* pAllocator, OpticalFlowSessionNV* pSession) @inline {
	vk::check(internal::createOpticalFlowSessionNV(device, pCreateInfo, pAllocator, pSession))!;
}

fn void! createPipelineBinariesKHR(Device device, PipelineBinaryCreateInfoKHR* pCreateInfo, AllocationCallbacks* pAllocator, PipelineBinaryHandlesInfoKHR* pBinaries) @inline {
	vk::check(internal::createPipelineBinariesKHR(device, pCreateInfo, pAllocator, pBinaries))!;
}

fn void! createPipelineCache(Device device, PipelineCacheCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, PipelineCache* pPipelineCache) @inline {
	vk::check(internal::createPipelineCache(device, pCreateInfo, pAllocator, pPipelineCache))!;
}

fn void! createPipelineLayout(Device device, PipelineLayoutCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, PipelineLayout* pPipelineLayout) @inline {
	vk::check(internal::createPipelineLayout(device, pCreateInfo, pAllocator, pPipelineLayout))!;
}

fn void! createPrivateDataSlot(Device device, PrivateDataSlotCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, PrivateDataSlot* pPrivateDataSlot) @inline {
	vk::check(internal::createPrivateDataSlot(device, pCreateInfo, pAllocator, pPrivateDataSlot))!;
}

fn void! createPrivateDataSlotEXT(Device device, PrivateDataSlotCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, PrivateDataSlot* pPrivateDataSlot) @inline {
	vk::check(internal::createPrivateDataSlotEXT(device, pCreateInfo, pAllocator, pPrivateDataSlot))!;
}

fn void! createQueryPool(Device device, QueryPoolCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, QueryPool* pQueryPool) @inline {
	vk::check(internal::createQueryPool(device, pCreateInfo, pAllocator, pQueryPool))!;
}

fn void! createRayTracingPipelinesKHR(Device device, DeferredOperationKHR deferredOperation, PipelineCache pipelineCache, uint createInfoCount, RayTracingPipelineCreateInfoKHR* pCreateInfos, AllocationCallbacks* pAllocator, Pipeline* pPipelines) @inline {
	vk::check(internal::createRayTracingPipelinesKHR(device, deferredOperation, pipelineCache, createInfoCount, pCreateInfos, pAllocator, pPipelines))!;
}

fn void! createRayTracingPipelinesNV(Device device, PipelineCache pipelineCache, uint createInfoCount, RayTracingPipelineCreateInfoNV* pCreateInfos, AllocationCallbacks* pAllocator, Pipeline* pPipelines) @inline {
	vk::check(internal::createRayTracingPipelinesNV(device, pipelineCache, createInfoCount, pCreateInfos, pAllocator, pPipelines))!;
}

fn void! createRenderPass(Device device, RenderPassCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, RenderPass* pRenderPass) @inline {
	vk::check(internal::createRenderPass(device, pCreateInfo, pAllocator, pRenderPass))!;
}

fn void! createRenderPass2(Device device, RenderPassCreateInfo2* pCreateInfo, AllocationCallbacks* pAllocator, RenderPass* pRenderPass) @inline {
	vk::check(internal::createRenderPass2(device, pCreateInfo, pAllocator, pRenderPass))!;
}

fn void! createRenderPass2KHR(Device device, RenderPassCreateInfo2* pCreateInfo, AllocationCallbacks* pAllocator, RenderPass* pRenderPass) @inline {
	vk::check(internal::createRenderPass2KHR(device, pCreateInfo, pAllocator, pRenderPass))!;
}

fn void! createSampler(Device device, SamplerCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, Sampler* pSampler) @inline {
	vk::check(internal::createSampler(device, pCreateInfo, pAllocator, pSampler))!;
}

fn void! createSamplerYcbcrConversion(Device device, SamplerYcbcrConversionCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, SamplerYcbcrConversion* pYcbcrConversion) @inline {
	vk::check(internal::createSamplerYcbcrConversion(device, pCreateInfo, pAllocator, pYcbcrConversion))!;
}

fn void! createSamplerYcbcrConversionKHR(Device device, SamplerYcbcrConversionCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, SamplerYcbcrConversion* pYcbcrConversion) @inline {
	vk::check(internal::createSamplerYcbcrConversionKHR(device, pCreateInfo, pAllocator, pYcbcrConversion))!;
}

fn void! createSemaphore(Device device, SemaphoreCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, Semaphore* pSemaphore) @inline {
	vk::check(internal::createSemaphore(device, pCreateInfo, pAllocator, pSemaphore))!;
}

fn void! createShaderModule(Device device, ShaderModuleCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, ShaderModule* pShaderModule) @inline {
	vk::check(internal::createShaderModule(device, pCreateInfo, pAllocator, pShaderModule))!;
}

fn void! createShadersEXT(Device device, uint createInfoCount, ShaderCreateInfoEXT* pCreateInfos, AllocationCallbacks* pAllocator, ShaderEXT* pShaders) @inline {
	vk::check(internal::createShadersEXT(device, createInfoCount, pCreateInfos, pAllocator, pShaders))!;
}

fn void! createSharedSwapchainsKHR(Device device, uint swapchainCount, SwapchainCreateInfoKHR* pCreateInfos, AllocationCallbacks* pAllocator, SwapchainKHR* pSwapchains) @inline {
	vk::check(internal::createSharedSwapchainsKHR(device, swapchainCount, pCreateInfos, pAllocator, pSwapchains))!;
}

fn void! createSwapchainKHR(Device device, SwapchainCreateInfoKHR* pCreateInfo, AllocationCallbacks* pAllocator, SwapchainKHR* pSwapchain) @inline {
	vk::check(internal::createSwapchainKHR(device, pCreateInfo, pAllocator, pSwapchain))!;
}

fn void! createValidationCacheEXT(Device device, ValidationCacheCreateInfoEXT* pCreateInfo, AllocationCallbacks* pAllocator, ValidationCacheEXT* pValidationCache) @inline {
	vk::check(internal::createValidationCacheEXT(device, pCreateInfo, pAllocator, pValidationCache))!;
}

fn void! createVideoSessionKHR(Device device, VideoSessionCreateInfoKHR* pCreateInfo, AllocationCallbacks* pAllocator, VideoSessionKHR* pVideoSession) @inline {
	vk::check(internal::createVideoSessionKHR(device, pCreateInfo, pAllocator, pVideoSession))!;
}

fn void! createVideoSessionParametersKHR(Device device, VideoSessionParametersCreateInfoKHR* pCreateInfo, AllocationCallbacks* pAllocator, VideoSessionParametersKHR* pVideoSessionParameters) @inline {
	vk::check(internal::createVideoSessionParametersKHR(device, pCreateInfo, pAllocator, pVideoSessionParameters))!;
}

fn void! debugMarkerSetObjectNameEXT(Device device, DebugMarkerObjectNameInfoEXT* pNameInfo) @inline {
	vk::check(internal::debugMarkerSetObjectNameEXT(device, pNameInfo))!;
}

fn void! debugMarkerSetObjectTagEXT(Device device, DebugMarkerObjectTagInfoEXT* pTagInfo) @inline {
	vk::check(internal::debugMarkerSetObjectTagEXT(device, pTagInfo))!;
}

fn void! deferredOperationJoinKHR(Device device, DeferredOperationKHR operation) @inline {
	vk::check(internal::deferredOperationJoinKHR(device, operation))!;
}

fn void destroyAccelerationStructureKHR(Device device, AccelerationStructureKHR accelerationStructure, AllocationCallbacks* pAllocator) @inline {
	internal::destroyAccelerationStructureKHR(device, accelerationStructure, pAllocator);
}

fn void destroyAccelerationStructureNV(Device device, AccelerationStructureNV accelerationStructure, AllocationCallbacks* pAllocator) @inline {
	internal::destroyAccelerationStructureNV(device, accelerationStructure, pAllocator);
}

fn void destroyBuffer(Device device, Buffer buffer, AllocationCallbacks* pAllocator) @inline {
	internal::destroyBuffer(device, buffer, pAllocator);
}

fn void destroyBufferView(Device device, BufferView bufferView, AllocationCallbacks* pAllocator) @inline {
	internal::destroyBufferView(device, bufferView, pAllocator);
}

fn void destroyCommandPool(Device device, CommandPool commandPool, AllocationCallbacks* pAllocator) @inline {
	internal::destroyCommandPool(device, commandPool, pAllocator);
}

fn void destroyCuFunctionNVX(Device device, CuFunctionNVX function, AllocationCallbacks* pAllocator) @inline {
	internal::destroyCuFunctionNVX(device, function, pAllocator);
}

fn void destroyCuModuleNVX(Device device, CuModuleNVX module_, AllocationCallbacks* pAllocator) @inline {
	internal::destroyCuModuleNVX(device, module_, pAllocator);
}

fn void destroyCudaFunctionNV(Device device, CudaFunctionNV function, AllocationCallbacks* pAllocator) @inline {
	internal::destroyCudaFunctionNV(device, function, pAllocator);
}

fn void destroyCudaModuleNV(Device device, CudaModuleNV module_, AllocationCallbacks* pAllocator) @inline {
	internal::destroyCudaModuleNV(device, module_, pAllocator);
}

fn void destroyDeferredOperationKHR(Device device, DeferredOperationKHR operation, AllocationCallbacks* pAllocator) @inline {
	internal::destroyDeferredOperationKHR(device, operation, pAllocator);
}

fn void destroyDescriptorPool(Device device, DescriptorPool descriptorPool, AllocationCallbacks* pAllocator) @inline {
	internal::destroyDescriptorPool(device, descriptorPool, pAllocator);
}

fn void destroyDescriptorSetLayout(Device device, DescriptorSetLayout descriptorSetLayout, AllocationCallbacks* pAllocator) @inline {
	internal::destroyDescriptorSetLayout(device, descriptorSetLayout, pAllocator);
}

fn void destroyDescriptorUpdateTemplate(Device device, DescriptorUpdateTemplate descriptorUpdateTemplate, AllocationCallbacks* pAllocator) @inline {
	internal::destroyDescriptorUpdateTemplate(device, descriptorUpdateTemplate, pAllocator);
}

fn void destroyDescriptorUpdateTemplateKHR(Device device, DescriptorUpdateTemplate descriptorUpdateTemplate, AllocationCallbacks* pAllocator) @inline {
	internal::destroyDescriptorUpdateTemplateKHR(device, descriptorUpdateTemplate, pAllocator);
}

fn void destroyDevice(Device device, AllocationCallbacks* pAllocator) @inline {
	internal::destroyDevice(device, pAllocator);
}

fn void destroyEvent(Device device, Event event, AllocationCallbacks* pAllocator) @inline {
	internal::destroyEvent(device, event, pAllocator);
}

fn void destroyFence(Device device, Fence fence, AllocationCallbacks* pAllocator) @inline {
	internal::destroyFence(device, fence, pAllocator);
}

fn void destroyFramebuffer(Device device, Framebuffer framebuffer, AllocationCallbacks* pAllocator) @inline {
	internal::destroyFramebuffer(device, framebuffer, pAllocator);
}

fn void destroyImage(Device device, Image image, AllocationCallbacks* pAllocator) @inline {
	internal::destroyImage(device, image, pAllocator);
}

fn void destroyImageView(Device device, ImageView imageView, AllocationCallbacks* pAllocator) @inline {
	internal::destroyImageView(device, imageView, pAllocator);
}

fn void destroyIndirectCommandsLayoutEXT(Device device, IndirectCommandsLayoutEXT indirectCommandsLayout, AllocationCallbacks* pAllocator) @inline {
	internal::destroyIndirectCommandsLayoutEXT(device, indirectCommandsLayout, pAllocator);
}

fn void destroyIndirectCommandsLayoutNV(Device device, IndirectCommandsLayoutNV indirectCommandsLayout, AllocationCallbacks* pAllocator) @inline {
	internal::destroyIndirectCommandsLayoutNV(device, indirectCommandsLayout, pAllocator);
}

fn void destroyIndirectExecutionSetEXT(Device device, IndirectExecutionSetEXT indirectExecutionSet, AllocationCallbacks* pAllocator) @inline {
	internal::destroyIndirectExecutionSetEXT(device, indirectExecutionSet, pAllocator);
}

fn void destroyMicromapEXT(Device device, MicromapEXT micromap, AllocationCallbacks* pAllocator) @inline {
	internal::destroyMicromapEXT(device, micromap, pAllocator);
}

fn void destroyOpticalFlowSessionNV(Device device, OpticalFlowSessionNV session, AllocationCallbacks* pAllocator) @inline {
	internal::destroyOpticalFlowSessionNV(device, session, pAllocator);
}

fn void destroyPipeline(Device device, Pipeline pipeline, AllocationCallbacks* pAllocator) @inline {
	internal::destroyPipeline(device, pipeline, pAllocator);
}

fn void destroyPipelineBinaryKHR(Device device, PipelineBinaryKHR pipelineBinary, AllocationCallbacks* pAllocator) @inline {
	internal::destroyPipelineBinaryKHR(device, pipelineBinary, pAllocator);
}

fn void destroyPipelineCache(Device device, PipelineCache pipelineCache, AllocationCallbacks* pAllocator) @inline {
	internal::destroyPipelineCache(device, pipelineCache, pAllocator);
}

fn void destroyPipelineLayout(Device device, PipelineLayout pipelineLayout, AllocationCallbacks* pAllocator) @inline {
	internal::destroyPipelineLayout(device, pipelineLayout, pAllocator);
}

fn void destroyPrivateDataSlot(Device device, PrivateDataSlot privateDataSlot, AllocationCallbacks* pAllocator) @inline {
	internal::destroyPrivateDataSlot(device, privateDataSlot, pAllocator);
}

fn void destroyPrivateDataSlotEXT(Device device, PrivateDataSlot privateDataSlot, AllocationCallbacks* pAllocator) @inline {
	internal::destroyPrivateDataSlotEXT(device, privateDataSlot, pAllocator);
}

fn void destroyQueryPool(Device device, QueryPool queryPool, AllocationCallbacks* pAllocator) @inline {
	internal::destroyQueryPool(device, queryPool, pAllocator);
}

fn void destroyRenderPass(Device device, RenderPass renderPass, AllocationCallbacks* pAllocator) @inline {
	internal::destroyRenderPass(device, renderPass, pAllocator);
}

fn void destroySampler(Device device, Sampler sampler, AllocationCallbacks* pAllocator) @inline {
	internal::destroySampler(device, sampler, pAllocator);
}

fn void destroySamplerYcbcrConversion(Device device, SamplerYcbcrConversion ycbcrConversion, AllocationCallbacks* pAllocator) @inline {
	internal::destroySamplerYcbcrConversion(device, ycbcrConversion, pAllocator);
}

fn void destroySamplerYcbcrConversionKHR(Device device, SamplerYcbcrConversion ycbcrConversion, AllocationCallbacks* pAllocator) @inline {
	internal::destroySamplerYcbcrConversionKHR(device, ycbcrConversion, pAllocator);
}

fn void destroySemaphore(Device device, Semaphore semaphore, AllocationCallbacks* pAllocator) @inline {
	internal::destroySemaphore(device, semaphore, pAllocator);
}

fn void destroyShaderEXT(Device device, ShaderEXT shader, AllocationCallbacks* pAllocator) @inline {
	internal::destroyShaderEXT(device, shader, pAllocator);
}

fn void destroyShaderModule(Device device, ShaderModule shaderModule, AllocationCallbacks* pAllocator) @inline {
	internal::destroyShaderModule(device, shaderModule, pAllocator);
}

fn void destroySwapchainKHR(Device device, SwapchainKHR swapchain, AllocationCallbacks* pAllocator) @inline {
	internal::destroySwapchainKHR(device, swapchain, pAllocator);
}

fn void destroyValidationCacheEXT(Device device, ValidationCacheEXT validationCache, AllocationCallbacks* pAllocator) @inline {
	internal::destroyValidationCacheEXT(device, validationCache, pAllocator);
}

fn void destroyVideoSessionKHR(Device device, VideoSessionKHR videoSession, AllocationCallbacks* pAllocator) @inline {
	internal::destroyVideoSessionKHR(device, videoSession, pAllocator);
}

fn void destroyVideoSessionParametersKHR(Device device, VideoSessionParametersKHR videoSessionParameters, AllocationCallbacks* pAllocator) @inline {
	internal::destroyVideoSessionParametersKHR(device, videoSessionParameters, pAllocator);
}

fn void! deviceWaitIdle(Device device) @inline {
	vk::check(internal::deviceWaitIdle(device))!;
}

fn void! displayPowerControlEXT(Device device, DisplayKHR display, DisplayPowerInfoEXT* pDisplayPowerInfo) @inline {
	vk::check(internal::displayPowerControlEXT(device, display, pDisplayPowerInfo))!;
}

fn void! endCommandBuffer(CommandBuffer commandBuffer) @inline {
	vk::check(internal::endCommandBuffer(commandBuffer))!;
}

fn void exportMetalObjectsEXT(Device device, ExportMetalObjectsInfoEXT* pMetalObjectsInfo) @inline {
	internal::exportMetalObjectsEXT(device, pMetalObjectsInfo);
}

fn void! flushMappedMemoryRanges(Device device, uint memoryRangeCount, MappedMemoryRange* pMemoryRanges) @inline {
	vk::check(internal::flushMappedMemoryRanges(device, memoryRangeCount, pMemoryRanges))!;
}

fn void freeCommandBuffers(Device device, CommandPool commandPool, uint commandBufferCount, CommandBuffer* pCommandBuffers) @inline {
	internal::freeCommandBuffers(device, commandPool, commandBufferCount, pCommandBuffers);
}

fn void! freeDescriptorSets(Device device, DescriptorPool descriptorPool, uint descriptorSetCount, DescriptorSet* pDescriptorSets) @inline {
	vk::check(internal::freeDescriptorSets(device, descriptorPool, descriptorSetCount, pDescriptorSets))!;
}

fn void freeMemory(Device device, DeviceMemory memory, AllocationCallbacks* pAllocator) @inline {
	internal::freeMemory(device, memory, pAllocator);
}

fn void getAccelerationStructureBuildSizesKHR(Device device, AccelerationStructureBuildTypeKHR buildType, AccelerationStructureBuildGeometryInfoKHR* pBuildInfo, uint* pMaxPrimitiveCounts, AccelerationStructureBuildSizesInfoKHR* pSizeInfo) @inline {
	internal::getAccelerationStructureBuildSizesKHR(device, buildType, pBuildInfo, pMaxPrimitiveCounts, pSizeInfo);
}

fn DeviceAddress getAccelerationStructureDeviceAddressKHR(Device device, AccelerationStructureDeviceAddressInfoKHR* pInfo) @inline {
	return internal::getAccelerationStructureDeviceAddressKHR(device, pInfo);
}

fn void! getAccelerationStructureHandleNV(Device device, AccelerationStructureNV accelerationStructure, usz dataSize, void* pData) @inline {
	vk::check(internal::getAccelerationStructureHandleNV(device, accelerationStructure, dataSize, pData))!;
}

fn void getAccelerationStructureMemoryRequirementsNV(Device device, AccelerationStructureMemoryRequirementsInfoNV* pInfo, MemoryRequirements2KHR* pMemoryRequirements) @inline {
	internal::getAccelerationStructureMemoryRequirementsNV(device, pInfo, pMemoryRequirements);
}

fn void! getAccelerationStructureOpaqueCaptureDescriptorDataEXT(Device device, AccelerationStructureCaptureDescriptorDataInfoEXT* pInfo, void* pData) @inline {
	vk::check(internal::getAccelerationStructureOpaqueCaptureDescriptorDataEXT(device, pInfo, pData))!;
}

fn DeviceAddress getBufferDeviceAddress(Device device, BufferDeviceAddressInfo* pInfo) @inline {
	return internal::getBufferDeviceAddress(device, pInfo);
}

fn DeviceAddress getBufferDeviceAddressEXT(Device device, BufferDeviceAddressInfo* pInfo) @inline {
	return internal::getBufferDeviceAddressEXT(device, pInfo);
}

fn DeviceAddress getBufferDeviceAddressKHR(Device device, BufferDeviceAddressInfo* pInfo) @inline {
	return internal::getBufferDeviceAddressKHR(device, pInfo);
}

fn void getBufferMemoryRequirements(Device device, Buffer buffer, MemoryRequirements* pMemoryRequirements) @inline {
	internal::getBufferMemoryRequirements(device, buffer, pMemoryRequirements);
}

fn void getBufferMemoryRequirements2(Device device, BufferMemoryRequirementsInfo2* pInfo, MemoryRequirements2* pMemoryRequirements) @inline {
	internal::getBufferMemoryRequirements2(device, pInfo, pMemoryRequirements);
}

fn void getBufferMemoryRequirements2KHR(Device device, BufferMemoryRequirementsInfo2* pInfo, MemoryRequirements2* pMemoryRequirements) @inline {
	internal::getBufferMemoryRequirements2KHR(device, pInfo, pMemoryRequirements);
}

fn ulong getBufferOpaqueCaptureAddress(Device device, BufferDeviceAddressInfo* pInfo) @inline {
	return internal::getBufferOpaqueCaptureAddress(device, pInfo);
}

fn ulong getBufferOpaqueCaptureAddressKHR(Device device, BufferDeviceAddressInfo* pInfo) @inline {
	return internal::getBufferOpaqueCaptureAddressKHR(device, pInfo);
}

fn void! getBufferOpaqueCaptureDescriptorDataEXT(Device device, BufferCaptureDescriptorDataInfoEXT* pInfo, void* pData) @inline {
	vk::check(internal::getBufferOpaqueCaptureDescriptorDataEXT(device, pInfo, pData))!;
}

fn void! getCalibratedTimestampsEXT(Device device, uint timestampCount, CalibratedTimestampInfoKHR* pTimestampInfos, ulong* pTimestamps, ulong* pMaxDeviation) @inline {
	vk::check(internal::getCalibratedTimestampsEXT(device, timestampCount, pTimestampInfos, pTimestamps, pMaxDeviation))!;
}

fn void! getCalibratedTimestampsKHR(Device device, uint timestampCount, CalibratedTimestampInfoKHR* pTimestampInfos, ulong* pTimestamps, ulong* pMaxDeviation) @inline {
	vk::check(internal::getCalibratedTimestampsKHR(device, timestampCount, pTimestampInfos, pTimestamps, pMaxDeviation))!;
}

fn void getClusterAccelerationStructureBuildSizesNV(Device device, ClusterAccelerationStructureInputInfoNV* pInfo, AccelerationStructureBuildSizesInfoKHR* pSizeInfo) @inline {
	internal::getClusterAccelerationStructureBuildSizesNV(device, pInfo, pSizeInfo);
}

fn void! getCudaModuleCacheNV(Device device, CudaModuleNV module_, usz* pCacheSize, void* pCacheData) @inline {
	vk::check(internal::getCudaModuleCacheNV(device, module_, pCacheSize, pCacheData))!;
}

fn uint getDeferredOperationMaxConcurrencyKHR(Device device, DeferredOperationKHR operation) @inline {
	return internal::getDeferredOperationMaxConcurrencyKHR(device, operation);
}

fn void! getDeferredOperationResultKHR(Device device, DeferredOperationKHR operation) @inline {
	vk::check(internal::getDeferredOperationResultKHR(device, operation))!;
}

fn void getDescriptorEXT(Device device, DescriptorGetInfoEXT* pDescriptorInfo, usz dataSize, void* pDescriptor) @inline {
	internal::getDescriptorEXT(device, pDescriptorInfo, dataSize, pDescriptor);
}

fn void getDescriptorSetHostMappingVALVE(Device device, DescriptorSet descriptorSet, void** ppData) @inline {
	internal::getDescriptorSetHostMappingVALVE(device, descriptorSet, ppData);
}

fn void getDescriptorSetLayoutBindingOffsetEXT(Device device, DescriptorSetLayout layout, uint binding, DeviceSize* pOffset) @inline {
	internal::getDescriptorSetLayoutBindingOffsetEXT(device, layout, binding, pOffset);
}

fn void getDescriptorSetLayoutHostMappingInfoVALVE(Device device, DescriptorSetBindingReferenceVALVE* pBindingReference, DescriptorSetLayoutHostMappingInfoVALVE* pHostMapping) @inline {
	internal::getDescriptorSetLayoutHostMappingInfoVALVE(device, pBindingReference, pHostMapping);
}

fn void getDescriptorSetLayoutSizeEXT(Device device, DescriptorSetLayout layout, DeviceSize* pLayoutSizeInBytes) @inline {
	internal::getDescriptorSetLayoutSizeEXT(device, layout, pLayoutSizeInBytes);
}

fn void getDescriptorSetLayoutSupport(Device device, DescriptorSetLayoutCreateInfo* pCreateInfo, DescriptorSetLayoutSupport* pSupport) @inline {
	internal::getDescriptorSetLayoutSupport(device, pCreateInfo, pSupport);
}

fn void getDescriptorSetLayoutSupportKHR(Device device, DescriptorSetLayoutCreateInfo* pCreateInfo, DescriptorSetLayoutSupport* pSupport) @inline {
	internal::getDescriptorSetLayoutSupportKHR(device, pCreateInfo, pSupport);
}

fn void getDeviceAccelerationStructureCompatibilityKHR(Device device, AccelerationStructureVersionInfoKHR* pVersionInfo, AccelerationStructureCompatibilityKHR* pCompatibility) @inline {
	internal::getDeviceAccelerationStructureCompatibilityKHR(device, pVersionInfo, pCompatibility);
}

fn void getDeviceBufferMemoryRequirements(Device device, DeviceBufferMemoryRequirements* pInfo, MemoryRequirements2* pMemoryRequirements) @inline {
	internal::getDeviceBufferMemoryRequirements(device, pInfo, pMemoryRequirements);
}

fn void getDeviceBufferMemoryRequirementsKHR(Device device, DeviceBufferMemoryRequirements* pInfo, MemoryRequirements2* pMemoryRequirements) @inline {
	internal::getDeviceBufferMemoryRequirementsKHR(device, pInfo, pMemoryRequirements);
}

fn void! getDeviceFaultInfoEXT(Device device, DeviceFaultCountsEXT* pFaultCounts, DeviceFaultInfoEXT* pFaultInfo) @inline {
	vk::check(internal::getDeviceFaultInfoEXT(device, pFaultCounts, pFaultInfo))!;
}

fn void getDeviceGroupPeerMemoryFeatures(Device device, uint heapIndex, uint localDeviceIndex, uint remoteDeviceIndex, PeerMemoryFeatureFlags* pPeerMemoryFeatures) @inline {
	internal::getDeviceGroupPeerMemoryFeatures(device, heapIndex, localDeviceIndex, remoteDeviceIndex, pPeerMemoryFeatures);
}

fn void getDeviceGroupPeerMemoryFeaturesKHR(Device device, uint heapIndex, uint localDeviceIndex, uint remoteDeviceIndex, PeerMemoryFeatureFlags* pPeerMemoryFeatures) @inline {
	internal::getDeviceGroupPeerMemoryFeaturesKHR(device, heapIndex, localDeviceIndex, remoteDeviceIndex, pPeerMemoryFeatures);
}

fn void! getDeviceGroupPresentCapabilitiesKHR(Device device, DeviceGroupPresentCapabilitiesKHR* pDeviceGroupPresentCapabilities) @inline {
	vk::check(internal::getDeviceGroupPresentCapabilitiesKHR(device, pDeviceGroupPresentCapabilities))!;
}

fn void! getDeviceGroupSurfacePresentModes2EXT(Device device, PhysicalDeviceSurfaceInfo2KHR* pSurfaceInfo, DeviceGroupPresentModeFlagsKHR* pModes) @inline {
	vk::check(internal::getDeviceGroupSurfacePresentModes2EXT(device, pSurfaceInfo, pModes))!;
}

fn void! getDeviceGroupSurfacePresentModesKHR(Device device, SurfaceKHR surface, DeviceGroupPresentModeFlagsKHR* pModes) @inline {
	vk::check(internal::getDeviceGroupSurfacePresentModesKHR(device, surface, pModes))!;
}

fn void getDeviceImageMemoryRequirements(Device device, DeviceImageMemoryRequirements* pInfo, MemoryRequirements2* pMemoryRequirements) @inline {
	internal::getDeviceImageMemoryRequirements(device, pInfo, pMemoryRequirements);
}

fn void getDeviceImageMemoryRequirementsKHR(Device device, DeviceImageMemoryRequirements* pInfo, MemoryRequirements2* pMemoryRequirements) @inline {
	internal::getDeviceImageMemoryRequirementsKHR(device, pInfo, pMemoryRequirements);
}

fn SparseImageMemoryRequirements2[] getDeviceImageSparseMemoryRequirements(Device device, DeviceImageMemoryRequirements* pInfo) {
	uint n;
	internal::getDeviceImageSparseMemoryRequirements(device, pInfo, &n, null);
	SparseImageMemoryRequirements2* ret = (SparseImageMemoryRequirements2*) malloc(n * SparseImageMemoryRequirements2.sizeof);
	internal::getDeviceImageSparseMemoryRequirements(device, pInfo, &n, ret);
	return ret[:n];
}

fn SparseImageMemoryRequirements2[] getDeviceImageSparseMemoryRequirementsKHR(Device device, DeviceImageMemoryRequirements* pInfo) {
	uint n;
	internal::getDeviceImageSparseMemoryRequirementsKHR(device, pInfo, &n, null);
	SparseImageMemoryRequirements2* ret = (SparseImageMemoryRequirements2*) malloc(n * SparseImageMemoryRequirements2.sizeof);
	internal::getDeviceImageSparseMemoryRequirementsKHR(device, pInfo, &n, ret);
	return ret[:n];
}

fn void getDeviceImageSubresourceLayout(Device device, DeviceImageSubresourceInfo* pInfo, SubresourceLayout2* pLayout) @inline {
	internal::getDeviceImageSubresourceLayout(device, pInfo, pLayout);
}

fn void getDeviceImageSubresourceLayoutKHR(Device device, DeviceImageSubresourceInfo* pInfo, SubresourceLayout2* pLayout) @inline {
	internal::getDeviceImageSubresourceLayoutKHR(device, pInfo, pLayout);
}

fn void getDeviceMemoryCommitment(Device device, DeviceMemory memory, DeviceSize* pCommittedMemoryInBytes) @inline {
	internal::getDeviceMemoryCommitment(device, memory, pCommittedMemoryInBytes);
}

fn ulong getDeviceMemoryOpaqueCaptureAddress(Device device, DeviceMemoryOpaqueCaptureAddressInfo* pInfo) @inline {
	return internal::getDeviceMemoryOpaqueCaptureAddress(device, pInfo);
}

fn ulong getDeviceMemoryOpaqueCaptureAddressKHR(Device device, DeviceMemoryOpaqueCaptureAddressInfo* pInfo) @inline {
	return internal::getDeviceMemoryOpaqueCaptureAddressKHR(device, pInfo);
}

fn void getDeviceMicromapCompatibilityEXT(Device device, MicromapVersionInfoEXT* pVersionInfo, AccelerationStructureCompatibilityKHR* pCompatibility) @inline {
	internal::getDeviceMicromapCompatibilityEXT(device, pVersionInfo, pCompatibility);
}

fn ProcVoidFunction getDeviceProcAddr(Device device, ZString pName) @inline {
	return internal::getDeviceProcAddr(device, pName);
}

fn void getDeviceQueue(Device device, uint queueFamilyIndex, uint queueIndex, Queue* pQueue) @inline {
	internal::getDeviceQueue(device, queueFamilyIndex, queueIndex, pQueue);
}

fn void getDeviceQueue2(Device device, DeviceQueueInfo2* pQueueInfo, Queue* pQueue) @inline {
	internal::getDeviceQueue2(device, pQueueInfo, pQueue);
}

fn void! getDeviceSubpassShadingMaxWorkgroupSizeHUAWEI(Device device, RenderPass renderpass, Extent2D* pMaxWorkgroupSize) @inline {
	vk::check(internal::getDeviceSubpassShadingMaxWorkgroupSizeHUAWEI(device, renderpass, pMaxWorkgroupSize))!;
}

fn void! getDynamicRenderingTilePropertiesQCOM(Device device, RenderingInfo* pRenderingInfo, TilePropertiesQCOM* pProperties) @inline {
	vk::check(internal::getDynamicRenderingTilePropertiesQCOM(device, pRenderingInfo, pProperties))!;
}

fn void! getEncodedVideoSessionParametersKHR(Device device, VideoEncodeSessionParametersGetInfoKHR* pVideoSessionParametersInfo, VideoEncodeSessionParametersFeedbackInfoKHR* pFeedbackInfo, usz* pDataSize, void* pData) @inline {
	vk::check(internal::getEncodedVideoSessionParametersKHR(device, pVideoSessionParametersInfo, pFeedbackInfo, pDataSize, pData))!;
}

fn void! getEventStatus(Device device, Event event) @inline {
	vk::check(internal::getEventStatus(device, event))!;
}

fn void! getFenceFdKHR(Device device, FenceGetFdInfoKHR* pGetFdInfo, CInt* pFd) @inline {
	vk::check(internal::getFenceFdKHR(device, pGetFdInfo, pFd))!;
}

fn void! getFenceStatus(Device device, Fence fence) @inline {
	vk::check(internal::getFenceStatus(device, fence))!;
}

fn void! getFenceWin32HandleKHR(Device device, FenceGetWin32HandleInfoKHR* pGetWin32HandleInfo, Win32_HANDLE* pHandle) @inline {
	vk::check(internal::getFenceWin32HandleKHR(device, pGetWin32HandleInfo, pHandle))!;
}

fn TilePropertiesQCOM[]! getFramebufferTilePropertiesQCOM(Device device, Framebuffer framebuffer) {
	uint n;
	vk::check(internal::getFramebufferTilePropertiesQCOM(device, framebuffer, &n, null))!;
	TilePropertiesQCOM* ret = (TilePropertiesQCOM*) malloc(n * TilePropertiesQCOM.sizeof);
	vk::check(internal::getFramebufferTilePropertiesQCOM(device, framebuffer, &n, ret))!;
	return ret[:n];
}

fn void getGeneratedCommandsMemoryRequirementsEXT(Device device, GeneratedCommandsMemoryRequirementsInfoEXT* pInfo, MemoryRequirements2* pMemoryRequirements) @inline {
	internal::getGeneratedCommandsMemoryRequirementsEXT(device, pInfo, pMemoryRequirements);
}

fn void getGeneratedCommandsMemoryRequirementsNV(Device device, GeneratedCommandsMemoryRequirementsInfoNV* pInfo, MemoryRequirements2* pMemoryRequirements) @inline {
	internal::getGeneratedCommandsMemoryRequirementsNV(device, pInfo, pMemoryRequirements);
}

fn void! getImageDrmFormatModifierPropertiesEXT(Device device, Image image, ImageDrmFormatModifierPropertiesEXT* pProperties) @inline {
	vk::check(internal::getImageDrmFormatModifierPropertiesEXT(device, image, pProperties))!;
}

fn void getImageMemoryRequirements(Device device, Image image, MemoryRequirements* pMemoryRequirements) @inline {
	internal::getImageMemoryRequirements(device, image, pMemoryRequirements);
}

fn void getImageMemoryRequirements2(Device device, ImageMemoryRequirementsInfo2* pInfo, MemoryRequirements2* pMemoryRequirements) @inline {
	internal::getImageMemoryRequirements2(device, pInfo, pMemoryRequirements);
}

fn void getImageMemoryRequirements2KHR(Device device, ImageMemoryRequirementsInfo2* pInfo, MemoryRequirements2* pMemoryRequirements) @inline {
	internal::getImageMemoryRequirements2KHR(device, pInfo, pMemoryRequirements);
}

fn void! getImageOpaqueCaptureDescriptorDataEXT(Device device, ImageCaptureDescriptorDataInfoEXT* pInfo, void* pData) @inline {
	vk::check(internal::getImageOpaqueCaptureDescriptorDataEXT(device, pInfo, pData))!;
}

fn SparseImageMemoryRequirements[] getImageSparseMemoryRequirements(Device device, Image image) {
	uint n;
	internal::getImageSparseMemoryRequirements(device, image, &n, null);
	SparseImageMemoryRequirements* ret = (SparseImageMemoryRequirements*) malloc(n * SparseImageMemoryRequirements.sizeof);
	internal::getImageSparseMemoryRequirements(device, image, &n, ret);
	return ret[:n];
}

fn SparseImageMemoryRequirements2[] getImageSparseMemoryRequirements2(Device device, ImageSparseMemoryRequirementsInfo2* pInfo) {
	uint n;
	internal::getImageSparseMemoryRequirements2(device, pInfo, &n, null);
	SparseImageMemoryRequirements2* ret = (SparseImageMemoryRequirements2*) malloc(n * SparseImageMemoryRequirements2.sizeof);
	internal::getImageSparseMemoryRequirements2(device, pInfo, &n, ret);
	return ret[:n];
}

fn SparseImageMemoryRequirements2[] getImageSparseMemoryRequirements2KHR(Device device, ImageSparseMemoryRequirementsInfo2* pInfo) {
	uint n;
	internal::getImageSparseMemoryRequirements2KHR(device, pInfo, &n, null);
	SparseImageMemoryRequirements2* ret = (SparseImageMemoryRequirements2*) malloc(n * SparseImageMemoryRequirements2.sizeof);
	internal::getImageSparseMemoryRequirements2KHR(device, pInfo, &n, ret);
	return ret[:n];
}

fn void getImageSubresourceLayout(Device device, Image image, ImageSubresource* pSubresource, SubresourceLayout* pLayout) @inline {
	internal::getImageSubresourceLayout(device, image, pSubresource, pLayout);
}

fn void getImageSubresourceLayout2(Device device, Image image, ImageSubresource2* pSubresource, SubresourceLayout2* pLayout) @inline {
	internal::getImageSubresourceLayout2(device, image, pSubresource, pLayout);
}

fn void getImageSubresourceLayout2EXT(Device device, Image image, ImageSubresource2* pSubresource, SubresourceLayout2* pLayout) @inline {
	internal::getImageSubresourceLayout2EXT(device, image, pSubresource, pLayout);
}

fn void getImageSubresourceLayout2KHR(Device device, Image image, ImageSubresource2* pSubresource, SubresourceLayout2* pLayout) @inline {
	internal::getImageSubresourceLayout2KHR(device, image, pSubresource, pLayout);
}

fn void! getImageViewAddressNVX(Device device, ImageView imageView, ImageViewAddressPropertiesNVX* pProperties) @inline {
	vk::check(internal::getImageViewAddressNVX(device, imageView, pProperties))!;
}

fn ulong getImageViewHandle64NVX(Device device, ImageViewHandleInfoNVX* pInfo) @inline {
	return internal::getImageViewHandle64NVX(device, pInfo);
}

fn uint getImageViewHandleNVX(Device device, ImageViewHandleInfoNVX* pInfo) @inline {
	return internal::getImageViewHandleNVX(device, pInfo);
}

fn void! getImageViewOpaqueCaptureDescriptorDataEXT(Device device, ImageViewCaptureDescriptorDataInfoEXT* pInfo, void* pData) @inline {
	vk::check(internal::getImageViewOpaqueCaptureDescriptorDataEXT(device, pInfo, pData))!;
}

fn void getLatencyTimingsNV(Device device, SwapchainKHR swapchain, GetLatencyMarkerInfoNV* pLatencyMarkerInfo) @inline {
	internal::getLatencyTimingsNV(device, swapchain, pLatencyMarkerInfo);
}

fn void! getMemoryFdKHR(Device device, MemoryGetFdInfoKHR* pGetFdInfo, CInt* pFd) @inline {
	vk::check(internal::getMemoryFdKHR(device, pGetFdInfo, pFd))!;
}

fn void! getMemoryFdPropertiesKHR(Device device, ExternalMemoryHandleTypeFlags handleType, CInt fd, MemoryFdPropertiesKHR* pMemoryFdProperties) @inline {
	vk::check(internal::getMemoryFdPropertiesKHR(device, handleType, fd, pMemoryFdProperties))!;
}

fn void! getMemoryHostPointerPropertiesEXT(Device device, ExternalMemoryHandleTypeFlags handleType, void* pHostPointer, MemoryHostPointerPropertiesEXT* pMemoryHostPointerProperties) @inline {
	vk::check(internal::getMemoryHostPointerPropertiesEXT(device, handleType, pHostPointer, pMemoryHostPointerProperties))!;
}

fn void! getMemoryMetalHandleEXT(Device device, MemoryGetMetalHandleInfoEXT* pGetMetalHandleInfo, void** pHandle) @inline {
	vk::check(internal::getMemoryMetalHandleEXT(device, pGetMetalHandleInfo, pHandle))!;
}

fn void! getMemoryMetalHandlePropertiesEXT(Device device, ExternalMemoryHandleTypeFlags handleType, void* pHandle, MemoryMetalHandlePropertiesEXT* pMemoryMetalHandleProperties) @inline {
	vk::check(internal::getMemoryMetalHandlePropertiesEXT(device, handleType, pHandle, pMemoryMetalHandleProperties))!;
}

fn void! getMemoryRemoteAddressNV(Device device, MemoryGetRemoteAddressInfoNV* pMemoryGetRemoteAddressInfo, RemoteAddressNV* pAddress) @inline {
	vk::check(internal::getMemoryRemoteAddressNV(device, pMemoryGetRemoteAddressInfo, pAddress))!;
}

fn void! getMemoryWin32HandleKHR(Device device, MemoryGetWin32HandleInfoKHR* pGetWin32HandleInfo, Win32_HANDLE* pHandle) @inline {
	vk::check(internal::getMemoryWin32HandleKHR(device, pGetWin32HandleInfo, pHandle))!;
}

fn void! getMemoryWin32HandleNV(Device device, DeviceMemory memory, ExternalMemoryHandleTypeFlagsNV handleType, Win32_HANDLE* pHandle) @inline {
	vk::check(internal::getMemoryWin32HandleNV(device, memory, handleType, pHandle))!;
}

fn void! getMemoryWin32HandlePropertiesKHR(Device device, ExternalMemoryHandleTypeFlags handleType, Win32_HANDLE handle, MemoryWin32HandlePropertiesKHR* pMemoryWin32HandleProperties) @inline {
	vk::check(internal::getMemoryWin32HandlePropertiesKHR(device, handleType, handle, pMemoryWin32HandleProperties))!;
}

fn void getMicromapBuildSizesEXT(Device device, AccelerationStructureBuildTypeKHR buildType, MicromapBuildInfoEXT* pBuildInfo, MicromapBuildSizesInfoEXT* pSizeInfo) @inline {
	internal::getMicromapBuildSizesEXT(device, buildType, pBuildInfo, pSizeInfo);
}

fn void getPartitionedAccelerationStructuresBuildSizesNV(Device device, PartitionedAccelerationStructureInstancesInputNV* pInfo, AccelerationStructureBuildSizesInfoKHR* pSizeInfo) @inline {
	internal::getPartitionedAccelerationStructuresBuildSizesNV(device, pInfo, pSizeInfo);
}

fn PastPresentationTimingGOOGLE[]! getPastPresentationTimingGOOGLE(Device device, SwapchainKHR swapchain) {
	uint n;
	vk::check(internal::getPastPresentationTimingGOOGLE(device, swapchain, &n, null))!;
	PastPresentationTimingGOOGLE* ret = (PastPresentationTimingGOOGLE*) malloc(n * PastPresentationTimingGOOGLE.sizeof);
	vk::check(internal::getPastPresentationTimingGOOGLE(device, swapchain, &n, ret))!;
	return ret[:n];
}

fn void! getPerformanceParameterINTEL(Device device, PerformanceParameterTypeINTEL parameter, PerformanceValueINTEL* pValue) @inline {
	vk::check(internal::getPerformanceParameterINTEL(device, parameter, pValue))!;
}

fn void! getPipelineBinaryDataKHR(Device device, PipelineBinaryDataInfoKHR* pInfo, PipelineBinaryKeyKHR* pPipelineBinaryKey, usz* pPipelineBinaryDataSize, void* pPipelineBinaryData) @inline {
	vk::check(internal::getPipelineBinaryDataKHR(device, pInfo, pPipelineBinaryKey, pPipelineBinaryDataSize, pPipelineBinaryData))!;
}

fn void! getPipelineCacheData(Device device, PipelineCache pipelineCache, usz* pDataSize, void* pData) @inline {
	vk::check(internal::getPipelineCacheData(device, pipelineCache, pDataSize, pData))!;
}

fn PipelineExecutableInternalRepresentationKHR[]! getPipelineExecutableInternalRepresentationsKHR(Device device, PipelineExecutableInfoKHR* pExecutableInfo) {
	uint n;
	vk::check(internal::getPipelineExecutableInternalRepresentationsKHR(device, pExecutableInfo, &n, null))!;
	PipelineExecutableInternalRepresentationKHR* ret = (PipelineExecutableInternalRepresentationKHR*) malloc(n * PipelineExecutableInternalRepresentationKHR.sizeof);
	vk::check(internal::getPipelineExecutableInternalRepresentationsKHR(device, pExecutableInfo, &n, ret))!;
	return ret[:n];
}

fn PipelineExecutablePropertiesKHR[]! getPipelineExecutablePropertiesKHR(Device device, PipelineInfoKHR* pPipelineInfo) {
	uint n;
	vk::check(internal::getPipelineExecutablePropertiesKHR(device, pPipelineInfo, &n, null))!;
	PipelineExecutablePropertiesKHR* ret = (PipelineExecutablePropertiesKHR*) malloc(n * PipelineExecutablePropertiesKHR.sizeof);
	vk::check(internal::getPipelineExecutablePropertiesKHR(device, pPipelineInfo, &n, ret))!;
	return ret[:n];
}

fn PipelineExecutableStatisticKHR[]! getPipelineExecutableStatisticsKHR(Device device, PipelineExecutableInfoKHR* pExecutableInfo) {
	uint n;
	vk::check(internal::getPipelineExecutableStatisticsKHR(device, pExecutableInfo, &n, null))!;
	PipelineExecutableStatisticKHR* ret = (PipelineExecutableStatisticKHR*) malloc(n * PipelineExecutableStatisticKHR.sizeof);
	vk::check(internal::getPipelineExecutableStatisticsKHR(device, pExecutableInfo, &n, ret))!;
	return ret[:n];
}

fn DeviceAddress getPipelineIndirectDeviceAddressNV(Device device, PipelineIndirectDeviceAddressInfoNV* pInfo) @inline {
	return internal::getPipelineIndirectDeviceAddressNV(device, pInfo);
}

fn void getPipelineIndirectMemoryRequirementsNV(Device device, ComputePipelineCreateInfo* pCreateInfo, MemoryRequirements2* pMemoryRequirements) @inline {
	internal::getPipelineIndirectMemoryRequirementsNV(device, pCreateInfo, pMemoryRequirements);
}

fn void! getPipelineKeyKHR(Device device, PipelineCreateInfoKHR* pPipelineCreateInfo, PipelineBinaryKeyKHR* pPipelineKey) @inline {
	vk::check(internal::getPipelineKeyKHR(device, pPipelineCreateInfo, pPipelineKey))!;
}

fn void! getPipelinePropertiesEXT(Device device, PipelineInfoEXT* pPipelineInfo, BaseOutStructure* pPipelineProperties) @inline {
	vk::check(internal::getPipelinePropertiesEXT(device, pPipelineInfo, pPipelineProperties))!;
}

fn void getPrivateData(Device device, ObjectType objectType, ulong objectHandle, PrivateDataSlot privateDataSlot, ulong* pData) @inline {
	internal::getPrivateData(device, objectType, objectHandle, privateDataSlot, pData);
}

fn void getPrivateDataEXT(Device device, ObjectType objectType, ulong objectHandle, PrivateDataSlot privateDataSlot, ulong* pData) @inline {
	internal::getPrivateDataEXT(device, objectType, objectHandle, privateDataSlot, pData);
}

fn void! getQueryPoolResults(Device device, QueryPool queryPool, uint firstQuery, uint queryCount, usz dataSize, void* pData, DeviceSize stride, QueryResultFlags flags) @inline {
	vk::check(internal::getQueryPoolResults(device, queryPool, firstQuery, queryCount, dataSize, pData, stride, flags))!;
}

fn void getQueueCheckpointData2NV(Queue queue, uint* pCheckpointDataCount, CheckpointData2NV* pCheckpointData) @inline {
	internal::getQueueCheckpointData2NV(queue, pCheckpointDataCount, pCheckpointData);
}

fn void getQueueCheckpointDataNV(Queue queue, uint* pCheckpointDataCount, CheckpointDataNV* pCheckpointData) @inline {
	internal::getQueueCheckpointDataNV(queue, pCheckpointDataCount, pCheckpointData);
}

fn void! getRayTracingCaptureReplayShaderGroupHandlesKHR(Device device, Pipeline pipeline, uint firstGroup, uint groupCount, usz dataSize, void* pData) @inline {
	vk::check(internal::getRayTracingCaptureReplayShaderGroupHandlesKHR(device, pipeline, firstGroup, groupCount, dataSize, pData))!;
}

fn void! getRayTracingShaderGroupHandlesKHR(Device device, Pipeline pipeline, uint firstGroup, uint groupCount, usz dataSize, void* pData) @inline {
	vk::check(internal::getRayTracingShaderGroupHandlesKHR(device, pipeline, firstGroup, groupCount, dataSize, pData))!;
}

fn void! getRayTracingShaderGroupHandlesNV(Device device, Pipeline pipeline, uint firstGroup, uint groupCount, usz dataSize, void* pData) @inline {
	vk::check(internal::getRayTracingShaderGroupHandlesNV(device, pipeline, firstGroup, groupCount, dataSize, pData))!;
}

fn DeviceSize getRayTracingShaderGroupStackSizeKHR(Device device, Pipeline pipeline, uint group, ShaderGroupShaderKHR groupShader) @inline {
	return internal::getRayTracingShaderGroupStackSizeKHR(device, pipeline, group, groupShader);
}

fn void! getRefreshCycleDurationGOOGLE(Device device, SwapchainKHR swapchain, RefreshCycleDurationGOOGLE* pDisplayTimingProperties) @inline {
	vk::check(internal::getRefreshCycleDurationGOOGLE(device, swapchain, pDisplayTimingProperties))!;
}

fn void getRenderAreaGranularity(Device device, RenderPass renderPass, Extent2D* pGranularity) @inline {
	internal::getRenderAreaGranularity(device, renderPass, pGranularity);
}

fn void getRenderingAreaGranularity(Device device, RenderingAreaInfo* pRenderingAreaInfo, Extent2D* pGranularity) @inline {
	internal::getRenderingAreaGranularity(device, pRenderingAreaInfo, pGranularity);
}

fn void getRenderingAreaGranularityKHR(Device device, RenderingAreaInfo* pRenderingAreaInfo, Extent2D* pGranularity) @inline {
	internal::getRenderingAreaGranularityKHR(device, pRenderingAreaInfo, pGranularity);
}

fn void! getSamplerOpaqueCaptureDescriptorDataEXT(Device device, SamplerCaptureDescriptorDataInfoEXT* pInfo, void* pData) @inline {
	vk::check(internal::getSamplerOpaqueCaptureDescriptorDataEXT(device, pInfo, pData))!;
}

fn void! getSemaphoreCounterValue(Device device, Semaphore semaphore, ulong* pValue) @inline {
	vk::check(internal::getSemaphoreCounterValue(device, semaphore, pValue))!;
}

fn void! getSemaphoreCounterValueKHR(Device device, Semaphore semaphore, ulong* pValue) @inline {
	vk::check(internal::getSemaphoreCounterValueKHR(device, semaphore, pValue))!;
}

fn void! getSemaphoreFdKHR(Device device, SemaphoreGetFdInfoKHR* pGetFdInfo, CInt* pFd) @inline {
	vk::check(internal::getSemaphoreFdKHR(device, pGetFdInfo, pFd))!;
}

fn void! getSemaphoreWin32HandleKHR(Device device, SemaphoreGetWin32HandleInfoKHR* pGetWin32HandleInfo, Win32_HANDLE* pHandle) @inline {
	vk::check(internal::getSemaphoreWin32HandleKHR(device, pGetWin32HandleInfo, pHandle))!;
}

fn void! getShaderBinaryDataEXT(Device device, ShaderEXT shader, usz* pDataSize, void* pData) @inline {
	vk::check(internal::getShaderBinaryDataEXT(device, shader, pDataSize, pData))!;
}

fn void! getShaderInfoAMD(Device device, Pipeline pipeline, ShaderStageFlags shaderStage, ShaderInfoTypeAMD infoType, usz* pInfoSize, void* pInfo) @inline {
	vk::check(internal::getShaderInfoAMD(device, pipeline, shaderStage, infoType, pInfoSize, pInfo))!;
}

fn void getShaderModuleCreateInfoIdentifierEXT(Device device, ShaderModuleCreateInfo* pCreateInfo, ShaderModuleIdentifierEXT* pIdentifier) @inline {
	internal::getShaderModuleCreateInfoIdentifierEXT(device, pCreateInfo, pIdentifier);
}

fn void getShaderModuleIdentifierEXT(Device device, ShaderModule shaderModule, ShaderModuleIdentifierEXT* pIdentifier) @inline {
	internal::getShaderModuleIdentifierEXT(device, shaderModule, pIdentifier);
}

fn void! getSwapchainCounterEXT(Device device, SwapchainKHR swapchain, SurfaceCounterFlagsEXT counter, ulong* pCounterValue) @inline {
	vk::check(internal::getSwapchainCounterEXT(device, swapchain, counter, pCounterValue))!;
}

fn Image[]! getSwapchainImagesKHR(Device device, SwapchainKHR swapchain) {
	uint n;
	vk::check(internal::getSwapchainImagesKHR(device, swapchain, &n, null))!;
	Image* ret = (Image*) malloc(n * Image.sizeof);
	vk::check(internal::getSwapchainImagesKHR(device, swapchain, &n, ret))!;
	return ret[:n];
}

fn void! getSwapchainStatusKHR(Device device, SwapchainKHR swapchain) @inline {
	vk::check(internal::getSwapchainStatusKHR(device, swapchain))!;
}

fn void! getValidationCacheDataEXT(Device device, ValidationCacheEXT validationCache, usz* pDataSize, void* pData) @inline {
	vk::check(internal::getValidationCacheDataEXT(device, validationCache, pDataSize, pData))!;
}

fn VideoSessionMemoryRequirementsKHR[]! getVideoSessionMemoryRequirementsKHR(Device device, VideoSessionKHR videoSession) {
	uint n;
	vk::check(internal::getVideoSessionMemoryRequirementsKHR(device, videoSession, &n, null))!;
	VideoSessionMemoryRequirementsKHR* ret = (VideoSessionMemoryRequirementsKHR*) malloc(n * VideoSessionMemoryRequirementsKHR.sizeof);
	vk::check(internal::getVideoSessionMemoryRequirementsKHR(device, videoSession, &n, ret))!;
	return ret[:n];
}

fn void! importFenceFdKHR(Device device, ImportFenceFdInfoKHR* pImportFenceFdInfo) @inline {
	vk::check(internal::importFenceFdKHR(device, pImportFenceFdInfo))!;
}

fn void! importFenceWin32HandleKHR(Device device, ImportFenceWin32HandleInfoKHR* pImportFenceWin32HandleInfo) @inline {
	vk::check(internal::importFenceWin32HandleKHR(device, pImportFenceWin32HandleInfo))!;
}

fn void! importSemaphoreFdKHR(Device device, ImportSemaphoreFdInfoKHR* pImportSemaphoreFdInfo) @inline {
	vk::check(internal::importSemaphoreFdKHR(device, pImportSemaphoreFdInfo))!;
}

fn void! importSemaphoreWin32HandleKHR(Device device, ImportSemaphoreWin32HandleInfoKHR* pImportSemaphoreWin32HandleInfo) @inline {
	vk::check(internal::importSemaphoreWin32HandleKHR(device, pImportSemaphoreWin32HandleInfo))!;
}

fn void! initializePerformanceApiINTEL(Device device, InitializePerformanceApiInfoINTEL* pInitializeInfo) @inline {
	vk::check(internal::initializePerformanceApiINTEL(device, pInitializeInfo))!;
}

fn void! invalidateMappedMemoryRanges(Device device, uint memoryRangeCount, MappedMemoryRange* pMemoryRanges) @inline {
	vk::check(internal::invalidateMappedMemoryRanges(device, memoryRangeCount, pMemoryRanges))!;
}

fn void! latencySleepNV(Device device, SwapchainKHR swapchain, LatencySleepInfoNV* pSleepInfo) @inline {
	vk::check(internal::latencySleepNV(device, swapchain, pSleepInfo))!;
}

fn void! mapMemory(Device device, DeviceMemory memory, DeviceSize offset, DeviceSize size, MemoryMapFlags flags, void** ppData) @inline {
	vk::check(internal::mapMemory(device, memory, offset, size, flags, ppData))!;
}

fn void! mapMemory2(Device device, MemoryMapInfo* pMemoryMapInfo, void** ppData) @inline {
	vk::check(internal::mapMemory2(device, pMemoryMapInfo, ppData))!;
}

fn void! mapMemory2KHR(Device device, MemoryMapInfo* pMemoryMapInfo, void** ppData) @inline {
	vk::check(internal::mapMemory2KHR(device, pMemoryMapInfo, ppData))!;
}

fn void! mergePipelineCaches(Device device, PipelineCache dstCache, uint srcCacheCount, PipelineCache* pSrcCaches) @inline {
	vk::check(internal::mergePipelineCaches(device, dstCache, srcCacheCount, pSrcCaches))!;
}

fn void! mergeValidationCachesEXT(Device device, ValidationCacheEXT dstCache, uint srcCacheCount, ValidationCacheEXT* pSrcCaches) @inline {
	vk::check(internal::mergeValidationCachesEXT(device, dstCache, srcCacheCount, pSrcCaches))!;
}

fn void queueBeginDebugUtilsLabelEXT(Queue queue, DebugUtilsLabelEXT* pLabelInfo) @inline {
	internal::queueBeginDebugUtilsLabelEXT(queue, pLabelInfo);
}

fn void! queueBindSparse(Queue queue, uint bindInfoCount, BindSparseInfo* pBindInfo, Fence fence) @inline {
	vk::check(internal::queueBindSparse(queue, bindInfoCount, pBindInfo, fence))!;
}

fn void queueEndDebugUtilsLabelEXT(Queue queue) @inline {
	internal::queueEndDebugUtilsLabelEXT(queue);
}

fn void queueInsertDebugUtilsLabelEXT(Queue queue, DebugUtilsLabelEXT* pLabelInfo) @inline {
	internal::queueInsertDebugUtilsLabelEXT(queue, pLabelInfo);
}

fn void queueNotifyOutOfBandNV(Queue queue, OutOfBandQueueTypeInfoNV* pQueueTypeInfo) @inline {
	internal::queueNotifyOutOfBandNV(queue, pQueueTypeInfo);
}

fn void! queuePresentKHR(Queue queue, PresentInfoKHR* pPresentInfo) @inline {
	vk::check(internal::queuePresentKHR(queue, pPresentInfo))!;
}

fn void! queueSetPerformanceConfigurationINTEL(Queue queue, PerformanceConfigurationINTEL configuration) @inline {
	vk::check(internal::queueSetPerformanceConfigurationINTEL(queue, configuration))!;
}

fn void! queueSubmit(Queue queue, uint submitCount, SubmitInfo* pSubmits, Fence fence) @inline {
	vk::check(internal::queueSubmit(queue, submitCount, pSubmits, fence))!;
}

fn void! queueSubmit2(Queue queue, uint submitCount, SubmitInfo2* pSubmits, Fence fence) @inline {
	vk::check(internal::queueSubmit2(queue, submitCount, pSubmits, fence))!;
}

fn void! queueSubmit2KHR(Queue queue, uint submitCount, SubmitInfo2* pSubmits, Fence fence) @inline {
	vk::check(internal::queueSubmit2KHR(queue, submitCount, pSubmits, fence))!;
}

fn void! queueWaitIdle(Queue queue) @inline {
	vk::check(internal::queueWaitIdle(queue))!;
}

fn void! registerDeviceEventEXT(Device device, DeviceEventInfoEXT* pDeviceEventInfo, AllocationCallbacks* pAllocator, Fence* pFence) @inline {
	vk::check(internal::registerDeviceEventEXT(device, pDeviceEventInfo, pAllocator, pFence))!;
}

fn void! registerDisplayEventEXT(Device device, DisplayKHR display, DisplayEventInfoEXT* pDisplayEventInfo, AllocationCallbacks* pAllocator, Fence* pFence) @inline {
	vk::check(internal::registerDisplayEventEXT(device, display, pDisplayEventInfo, pAllocator, pFence))!;
}

fn void! releaseCapturedPipelineDataKHR(Device device, ReleaseCapturedPipelineDataInfoKHR* pInfo, AllocationCallbacks* pAllocator) @inline {
	vk::check(internal::releaseCapturedPipelineDataKHR(device, pInfo, pAllocator))!;
}

fn void! releaseFullScreenExclusiveModeEXT(Device device, SwapchainKHR swapchain) @inline {
	vk::check(internal::releaseFullScreenExclusiveModeEXT(device, swapchain))!;
}

fn void! releasePerformanceConfigurationINTEL(Device device, PerformanceConfigurationINTEL configuration) @inline {
	vk::check(internal::releasePerformanceConfigurationINTEL(device, configuration))!;
}

fn void releaseProfilingLockKHR(Device device) @inline {
	internal::releaseProfilingLockKHR(device);
}

fn void! releaseSwapchainImagesEXT(Device device, ReleaseSwapchainImagesInfoEXT* pReleaseInfo) @inline {
	vk::check(internal::releaseSwapchainImagesEXT(device, pReleaseInfo))!;
}

fn void! resetCommandBuffer(CommandBuffer commandBuffer, CommandBufferResetFlags flags) @inline {
	vk::check(internal::resetCommandBuffer(commandBuffer, flags))!;
}

fn void! resetCommandPool(Device device, CommandPool commandPool, CommandPoolResetFlags flags) @inline {
	vk::check(internal::resetCommandPool(device, commandPool, flags))!;
}

fn void! resetDescriptorPool(Device device, DescriptorPool descriptorPool, DescriptorPoolResetFlags flags) @inline {
	vk::check(internal::resetDescriptorPool(device, descriptorPool, flags))!;
}

fn void! resetEvent(Device device, Event event) @inline {
	vk::check(internal::resetEvent(device, event))!;
}

fn void! resetFences(Device device, uint fenceCount, Fence* pFences) @inline {
	vk::check(internal::resetFences(device, fenceCount, pFences))!;
}

fn void resetQueryPool(Device device, QueryPool queryPool, uint firstQuery, uint queryCount) @inline {
	internal::resetQueryPool(device, queryPool, firstQuery, queryCount);
}

fn void resetQueryPoolEXT(Device device, QueryPool queryPool, uint firstQuery, uint queryCount) @inline {
	internal::resetQueryPoolEXT(device, queryPool, firstQuery, queryCount);
}

fn void! setDebugUtilsObjectNameEXT(Device device, DebugUtilsObjectNameInfoEXT* pNameInfo) @inline {
	vk::check(internal::setDebugUtilsObjectNameEXT(device, pNameInfo))!;
}

fn void! setDebugUtilsObjectTagEXT(Device device, DebugUtilsObjectTagInfoEXT* pTagInfo) @inline {
	vk::check(internal::setDebugUtilsObjectTagEXT(device, pTagInfo))!;
}

fn void setDeviceMemoryPriorityEXT(Device device, DeviceMemory memory, float priority) @inline {
	internal::setDeviceMemoryPriorityEXT(device, memory, priority);
}

fn void! setEvent(Device device, Event event) @inline {
	vk::check(internal::setEvent(device, event))!;
}

fn void setHdrMetadataEXT(Device device, uint swapchainCount, SwapchainKHR* pSwapchains, HdrMetadataEXT* pMetadata) @inline {
	internal::setHdrMetadataEXT(device, swapchainCount, pSwapchains, pMetadata);
}

fn void setLatencyMarkerNV(Device device, SwapchainKHR swapchain, SetLatencyMarkerInfoNV* pLatencyMarkerInfo) @inline {
	internal::setLatencyMarkerNV(device, swapchain, pLatencyMarkerInfo);
}

fn void! setLatencySleepModeNV(Device device, SwapchainKHR swapchain, LatencySleepModeInfoNV* pSleepModeInfo) @inline {
	vk::check(internal::setLatencySleepModeNV(device, swapchain, pSleepModeInfo))!;
}

fn void setLocalDimmingAMD(Device device, SwapchainKHR swapChain, uint localDimmingEnable) @inline {
	internal::setLocalDimmingAMD(device, swapChain, localDimmingEnable);
}

fn void! setPrivateData(Device device, ObjectType objectType, ulong objectHandle, PrivateDataSlot privateDataSlot, ulong data) @inline {
	vk::check(internal::setPrivateData(device, objectType, objectHandle, privateDataSlot, data))!;
}

fn void! setPrivateDataEXT(Device device, ObjectType objectType, ulong objectHandle, PrivateDataSlot privateDataSlot, ulong data) @inline {
	vk::check(internal::setPrivateDataEXT(device, objectType, objectHandle, privateDataSlot, data))!;
}

fn void! signalSemaphore(Device device, SemaphoreSignalInfo* pSignalInfo) @inline {
	vk::check(internal::signalSemaphore(device, pSignalInfo))!;
}

fn void! signalSemaphoreKHR(Device device, SemaphoreSignalInfo* pSignalInfo) @inline {
	vk::check(internal::signalSemaphoreKHR(device, pSignalInfo))!;
}

fn void! transitionImageLayout(Device device, uint transitionCount, HostImageLayoutTransitionInfo* pTransitions) @inline {
	vk::check(internal::transitionImageLayout(device, transitionCount, pTransitions))!;
}

fn void! transitionImageLayoutEXT(Device device, uint transitionCount, HostImageLayoutTransitionInfo* pTransitions) @inline {
	vk::check(internal::transitionImageLayoutEXT(device, transitionCount, pTransitions))!;
}

fn void trimCommandPool(Device device, CommandPool commandPool, CommandPoolTrimFlags flags) @inline {
	internal::trimCommandPool(device, commandPool, flags);
}

fn void trimCommandPoolKHR(Device device, CommandPool commandPool, CommandPoolTrimFlags flags) @inline {
	internal::trimCommandPoolKHR(device, commandPool, flags);
}

fn void uninitializePerformanceApiINTEL(Device device) @inline {
	internal::uninitializePerformanceApiINTEL(device);
}

fn void unmapMemory(Device device, DeviceMemory memory) @inline {
	internal::unmapMemory(device, memory);
}

fn void! unmapMemory2(Device device, MemoryUnmapInfo* pMemoryUnmapInfo) @inline {
	vk::check(internal::unmapMemory2(device, pMemoryUnmapInfo))!;
}

fn void! unmapMemory2KHR(Device device, MemoryUnmapInfo* pMemoryUnmapInfo) @inline {
	vk::check(internal::unmapMemory2KHR(device, pMemoryUnmapInfo))!;
}

fn void updateDescriptorSetWithTemplate(Device device, DescriptorSet descriptorSet, DescriptorUpdateTemplate descriptorUpdateTemplate, void* pData) @inline {
	internal::updateDescriptorSetWithTemplate(device, descriptorSet, descriptorUpdateTemplate, pData);
}

fn void updateDescriptorSetWithTemplateKHR(Device device, DescriptorSet descriptorSet, DescriptorUpdateTemplate descriptorUpdateTemplate, void* pData) @inline {
	internal::updateDescriptorSetWithTemplateKHR(device, descriptorSet, descriptorUpdateTemplate, pData);
}

fn void updateDescriptorSets(Device device, uint descriptorWriteCount, WriteDescriptorSet* pDescriptorWrites, uint descriptorCopyCount, CopyDescriptorSet* pDescriptorCopies) @inline {
	internal::updateDescriptorSets(device, descriptorWriteCount, pDescriptorWrites, descriptorCopyCount, pDescriptorCopies);
}

fn void updateIndirectExecutionSetPipelineEXT(Device device, IndirectExecutionSetEXT indirectExecutionSet, uint executionSetWriteCount, WriteIndirectExecutionSetPipelineEXT* pExecutionSetWrites) @inline {
	internal::updateIndirectExecutionSetPipelineEXT(device, indirectExecutionSet, executionSetWriteCount, pExecutionSetWrites);
}

fn void updateIndirectExecutionSetShaderEXT(Device device, IndirectExecutionSetEXT indirectExecutionSet, uint executionSetWriteCount, WriteIndirectExecutionSetShaderEXT* pExecutionSetWrites) @inline {
	internal::updateIndirectExecutionSetShaderEXT(device, indirectExecutionSet, executionSetWriteCount, pExecutionSetWrites);
}

fn void! updateVideoSessionParametersKHR(Device device, VideoSessionParametersKHR videoSessionParameters, VideoSessionParametersUpdateInfoKHR* pUpdateInfo) @inline {
	vk::check(internal::updateVideoSessionParametersKHR(device, videoSessionParameters, pUpdateInfo))!;
}

fn void! waitForFences(Device device, uint fenceCount, Fence* pFences, uint waitAll, ulong timeout) @inline {
	vk::check(internal::waitForFences(device, fenceCount, pFences, waitAll, timeout))!;
}

fn void! waitForPresentKHR(Device device, SwapchainKHR swapchain, ulong presentId, ulong timeout) @inline {
	vk::check(internal::waitForPresentKHR(device, swapchain, presentId, timeout))!;
}

fn void! waitSemaphores(Device device, SemaphoreWaitInfo* pWaitInfo, ulong timeout) @inline {
	vk::check(internal::waitSemaphores(device, pWaitInfo, timeout))!;
}

fn void! waitSemaphoresKHR(Device device, SemaphoreWaitInfo* pWaitInfo, ulong timeout) @inline {
	vk::check(internal::waitSemaphoresKHR(device, pWaitInfo, timeout))!;
}

fn void! writeAccelerationStructuresPropertiesKHR(Device device, uint accelerationStructureCount, AccelerationStructureKHR* pAccelerationStructures, QueryType queryType, usz dataSize, void* pData, usz stride) @inline {
	vk::check(internal::writeAccelerationStructuresPropertiesKHR(device, accelerationStructureCount, pAccelerationStructures, queryType, dataSize, pData, stride))!;
}

fn void! writeMicromapsPropertiesEXT(Device device, uint micromapCount, MicromapEXT* pMicromaps, QueryType queryType, usz dataSize, void* pData, usz stride) @inline {
	vk::check(internal::writeMicromapsPropertiesEXT(device, micromapCount, pMicromaps, queryType, dataSize, pData, stride))!;
}
