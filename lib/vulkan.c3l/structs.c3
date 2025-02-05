//
// Vulkan wrapper generated from "https://raw.githubusercontent.com/KhronosGroup/Vulkan-Headers/master/include/vulkan/vulkan_core.h"
//
module vk;

import std::core::cinterop;
import std::os::win32;
distinct Win32_HINSTANCE            @if(!env::WIN32) = void*;
distinct Win32_HANDLE               @if(!env::WIN32) = void*;
distinct Win32_HWND                 @if(!env::WIN32) = Win32_HANDLE;
distinct Win32_HMONITOR             @if(!env::WIN32) = Win32_HANDLE;
distinct Win32_LPCWSTR              @if(!env::WIN32) = short;
distinct Win32_SECURITY_ATTRIBUTES  @if(!env::WIN32) = void*;
distinct Win32_DWORD                @if(!env::WIN32) = uint;
distinct Win32_LONG                 @if(!env::WIN32) = int;
distinct Win32_LUID                 @if(!env::WIN32) = void*;

/* @if(xlib.IS_SUPPORTED) {
def XlibDisplay  = xlib.Display;
def XlibWindow   = xlib.Window;
def XlibVisualID = xlib.VisualID;
}
*/
distinct XlibDisplay  = void*; // Opaque struct defined by Xlib
distinct XlibWindow   = CULong;
distinct XlibVisualID = CULong;

distinct XCBVisualID  = uint;
distinct XCBWindow    = uint;
distinct CAMetalLayer = void*;

distinct MTLBuffer_id       = void*;
distinct MTLTexture_id      = void*;
distinct MTLSharedEvent_id  = void*;
distinct MTLDevice_id       = void*;
distinct MTLCommandQueue_id = void*;

/********************************/

struct Extent2D {
	uint width; 
	uint height; 
}

struct Extent3D {
	uint width; 
	uint height; 
	uint depth; 
}

struct Offset2D {
	int x; 
	int y; 
}

struct Offset3D {
	int x; 
	int y; 
	int z; 
}

struct Rect2D {
	Offset2D offset; 
	Extent2D extent; 
}

struct BaseInStructure {
	StructureType    sType; 
	BaseInStructure* pNext; 
}

struct BaseOutStructure {
	StructureType     sType; 
	BaseOutStructure* pNext; 
}

struct BufferMemoryBarrier {
	StructureType sType; 
	void*         pNext; 
	AccessFlags   srcAccessMask; 
	AccessFlags   dstAccessMask; 
	uint          srcQueueFamilyIndex; 
	uint          dstQueueFamilyIndex; 
	Buffer        buffer; 
	DeviceSize    offset; 
	DeviceSize    size; 
}

struct DispatchIndirectCommand {
	uint x; 
	uint y; 
	uint z; 
}

struct DrawIndexedIndirectCommand {
	uint indexCount; 
	uint instanceCount; 
	uint firstIndex; 
	int  vertexOffset; 
	uint firstInstance; 
}

struct DrawIndirectCommand {
	uint vertexCount; 
	uint instanceCount; 
	uint firstVertex; 
	uint firstInstance; 
}

struct ImageSubresourceRange {
	ImageAspectFlags aspectMask; 
	uint             baseMipLevel; 
	uint             levelCount; 
	uint             baseArrayLayer; 
	uint             layerCount; 
}

struct ImageMemoryBarrier {
	StructureType         sType; 
	void*                 pNext; 
	AccessFlags           srcAccessMask; 
	AccessFlags           dstAccessMask; 
	ImageLayout           oldLayout; 
	ImageLayout           newLayout; 
	uint                  srcQueueFamilyIndex; 
	uint                  dstQueueFamilyIndex; 
	Image                 image; 
	ImageSubresourceRange subresourceRange; 
}

struct MemoryBarrier {
	StructureType sType; 
	void*         pNext; 
	AccessFlags   srcAccessMask; 
	AccessFlags   dstAccessMask; 
}

struct PipelineCacheHeaderVersionOne {
	uint                       headerSize; 
	PipelineCacheHeaderVersion headerVersion; 
	uint                       vendorID; 
	uint                       deviceID; 
	char[UUID_SIZE]            pipelineCacheUUID; 
}

struct AllocationCallbacks {
	void*                              pUserData; 
	ProcAllocationFunction             pfnAllocation; 
	ProcReallocationFunction           pfnReallocation; 
	ProcFreeFunction                   pfnFree; 
	ProcInternalAllocationNotification pfnInternalAllocation; 
	ProcInternalFreeNotification       pfnInternalFree; 
}

struct ApplicationInfo {
	StructureType sType; 
	void*         pNext; 
	ZString       pApplicationName; 
	uint          applicationVersion; 
	ZString       pEngineName; 
	uint          engineVersion; 
	uint          apiVersion; 
}

struct FormatProperties {
	FormatFeatureFlags linearTilingFeatures; 
	FormatFeatureFlags optimalTilingFeatures; 
	FormatFeatureFlags bufferFeatures; 
}

struct ImageFormatProperties {
	Extent3D         maxExtent; 
	uint             maxMipLevels; 
	uint             maxArrayLayers; 
	SampleCountFlags sampleCounts; 
	DeviceSize       maxResourceSize; 
}

struct InstanceCreateInfo {
	StructureType       sType; 
	void*               pNext; 
	InstanceCreateFlags flags; 
	ApplicationInfo*    pApplicationInfo; 
	uint                enabledLayerCount; 
	ZString*            ppEnabledLayerNames; 
	uint                enabledExtensionCount; 
	ZString*            ppEnabledExtensionNames; 
}

struct MemoryHeap {
	DeviceSize      size; 
	MemoryHeapFlags flags; 
}

struct MemoryType {
	MemoryPropertyFlags propertyFlags; 
	uint                heapIndex; 
}

struct PhysicalDeviceFeatures {
	uint robustBufferAccess; 
	uint fullDrawIndexUint32; 
	uint imageCubeArray; 
	uint independentBlend; 
	uint geometryShader; 
	uint tessellationShader; 
	uint sampleRateShading; 
	uint dualSrcBlend; 
	uint logicOp; 
	uint multiDrawIndirect; 
	uint drawIndirectFirstInstance; 
	uint depthClamp; 
	uint depthBiasClamp; 
	uint fillModeNonSolid; 
	uint depthBounds; 
	uint wideLines; 
	uint largePoints; 
	uint alphaToOne; 
	uint multiViewport; 
	uint samplerAnisotropy; 
	uint textureCompressionETC2; 
	uint textureCompressionASTC_LDR; 
	uint textureCompressionBC; 
	uint occlusionQueryPrecise; 
	uint pipelineStatisticsQuery; 
	uint vertexPipelineStoresAndAtomics; 
	uint fragmentStoresAndAtomics; 
	uint shaderTessellationAndGeometryPointSize; 
	uint shaderImageGatherExtended; 
	uint shaderStorageImageExtendedFormats; 
	uint shaderStorageImageMultisample; 
	uint shaderStorageImageReadWithoutFormat; 
	uint shaderStorageImageWriteWithoutFormat; 
	uint shaderUniformBufferArrayDynamicIndexing; 
	uint shaderSampledImageArrayDynamicIndexing; 
	uint shaderStorageBufferArrayDynamicIndexing; 
	uint shaderStorageImageArrayDynamicIndexing; 
	uint shaderClipDistance; 
	uint shaderCullDistance; 
	uint shaderFloat64; 
	uint shaderInt64; 
	uint shaderInt16; 
	uint shaderResourceResidency; 
	uint shaderResourceMinLod; 
	uint sparseBinding; 
	uint sparseResidencyBuffer; 
	uint sparseResidencyImage2D; 
	uint sparseResidencyImage3D; 
	uint sparseResidency2Samples; 
	uint sparseResidency4Samples; 
	uint sparseResidency8Samples; 
	uint sparseResidency16Samples; 
	uint sparseResidencyAliased; 
	uint variableMultisampleRate; 
	uint inheritedQueries; 
}

struct PhysicalDeviceLimits {
	uint             maxImageDimension1D; 
	uint             maxImageDimension2D; 
	uint             maxImageDimension3D; 
	uint             maxImageDimensionCube; 
	uint             maxImageArrayLayers; 
	uint             maxTexelBufferElements; 
	uint             maxUniformBufferRange; 
	uint             maxStorageBufferRange; 
	uint             maxPushConstantsSize; 
	uint             maxMemoryAllocationCount; 
	uint             maxSamplerAllocationCount; 
	DeviceSize       bufferImageGranularity; 
	DeviceSize       sparseAddressSpaceSize; 
	uint             maxBoundDescriptorSets; 
	uint             maxPerStageDescriptorSamplers; 
	uint             maxPerStageDescriptorUniformBuffers; 
	uint             maxPerStageDescriptorStorageBuffers; 
	uint             maxPerStageDescriptorSampledImages; 
	uint             maxPerStageDescriptorStorageImages; 
	uint             maxPerStageDescriptorInputAttachments; 
	uint             maxPerStageResources; 
	uint             maxDescriptorSetSamplers; 
	uint             maxDescriptorSetUniformBuffers; 
	uint             maxDescriptorSetUniformBuffersDynamic; 
	uint             maxDescriptorSetStorageBuffers; 
	uint             maxDescriptorSetStorageBuffersDynamic; 
	uint             maxDescriptorSetSampledImages; 
	uint             maxDescriptorSetStorageImages; 
	uint             maxDescriptorSetInputAttachments; 
	uint             maxVertexInputAttributes; 
	uint             maxVertexInputBindings; 
	uint             maxVertexInputAttributeOffset; 
	uint             maxVertexInputBindingStride; 
	uint             maxVertexOutputComponents; 
	uint             maxTessellationGenerationLevel; 
	uint             maxTessellationPatchSize; 
	uint             maxTessellationControlPerVertexInputComponents; 
	uint             maxTessellationControlPerVertexOutputComponents; 
	uint             maxTessellationControlPerPatchOutputComponents; 
	uint             maxTessellationControlTotalOutputComponents; 
	uint             maxTessellationEvaluationInputComponents; 
	uint             maxTessellationEvaluationOutputComponents; 
	uint             maxGeometryShaderInvocations; 
	uint             maxGeometryInputComponents; 
	uint             maxGeometryOutputComponents; 
	uint             maxGeometryOutputVertices; 
	uint             maxGeometryTotalOutputComponents; 
	uint             maxFragmentInputComponents; 
	uint             maxFragmentOutputAttachments; 
	uint             maxFragmentDualSrcAttachments; 
	uint             maxFragmentCombinedOutputResources; 
	uint             maxComputeSharedMemorySize; 
	uint[3]          maxComputeWorkGroupCount; 
	uint             maxComputeWorkGroupInvocations; 
	uint[3]          maxComputeWorkGroupSize; 
	uint             subPixelPrecisionBits; 
	uint             subTexelPrecisionBits; 
	uint             mipmapPrecisionBits; 
	uint             maxDrawIndexedIndexValue; 
	uint             maxDrawIndirectCount; 
	float            maxSamplerLodBias; 
	float            maxSamplerAnisotropy; 
	uint             maxViewports; 
	uint[2]          maxViewportDimensions; 
	float[2]         viewportBoundsRange; 
	uint             viewportSubPixelBits; 
	usz              minMemoryMapAlignment; 
	DeviceSize       minTexelBufferOffsetAlignment; 
	DeviceSize       minUniformBufferOffsetAlignment; 
	DeviceSize       minStorageBufferOffsetAlignment; 
	int              minTexelOffset; 
	uint             maxTexelOffset; 
	int              minTexelGatherOffset; 
	uint             maxTexelGatherOffset; 
	float            minInterpolationOffset; 
	float            maxInterpolationOffset; 
	uint             subPixelInterpolationOffsetBits; 
	uint             maxFramebufferWidth; 
	uint             maxFramebufferHeight; 
	uint             maxFramebufferLayers; 
	SampleCountFlags framebufferColorSampleCounts; 
	SampleCountFlags framebufferDepthSampleCounts; 
	SampleCountFlags framebufferStencilSampleCounts; 
	SampleCountFlags framebufferNoAttachmentsSampleCounts; 
	uint             maxColorAttachments; 
	SampleCountFlags sampledImageColorSampleCounts; 
	SampleCountFlags sampledImageIntegerSampleCounts; 
	SampleCountFlags sampledImageDepthSampleCounts; 
	SampleCountFlags sampledImageStencilSampleCounts; 
	SampleCountFlags storageImageSampleCounts; 
	uint             maxSampleMaskWords; 
	uint             timestampComputeAndGraphics; 
	float            timestampPeriod; 
	uint             maxClipDistances; 
	uint             maxCullDistances; 
	uint             maxCombinedClipAndCullDistances; 
	uint             discreteQueuePriorities; 
	float[2]         pointSizeRange; 
	float[2]         lineWidthRange; 
	float            pointSizeGranularity; 
	float            lineWidthGranularity; 
	uint             strictLines; 
	uint             standardSampleLocations; 
	DeviceSize       optimalBufferCopyOffsetAlignment; 
	DeviceSize       optimalBufferCopyRowPitchAlignment; 
	DeviceSize       nonCoherentAtomSize; 
}

struct PhysicalDeviceMemoryProperties {
	uint                         memoryTypeCount; 
	MemoryType[MAX_MEMORY_TYPES] memoryTypes; 
	uint                         memoryHeapCount; 
	MemoryHeap[MAX_MEMORY_HEAPS] memoryHeaps; 
}

struct PhysicalDeviceSparseProperties {
	uint residencyStandard2DBlockShape; 
	uint residencyStandard2DMultisampleBlockShape; 
	uint residencyStandard3DBlockShape; 
	uint residencyAlignedMipSize; 
	uint residencyNonResidentStrict; 
}

struct PhysicalDeviceProperties {
	uint                                 apiVersion; 
	uint                                 driverVersion; 
	uint                                 vendorID; 
	uint                                 deviceID; 
	PhysicalDeviceType                   deviceType; 
	ichar[MAX_PHYSICAL_DEVICE_NAME_SIZE] deviceName; 
	char[UUID_SIZE]                      pipelineCacheUUID; 
	PhysicalDeviceLimits                 limits; 
	PhysicalDeviceSparseProperties       sparseProperties; 
}

struct QueueFamilyProperties {
	QueueFlags queueFlags; 
	uint       queueCount; 
	uint       timestampValidBits; 
	Extent3D   minImageTransferGranularity; 
}

struct DeviceQueueCreateInfo {
	StructureType          sType; 
	void*                  pNext; 
	DeviceQueueCreateFlags flags; 
	uint                   queueFamilyIndex; 
	uint                   queueCount; 
	float*                 pQueuePriorities; 
}

struct DeviceCreateInfo {
	StructureType           sType; 
	void*                   pNext; 
	DeviceCreateFlags       flags; 
	uint                    queueCreateInfoCount; 
	DeviceQueueCreateInfo*  pQueueCreateInfos; 
	uint                    enabledLayerCount; 
	ZString*                ppEnabledLayerNames; 
	uint                    enabledExtensionCount; 
	ZString*                ppEnabledExtensionNames; 
	PhysicalDeviceFeatures* pEnabledFeatures; 
}

struct ExtensionProperties {
	ichar[MAX_EXTENSION_NAME_SIZE] extensionName; 
	uint                           specVersion; 
}

struct LayerProperties {
	ichar[MAX_EXTENSION_NAME_SIZE] layerName; 
	uint                           specVersion; 
	uint                           implementationVersion; 
	ichar[MAX_DESCRIPTION_SIZE]    description; 
}

struct SubmitInfo {
	StructureType       sType; 
	void*               pNext; 
	uint                waitSemaphoreCount; 
	Semaphore*          pWaitSemaphores; 
	PipelineStageFlags* pWaitDstStageMask; 
	uint                commandBufferCount; 
	CommandBuffer*      pCommandBuffers; 
	uint                signalSemaphoreCount; 
	Semaphore*          pSignalSemaphores; 
}

struct MappedMemoryRange {
	StructureType sType; 
	void*         pNext; 
	DeviceMemory  memory; 
	DeviceSize    offset; 
	DeviceSize    size; 
}

struct MemoryAllocateInfo {
	StructureType sType; 
	void*         pNext; 
	DeviceSize    allocationSize; 
	uint          memoryTypeIndex; 
}

struct MemoryRequirements {
	DeviceSize size; 
	DeviceSize alignment; 
	uint       memoryTypeBits; 
}

struct SparseMemoryBind {
	DeviceSize            resourceOffset; 
	DeviceSize            size; 
	DeviceMemory          memory; 
	DeviceSize            memoryOffset; 
	SparseMemoryBindFlags flags; 
}

struct SparseBufferMemoryBindInfo {
	Buffer            buffer; 
	uint              bindCount; 
	SparseMemoryBind* pBinds; 
}

struct SparseImageOpaqueMemoryBindInfo {
	Image             image; 
	uint              bindCount; 
	SparseMemoryBind* pBinds; 
}

struct ImageSubresource {
	ImageAspectFlags aspectMask; 
	uint             mipLevel; 
	uint             arrayLayer; 
}

struct SparseImageMemoryBind {
	ImageSubresource      subresource; 
	Offset3D              offset; 
	Extent3D              extent; 
	DeviceMemory          memory; 
	DeviceSize            memoryOffset; 
	SparseMemoryBindFlags flags; 
}

struct SparseImageMemoryBindInfo {
	Image                  image; 
	uint                   bindCount; 
	SparseImageMemoryBind* pBinds; 
}

struct BindSparseInfo {
	StructureType                    sType; 
	void*                            pNext; 
	uint                             waitSemaphoreCount; 
	Semaphore*                       pWaitSemaphores; 
	uint                             bufferBindCount; 
	SparseBufferMemoryBindInfo*      pBufferBinds; 
	uint                             imageOpaqueBindCount; 
	SparseImageOpaqueMemoryBindInfo* pImageOpaqueBinds; 
	uint                             imageBindCount; 
	SparseImageMemoryBindInfo*       pImageBinds; 
	uint                             signalSemaphoreCount; 
	Semaphore*                       pSignalSemaphores; 
}

struct SparseImageFormatProperties {
	ImageAspectFlags       aspectMask; 
	Extent3D               imageGranularity; 
	SparseImageFormatFlags flags; 
}

struct SparseImageMemoryRequirements {
	SparseImageFormatProperties formatProperties; 
	uint                        imageMipTailFirstLod; 
	DeviceSize                  imageMipTailSize; 
	DeviceSize                  imageMipTailOffset; 
	DeviceSize                  imageMipTailStride; 
}

struct FenceCreateInfo {
	StructureType    sType; 
	void*            pNext; 
	FenceCreateFlags flags; 
}

struct SemaphoreCreateInfo {
	StructureType        sType; 
	void*                pNext; 
	SemaphoreCreateFlags flags; 
}

struct EventCreateInfo {
	StructureType    sType; 
	void*            pNext; 
	EventCreateFlags flags; 
}

struct QueryPoolCreateInfo {
	StructureType               sType; 
	void*                       pNext; 
	QueryPoolCreateFlags        flags; 
	QueryType                   queryType; 
	uint                        queryCount; 
	QueryPipelineStatisticFlags pipelineStatistics; 
}

struct BufferCreateInfo {
	StructureType     sType; 
	void*             pNext; 
	BufferCreateFlags flags; 
	DeviceSize        size; 
	BufferUsageFlags  usage; 
	SharingMode       sharingMode; 
	uint              queueFamilyIndexCount; 
	uint*             pQueueFamilyIndices; 
}

struct BufferViewCreateInfo {
	StructureType         sType; 
	void*                 pNext; 
	BufferViewCreateFlags flags; 
	Buffer                buffer; 
	Format                format; 
	DeviceSize            offset; 
	DeviceSize            range; 
}

struct ImageCreateInfo {
	StructureType    sType; 
	void*            pNext; 
	ImageCreateFlags flags; 
	ImageType        imageType; 
	Format           format; 
	Extent3D         extent; 
	uint             mipLevels; 
	uint             arrayLayers; 
	SampleCountFlags samples; 
	ImageTiling      tiling; 
	ImageUsageFlags  usage; 
	SharingMode      sharingMode; 
	uint             queueFamilyIndexCount; 
	uint*            pQueueFamilyIndices; 
	ImageLayout      initialLayout; 
}

struct SubresourceLayout {
	DeviceSize offset; 
	DeviceSize size; 
	DeviceSize rowPitch; 
	DeviceSize arrayPitch; 
	DeviceSize depthPitch; 
}

struct ComponentMapping {
	ComponentSwizzle r; 
	ComponentSwizzle g; 
	ComponentSwizzle b; 
	ComponentSwizzle a; 
}

struct ImageViewCreateInfo {
	StructureType         sType; 
	void*                 pNext; 
	ImageViewCreateFlags  flags; 
	Image                 image; 
	ImageViewType         viewType; 
	Format                format; 
	ComponentMapping      components; 
	ImageSubresourceRange subresourceRange; 
}

struct ShaderModuleCreateInfo {
	StructureType           sType; 
	void*                   pNext; 
	ShaderModuleCreateFlags flags; 
	usz                     codeSize; 
	uint*                   pCode; 
}

struct PipelineCacheCreateInfo {
	StructureType            sType; 
	void*                    pNext; 
	PipelineCacheCreateFlags flags; 
	usz                      initialDataSize; 
	void*                    pInitialData; 
}

struct SpecializationMapEntry {
	uint constantID; 
	uint offset; 
	usz  size; 
}

struct SpecializationInfo {
	uint                    mapEntryCount; 
	SpecializationMapEntry* pMapEntries; 
	usz                     dataSize; 
	void*                   pData; 
}

struct PipelineShaderStageCreateInfo {
	StructureType                  sType; 
	void*                          pNext; 
	PipelineShaderStageCreateFlags flags; 
	ShaderStageFlags               stage; 
	ShaderModule                   module_; 
	ZString                        pName; 
	SpecializationInfo*            pSpecializationInfo; 
}

struct ComputePipelineCreateInfo {
	StructureType                 sType; 
	void*                         pNext; 
	PipelineCreateFlags           flags; 
	PipelineShaderStageCreateInfo stage; 
	PipelineLayout                layout; 
	Pipeline                      basePipelineHandle; 
	int                           basePipelineIndex; 
}

struct VertexInputBindingDescription {
	uint            binding; 
	uint            stride; 
	VertexInputRate inputRate; 
}

struct VertexInputAttributeDescription {
	uint   location; 
	uint   binding; 
	Format format; 
	uint   offset; 
}

struct PipelineVertexInputStateCreateInfo {
	StructureType                       sType; 
	void*                               pNext; 
	PipelineVertexInputStateCreateFlags flags; 
	uint                                vertexBindingDescriptionCount; 
	VertexInputBindingDescription*      pVertexBindingDescriptions; 
	uint                                vertexAttributeDescriptionCount; 
	VertexInputAttributeDescription*    pVertexAttributeDescriptions; 
}

struct PipelineInputAssemblyStateCreateInfo {
	StructureType                         sType; 
	void*                                 pNext; 
	PipelineInputAssemblyStateCreateFlags flags; 
	PrimitiveTopology                     topology; 
	uint                                  primitiveRestartEnable; 
}

struct PipelineTessellationStateCreateInfo {
	StructureType                        sType; 
	void*                                pNext; 
	PipelineTessellationStateCreateFlags flags; 
	uint                                 patchControlPoints; 
}

struct Viewport {
	float x; 
	float y; 
	float width; 
	float height; 
	float minDepth; 
	float maxDepth; 
}

struct PipelineViewportStateCreateInfo {
	StructureType                    sType; 
	void*                            pNext; 
	PipelineViewportStateCreateFlags flags; 
	uint                             viewportCount; 
	Viewport*                        pViewports; 
	uint                             scissorCount; 
	Rect2D*                          pScissors; 
}

struct PipelineRasterizationStateCreateInfo {
	StructureType                         sType; 
	void*                                 pNext; 
	PipelineRasterizationStateCreateFlags flags; 
	uint                                  depthClampEnable; 
	uint                                  rasterizerDiscardEnable; 
	PolygonMode                           polygonMode; 
	CullModeFlags                         cullMode; 
	FrontFace                             frontFace; 
	uint                                  depthBiasEnable; 
	float                                 depthBiasConstantFactor; 
	float                                 depthBiasClamp; 
	float                                 depthBiasSlopeFactor; 
	float                                 lineWidth; 
}

struct PipelineMultisampleStateCreateInfo {
	StructureType                       sType; 
	void*                               pNext; 
	PipelineMultisampleStateCreateFlags flags; 
	SampleCountFlags                    rasterizationSamples; 
	uint                                sampleShadingEnable; 
	float                               minSampleShading; 
	SampleMask*                         pSampleMask; 
	uint                                alphaToCoverageEnable; 
	uint                                alphaToOneEnable; 
}

struct StencilOpState {
	StencilOp failOp; 
	StencilOp passOp; 
	StencilOp depthFailOp; 
	CompareOp compareOp; 
	uint      compareMask; 
	uint      writeMask; 
	uint      reference; 
}

struct PipelineDepthStencilStateCreateInfo {
	StructureType                        sType; 
	void*                                pNext; 
	PipelineDepthStencilStateCreateFlags flags; 
	uint                                 depthTestEnable; 
	uint                                 depthWriteEnable; 
	CompareOp                            depthCompareOp; 
	uint                                 depthBoundsTestEnable; 
	uint                                 stencilTestEnable; 
	StencilOpState                       front; 
	StencilOpState                       back; 
	float                                minDepthBounds; 
	float                                maxDepthBounds; 
}

struct PipelineColorBlendAttachmentState {
	uint                blendEnable; 
	BlendFactor         srcColorBlendFactor; 
	BlendFactor         dstColorBlendFactor; 
	BlendOp             colorBlendOp; 
	BlendFactor         srcAlphaBlendFactor; 
	BlendFactor         dstAlphaBlendFactor; 
	BlendOp             alphaBlendOp; 
	ColorComponentFlags colorWriteMask; 
}

struct PipelineColorBlendStateCreateInfo {
	StructureType                      sType; 
	void*                              pNext; 
	PipelineColorBlendStateCreateFlags flags; 
	uint                               logicOpEnable; 
	LogicOp                            logicOp; 
	uint                               attachmentCount; 
	PipelineColorBlendAttachmentState* pAttachments; 
	float[4]                           blendConstants; 
}

struct PipelineDynamicStateCreateInfo {
	StructureType                   sType; 
	void*                           pNext; 
	PipelineDynamicStateCreateFlags flags; 
	uint                            dynamicStateCount; 
	DynamicState*                   pDynamicStates; 
}

struct GraphicsPipelineCreateInfo {
	StructureType                         sType; 
	void*                                 pNext; 
	PipelineCreateFlags                   flags; 
	uint                                  stageCount; 
	PipelineShaderStageCreateInfo*        pStages; 
	PipelineVertexInputStateCreateInfo*   pVertexInputState; 
	PipelineInputAssemblyStateCreateInfo* pInputAssemblyState; 
	PipelineTessellationStateCreateInfo*  pTessellationState; 
	PipelineViewportStateCreateInfo*      pViewportState; 
	PipelineRasterizationStateCreateInfo* pRasterizationState; 
	PipelineMultisampleStateCreateInfo*   pMultisampleState; 
	PipelineDepthStencilStateCreateInfo*  pDepthStencilState; 
	PipelineColorBlendStateCreateInfo*    pColorBlendState; 
	PipelineDynamicStateCreateInfo*       pDynamicState; 
	PipelineLayout                        layout; 
	RenderPass                            renderPass; 
	uint                                  subpass; 
	Pipeline                              basePipelineHandle; 
	int                                   basePipelineIndex; 
}

struct PushConstantRange {
	ShaderStageFlags stageFlags; 
	uint             offset; 
	uint             size; 
}

struct PipelineLayoutCreateInfo {
	StructureType             sType; 
	void*                     pNext; 
	PipelineLayoutCreateFlags flags; 
	uint                      setLayoutCount; 
	DescriptorSetLayout*      pSetLayouts; 
	uint                      pushConstantRangeCount; 
	PushConstantRange*        pPushConstantRanges; 
}

struct SamplerCreateInfo {
	StructureType      sType; 
	void*              pNext; 
	SamplerCreateFlags flags; 
	Filter             magFilter; 
	Filter             minFilter; 
	SamplerMipmapMode  mipmapMode; 
	SamplerAddressMode addressModeU; 
	SamplerAddressMode addressModeV; 
	SamplerAddressMode addressModeW; 
	float              mipLodBias; 
	uint               anisotropyEnable; 
	float              maxAnisotropy; 
	uint               compareEnable; 
	CompareOp          compareOp; 
	float              minLod; 
	float              maxLod; 
	BorderColor        borderColor; 
	uint               unnormalizedCoordinates; 
}

struct CopyDescriptorSet {
	StructureType sType; 
	void*         pNext; 
	DescriptorSet srcSet; 
	uint          srcBinding; 
	uint          srcArrayElement; 
	DescriptorSet dstSet; 
	uint          dstBinding; 
	uint          dstArrayElement; 
	uint          descriptorCount; 
}

struct DescriptorBufferInfo {
	Buffer     buffer; 
	DeviceSize offset; 
	DeviceSize range; 
}

struct DescriptorImageInfo {
	Sampler     sampler; 
	ImageView   imageView; 
	ImageLayout imageLayout; 
}

struct DescriptorPoolSize {
	DescriptorType type; 
	uint           descriptorCount; 
}

struct DescriptorPoolCreateInfo {
	StructureType             sType; 
	void*                     pNext; 
	DescriptorPoolCreateFlags flags; 
	uint                      maxSets; 
	uint                      poolSizeCount; 
	DescriptorPoolSize*       pPoolSizes; 
}

struct DescriptorSetAllocateInfo {
	StructureType        sType; 
	void*                pNext; 
	DescriptorPool       descriptorPool; 
	uint                 descriptorSetCount; 
	DescriptorSetLayout* pSetLayouts; 
}

struct DescriptorSetLayoutBinding {
	uint             binding; 
	DescriptorType   descriptorType; 
	uint             descriptorCount; 
	ShaderStageFlags stageFlags; 
	Sampler*         pImmutableSamplers; 
}

struct DescriptorSetLayoutCreateInfo {
	StructureType                  sType; 
	void*                          pNext; 
	DescriptorSetLayoutCreateFlags flags; 
	uint                           bindingCount; 
	DescriptorSetLayoutBinding*    pBindings; 
}

struct WriteDescriptorSet {
	StructureType         sType; 
	void*                 pNext; 
	DescriptorSet         dstSet; 
	uint                  dstBinding; 
	uint                  dstArrayElement; 
	uint                  descriptorCount; 
	DescriptorType        descriptorType; 
	DescriptorImageInfo*  pImageInfo; 
	DescriptorBufferInfo* pBufferInfo; 
	BufferView*           pTexelBufferView; 
}

struct AttachmentDescription {
	AttachmentDescriptionFlags flags; 
	Format                     format; 
	SampleCountFlags           samples; 
	AttachmentLoadOp           loadOp; 
	AttachmentStoreOp          storeOp; 
	AttachmentLoadOp           stencilLoadOp; 
	AttachmentStoreOp          stencilStoreOp; 
	ImageLayout                initialLayout; 
	ImageLayout                finalLayout; 
}

struct AttachmentReference {
	uint        attachment; 
	ImageLayout layout; 
}

struct FramebufferCreateInfo {
	StructureType          sType; 
	void*                  pNext; 
	FramebufferCreateFlags flags; 
	RenderPass             renderPass; 
	uint                   attachmentCount; 
	ImageView*             pAttachments; 
	uint                   width; 
	uint                   height; 
	uint                   layers; 
}

struct SubpassDescription {
	SubpassDescriptionFlags flags; 
	PipelineBindPoint       pipelineBindPoint; 
	uint                    inputAttachmentCount; 
	AttachmentReference*    pInputAttachments; 
	uint                    colorAttachmentCount; 
	AttachmentReference*    pColorAttachments; 
	AttachmentReference*    pResolveAttachments; 
	AttachmentReference*    pDepthStencilAttachment; 
	uint                    preserveAttachmentCount; 
	uint*                   pPreserveAttachments; 
}

struct SubpassDependency {
	uint               srcSubpass; 
	uint               dstSubpass; 
	PipelineStageFlags srcStageMask; 
	PipelineStageFlags dstStageMask; 
	AccessFlags        srcAccessMask; 
	AccessFlags        dstAccessMask; 
	DependencyFlags    dependencyFlags; 
}

struct RenderPassCreateInfo {
	StructureType          sType; 
	void*                  pNext; 
	RenderPassCreateFlags  flags; 
	uint                   attachmentCount; 
	AttachmentDescription* pAttachments; 
	uint                   subpassCount; 
	SubpassDescription*    pSubpasses; 
	uint                   dependencyCount; 
	SubpassDependency*     pDependencies; 
}

struct CommandPoolCreateInfo {
	StructureType          sType; 
	void*                  pNext; 
	CommandPoolCreateFlags flags; 
	uint                   queueFamilyIndex; 
}

struct CommandBufferAllocateInfo {
	StructureType      sType; 
	void*              pNext; 
	CommandPool        commandPool; 
	CommandBufferLevel level; 
	uint               commandBufferCount; 
}

struct CommandBufferInheritanceInfo {
	StructureType               sType; 
	void*                       pNext; 
	RenderPass                  renderPass; 
	uint                        subpass; 
	Framebuffer                 framebuffer; 
	uint                        occlusionQueryEnable; 
	QueryControlFlags           queryFlags; 
	QueryPipelineStatisticFlags pipelineStatistics; 
}

struct CommandBufferBeginInfo {
	StructureType                 sType; 
	void*                         pNext; 
	CommandBufferUsageFlags       flags; 
	CommandBufferInheritanceInfo* pInheritanceInfo; 
}

struct BufferCopy {
	DeviceSize srcOffset; 
	DeviceSize dstOffset; 
	DeviceSize size; 
}

struct ImageSubresourceLayers {
	ImageAspectFlags aspectMask; 
	uint             mipLevel; 
	uint             baseArrayLayer; 
	uint             layerCount; 
}

struct BufferImageCopy {
	DeviceSize             bufferOffset; 
	uint                   bufferRowLength; 
	uint                   bufferImageHeight; 
	ImageSubresourceLayers imageSubresource; 
	Offset3D               imageOffset; 
	Extent3D               imageExtent; 
}

union ClearColorValue {
	float[4] float32; 
	int[4]   int32; 
	uint[4]  uint32; 
}

struct ClearDepthStencilValue {
	float depth; 
	uint  stencil; 
}

union ClearValue {
	ClearColorValue        color; 
	ClearDepthStencilValue depthStencil; 
}

struct ClearAttachment {
	ImageAspectFlags aspectMask; 
	uint             colorAttachment; 
	ClearValue       clearValue; 
}

struct ClearRect {
	Rect2D rect; 
	uint   baseArrayLayer; 
	uint   layerCount; 
}

struct ImageBlit {
	ImageSubresourceLayers srcSubresource; 
	Offset3D[2]            srcOffsets; 
	ImageSubresourceLayers dstSubresource; 
	Offset3D[2]            dstOffsets; 
}

struct ImageCopy {
	ImageSubresourceLayers srcSubresource; 
	Offset3D               srcOffset; 
	ImageSubresourceLayers dstSubresource; 
	Offset3D               dstOffset; 
	Extent3D               extent; 
}

struct ImageResolve {
	ImageSubresourceLayers srcSubresource; 
	Offset3D               srcOffset; 
	ImageSubresourceLayers dstSubresource; 
	Offset3D               dstOffset; 
	Extent3D               extent; 
}

struct RenderPassBeginInfo {
	StructureType sType; 
	void*         pNext; 
	RenderPass    renderPass; 
	Framebuffer   framebuffer; 
	Rect2D        renderArea; 
	uint          clearValueCount; 
	ClearValue*   pClearValues; 
}

struct PhysicalDeviceSubgroupProperties {
	StructureType        sType; 
	void*                pNext; 
	uint                 subgroupSize; 
	ShaderStageFlags     supportedStages; 
	SubgroupFeatureFlags supportedOperations; 
	uint                 quadOperationsInAllStages; 
}

struct BindBufferMemoryInfo {
	StructureType sType; 
	void*         pNext; 
	Buffer        buffer; 
	DeviceMemory  memory; 
	DeviceSize    memoryOffset; 
}

struct BindImageMemoryInfo {
	StructureType sType; 
	void*         pNext; 
	Image         image; 
	DeviceMemory  memory; 
	DeviceSize    memoryOffset; 
}

struct PhysicalDevice16BitStorageFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          storageBuffer16BitAccess; 
	uint          uniformAndStorageBuffer16BitAccess; 
	uint          storagePushConstant16; 
	uint          storageInputOutput16; 
}

struct MemoryDedicatedRequirements {
	StructureType sType; 
	void*         pNext; 
	uint          prefersDedicatedAllocation; 
	uint          requiresDedicatedAllocation; 
}

struct MemoryDedicatedAllocateInfo {
	StructureType sType; 
	void*         pNext; 
	Image         image; 
	Buffer        buffer; 
}

struct MemoryAllocateFlagsInfo {
	StructureType       sType; 
	void*               pNext; 
	MemoryAllocateFlags flags; 
	uint                deviceMask; 
}

struct DeviceGroupRenderPassBeginInfo {
	StructureType sType; 
	void*         pNext; 
	uint          deviceMask; 
	uint          deviceRenderAreaCount; 
	Rect2D*       pDeviceRenderAreas; 
}

struct DeviceGroupCommandBufferBeginInfo {
	StructureType sType; 
	void*         pNext; 
	uint          deviceMask; 
}

struct DeviceGroupSubmitInfo {
	StructureType sType; 
	void*         pNext; 
	uint          waitSemaphoreCount; 
	uint*         pWaitSemaphoreDeviceIndices; 
	uint          commandBufferCount; 
	uint*         pCommandBufferDeviceMasks; 
	uint          signalSemaphoreCount; 
	uint*         pSignalSemaphoreDeviceIndices; 
}

struct DeviceGroupBindSparseInfo {
	StructureType sType; 
	void*         pNext; 
	uint          resourceDeviceIndex; 
	uint          memoryDeviceIndex; 
}

struct BindBufferMemoryDeviceGroupInfo {
	StructureType sType; 
	void*         pNext; 
	uint          deviceIndexCount; 
	uint*         pDeviceIndices; 
}

struct BindImageMemoryDeviceGroupInfo {
	StructureType sType; 
	void*         pNext; 
	uint          deviceIndexCount; 
	uint*         pDeviceIndices; 
	uint          splitInstanceBindRegionCount; 
	Rect2D*       pSplitInstanceBindRegions; 
}

struct PhysicalDeviceGroupProperties {
	StructureType                         sType; 
	void*                                 pNext; 
	uint                                  physicalDeviceCount; 
	PhysicalDevice[MAX_DEVICE_GROUP_SIZE] physicalDevices; 
	uint                                  subsetAllocation; 
}

struct DeviceGroupDeviceCreateInfo {
	StructureType   sType; 
	void*           pNext; 
	uint            physicalDeviceCount; 
	PhysicalDevice* pPhysicalDevices; 
}

struct BufferMemoryRequirementsInfo2 {
	StructureType sType; 
	void*         pNext; 
	Buffer        buffer; 
}

struct ImageMemoryRequirementsInfo2 {
	StructureType sType; 
	void*         pNext; 
	Image         image; 
}

struct ImageSparseMemoryRequirementsInfo2 {
	StructureType sType; 
	void*         pNext; 
	Image         image; 
}

struct MemoryRequirements2 {
	StructureType      sType; 
	void*              pNext; 
	MemoryRequirements memoryRequirements; 
}

struct SparseImageMemoryRequirements2 {
	StructureType                 sType; 
	void*                         pNext; 
	SparseImageMemoryRequirements memoryRequirements; 
}

struct PhysicalDeviceFeatures2 {
	StructureType          sType; 
	void*                  pNext; 
	PhysicalDeviceFeatures features; 
}

struct PhysicalDeviceProperties2 {
	StructureType            sType; 
	void*                    pNext; 
	PhysicalDeviceProperties properties; 
}

struct FormatProperties2 {
	StructureType    sType; 
	void*            pNext; 
	FormatProperties formatProperties; 
}

struct ImageFormatProperties2 {
	StructureType         sType; 
	void*                 pNext; 
	ImageFormatProperties imageFormatProperties; 
}

struct PhysicalDeviceImageFormatInfo2 {
	StructureType    sType; 
	void*            pNext; 
	Format           format; 
	ImageType        type; 
	ImageTiling      tiling; 
	ImageUsageFlags  usage; 
	ImageCreateFlags flags; 
}

struct QueueFamilyProperties2 {
	StructureType         sType; 
	void*                 pNext; 
	QueueFamilyProperties queueFamilyProperties; 
}

struct PhysicalDeviceMemoryProperties2 {
	StructureType                  sType; 
	void*                          pNext; 
	PhysicalDeviceMemoryProperties memoryProperties; 
}

struct SparseImageFormatProperties2 {
	StructureType               sType; 
	void*                       pNext; 
	SparseImageFormatProperties properties; 
}

struct PhysicalDeviceSparseImageFormatInfo2 {
	StructureType    sType; 
	void*            pNext; 
	Format           format; 
	ImageType        type; 
	SampleCountFlags samples; 
	ImageUsageFlags  usage; 
	ImageTiling      tiling; 
}

struct PhysicalDevicePointClippingProperties {
	StructureType         sType; 
	void*                 pNext; 
	PointClippingBehavior pointClippingBehavior; 
}

struct InputAttachmentAspectReference {
	uint             subpass; 
	uint             inputAttachmentIndex; 
	ImageAspectFlags aspectMask; 
}

struct RenderPassInputAttachmentAspectCreateInfo {
	StructureType                   sType; 
	void*                           pNext; 
	uint                            aspectReferenceCount; 
	InputAttachmentAspectReference* pAspectReferences; 
}

struct ImageViewUsageCreateInfo {
	StructureType   sType; 
	void*           pNext; 
	ImageUsageFlags usage; 
}

struct PipelineTessellationDomainOriginStateCreateInfo {
	StructureType            sType; 
	void*                    pNext; 
	TessellationDomainOrigin domainOrigin; 
}

struct RenderPassMultiviewCreateInfo {
	StructureType sType; 
	void*         pNext; 
	uint          subpassCount; 
	uint*         pViewMasks; 
	uint          dependencyCount; 
	int*          pViewOffsets; 
	uint          correlationMaskCount; 
	uint*         pCorrelationMasks; 
}

struct PhysicalDeviceMultiviewFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          multiview; 
	uint          multiviewGeometryShader; 
	uint          multiviewTessellationShader; 
}

struct PhysicalDeviceMultiviewProperties {
	StructureType sType; 
	void*         pNext; 
	uint          maxMultiviewViewCount; 
	uint          maxMultiviewInstanceIndex; 
}

struct PhysicalDeviceVariablePointersFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          variablePointersStorageBuffer; 
	uint          variablePointers; 
}

struct PhysicalDeviceProtectedMemoryFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          protectedMemory; 
}

struct PhysicalDeviceProtectedMemoryProperties {
	StructureType sType; 
	void*         pNext; 
	uint          protectedNoFault; 
}

struct DeviceQueueInfo2 {
	StructureType          sType; 
	void*                  pNext; 
	DeviceQueueCreateFlags flags; 
	uint                   queueFamilyIndex; 
	uint                   queueIndex; 
}

struct ProtectedSubmitInfo {
	StructureType sType; 
	void*         pNext; 
	uint          protectedSubmit; 
}

struct SamplerYcbcrConversionCreateInfo {
	StructureType               sType; 
	void*                       pNext; 
	Format                      format; 
	SamplerYcbcrModelConversion ycbcrModel; 
	SamplerYcbcrRange           ycbcrRange; 
	ComponentMapping            components; 
	ChromaLocation              xChromaOffset; 
	ChromaLocation              yChromaOffset; 
	Filter                      chromaFilter; 
	uint                        forceExplicitReconstruction; 
}

struct SamplerYcbcrConversionInfo {
	StructureType          sType; 
	void*                  pNext; 
	SamplerYcbcrConversion conversion; 
}

struct BindImagePlaneMemoryInfo {
	StructureType    sType; 
	void*            pNext; 
	ImageAspectFlags planeAspect; 
}

struct ImagePlaneMemoryRequirementsInfo {
	StructureType    sType; 
	void*            pNext; 
	ImageAspectFlags planeAspect; 
}

struct PhysicalDeviceSamplerYcbcrConversionFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          samplerYcbcrConversion; 
}

struct SamplerYcbcrConversionImageFormatProperties {
	StructureType sType; 
	void*         pNext; 
	uint          combinedImageSamplerDescriptorCount; 
}

struct DescriptorUpdateTemplateEntry {
	uint           dstBinding; 
	uint           dstArrayElement; 
	uint           descriptorCount; 
	DescriptorType descriptorType; 
	usz            offset; 
	usz            stride; 
}

struct DescriptorUpdateTemplateCreateInfo {
	StructureType                       sType; 
	void*                               pNext; 
	DescriptorUpdateTemplateCreateFlags flags; 
	uint                                descriptorUpdateEntryCount; 
	DescriptorUpdateTemplateEntry*      pDescriptorUpdateEntries; 
	DescriptorUpdateTemplateType        templateType; 
	DescriptorSetLayout                 descriptorSetLayout; 
	PipelineBindPoint                   pipelineBindPoint; 
	PipelineLayout                      pipelineLayout; 
	uint                                set; 
}

struct ExternalMemoryProperties {
	ExternalMemoryFeatureFlags    externalMemoryFeatures; 
	ExternalMemoryHandleTypeFlags exportFromImportedHandleTypes; 
	ExternalMemoryHandleTypeFlags compatibleHandleTypes; 
}

struct PhysicalDeviceExternalImageFormatInfo {
	StructureType                 sType; 
	void*                         pNext; 
	ExternalMemoryHandleTypeFlags handleType; 
}

struct ExternalImageFormatProperties {
	StructureType            sType; 
	void*                    pNext; 
	ExternalMemoryProperties externalMemoryProperties; 
}

struct PhysicalDeviceExternalBufferInfo {
	StructureType                 sType; 
	void*                         pNext; 
	BufferCreateFlags             flags; 
	BufferUsageFlags              usage; 
	ExternalMemoryHandleTypeFlags handleType; 
}

struct ExternalBufferProperties {
	StructureType            sType; 
	void*                    pNext; 
	ExternalMemoryProperties externalMemoryProperties; 
}

struct PhysicalDeviceIDProperties {
	StructureType   sType; 
	void*           pNext; 
	char[UUID_SIZE] deviceUUID; 
	char[UUID_SIZE] driverUUID; 
	char[LUID_SIZE] deviceLUID; 
	uint            deviceNodeMask; 
	uint            deviceLUIDValid; 
}

struct ExternalMemoryImageCreateInfo {
	StructureType                 sType; 
	void*                         pNext; 
	ExternalMemoryHandleTypeFlags handleTypes; 
}

struct ExternalMemoryBufferCreateInfo {
	StructureType                 sType; 
	void*                         pNext; 
	ExternalMemoryHandleTypeFlags handleTypes; 
}

struct ExportMemoryAllocateInfo {
	StructureType                 sType; 
	void*                         pNext; 
	ExternalMemoryHandleTypeFlags handleTypes; 
}

struct PhysicalDeviceExternalFenceInfo {
	StructureType                sType; 
	void*                        pNext; 
	ExternalFenceHandleTypeFlags handleType; 
}

struct ExternalFenceProperties {
	StructureType                sType; 
	void*                        pNext; 
	ExternalFenceHandleTypeFlags exportFromImportedHandleTypes; 
	ExternalFenceHandleTypeFlags compatibleHandleTypes; 
	ExternalFenceFeatureFlags    externalFenceFeatures; 
}

struct ExportFenceCreateInfo {
	StructureType                sType; 
	void*                        pNext; 
	ExternalFenceHandleTypeFlags handleTypes; 
}

struct ExportSemaphoreCreateInfo {
	StructureType                    sType; 
	void*                            pNext; 
	ExternalSemaphoreHandleTypeFlags handleTypes; 
}

struct PhysicalDeviceExternalSemaphoreInfo {
	StructureType                    sType; 
	void*                            pNext; 
	ExternalSemaphoreHandleTypeFlags handleType; 
}

struct ExternalSemaphoreProperties {
	StructureType                    sType; 
	void*                            pNext; 
	ExternalSemaphoreHandleTypeFlags exportFromImportedHandleTypes; 
	ExternalSemaphoreHandleTypeFlags compatibleHandleTypes; 
	ExternalSemaphoreFeatureFlags    externalSemaphoreFeatures; 
}

struct PhysicalDeviceMaintenance3Properties {
	StructureType sType; 
	void*         pNext; 
	uint          maxPerSetDescriptors; 
	DeviceSize    maxMemoryAllocationSize; 
}

struct DescriptorSetLayoutSupport {
	StructureType sType; 
	void*         pNext; 
	uint          supported; 
}

struct PhysicalDeviceShaderDrawParametersFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          shaderDrawParameters; 
}

struct PhysicalDeviceVulkan11Features {
	StructureType sType; 
	void*         pNext; 
	uint          storageBuffer16BitAccess; 
	uint          uniformAndStorageBuffer16BitAccess; 
	uint          storagePushConstant16; 
	uint          storageInputOutput16; 
	uint          multiview; 
	uint          multiviewGeometryShader; 
	uint          multiviewTessellationShader; 
	uint          variablePointersStorageBuffer; 
	uint          variablePointers; 
	uint          protectedMemory; 
	uint          samplerYcbcrConversion; 
	uint          shaderDrawParameters; 
}

struct PhysicalDeviceVulkan11Properties {
	StructureType         sType; 
	void*                 pNext; 
	char[UUID_SIZE]       deviceUUID; 
	char[UUID_SIZE]       driverUUID; 
	char[LUID_SIZE]       deviceLUID; 
	uint                  deviceNodeMask; 
	uint                  deviceLUIDValid; 
	uint                  subgroupSize; 
	ShaderStageFlags      subgroupSupportedStages; 
	SubgroupFeatureFlags  subgroupSupportedOperations; 
	uint                  subgroupQuadOperationsInAllStages; 
	PointClippingBehavior pointClippingBehavior; 
	uint                  maxMultiviewViewCount; 
	uint                  maxMultiviewInstanceIndex; 
	uint                  protectedNoFault; 
	uint                  maxPerSetDescriptors; 
	DeviceSize            maxMemoryAllocationSize; 
}

struct PhysicalDeviceVulkan12Features {
	StructureType sType; 
	void*         pNext; 
	uint          samplerMirrorClampToEdge; 
	uint          drawIndirectCount; 
	uint          storageBuffer8BitAccess; 
	uint          uniformAndStorageBuffer8BitAccess; 
	uint          storagePushConstant8; 
	uint          shaderBufferInt64Atomics; 
	uint          shaderSharedInt64Atomics; 
	uint          shaderFloat16; 
	uint          shaderInt8; 
	uint          descriptorIndexing; 
	uint          shaderInputAttachmentArrayDynamicIndexing; 
	uint          shaderUniformTexelBufferArrayDynamicIndexing; 
	uint          shaderStorageTexelBufferArrayDynamicIndexing; 
	uint          shaderUniformBufferArrayNonUniformIndexing; 
	uint          shaderSampledImageArrayNonUniformIndexing; 
	uint          shaderStorageBufferArrayNonUniformIndexing; 
	uint          shaderStorageImageArrayNonUniformIndexing; 
	uint          shaderInputAttachmentArrayNonUniformIndexing; 
	uint          shaderUniformTexelBufferArrayNonUniformIndexing; 
	uint          shaderStorageTexelBufferArrayNonUniformIndexing; 
	uint          descriptorBindingUniformBufferUpdateAfterBind; 
	uint          descriptorBindingSampledImageUpdateAfterBind; 
	uint          descriptorBindingStorageImageUpdateAfterBind; 
	uint          descriptorBindingStorageBufferUpdateAfterBind; 
	uint          descriptorBindingUniformTexelBufferUpdateAfterBind; 
	uint          descriptorBindingStorageTexelBufferUpdateAfterBind; 
	uint          descriptorBindingUpdateUnusedWhilePending; 
	uint          descriptorBindingPartiallyBound; 
	uint          descriptorBindingVariableDescriptorCount; 
	uint          runtimeDescriptorArray; 
	uint          samplerFilterMinmax; 
	uint          scalarBlockLayout; 
	uint          imagelessFramebuffer; 
	uint          uniformBufferStandardLayout; 
	uint          shaderSubgroupExtendedTypes; 
	uint          separateDepthStencilLayouts; 
	uint          hostQueryReset; 
	uint          timelineSemaphore; 
	uint          bufferDeviceAddress; 
	uint          bufferDeviceAddressCaptureReplay; 
	uint          bufferDeviceAddressMultiDevice; 
	uint          vulkanMemoryModel; 
	uint          vulkanMemoryModelDeviceScope; 
	uint          vulkanMemoryModelAvailabilityVisibilityChains; 
	uint          shaderOutputViewportIndex; 
	uint          shaderOutputLayer; 
	uint          subgroupBroadcastDynamicId; 
}

struct ConformanceVersion {
	char major; 
	char minor; 
	char subminor; 
	char patch; 
}

struct PhysicalDeviceVulkan12Properties {
	StructureType                   sType; 
	void*                           pNext; 
	DriverId                        driverID; 
	ichar[MAX_DRIVER_NAME_SIZE]     driverName; 
	ichar[MAX_DRIVER_INFO_SIZE]     driverInfo; 
	ConformanceVersion              conformanceVersion; 
	ShaderFloatControlsIndependence denormBehaviorIndependence; 
	ShaderFloatControlsIndependence roundingModeIndependence; 
	uint                            shaderSignedZeroInfNanPreserveFloat16; 
	uint                            shaderSignedZeroInfNanPreserveFloat32; 
	uint                            shaderSignedZeroInfNanPreserveFloat64; 
	uint                            shaderDenormPreserveFloat16; 
	uint                            shaderDenormPreserveFloat32; 
	uint                            shaderDenormPreserveFloat64; 
	uint                            shaderDenormFlushToZeroFloat16; 
	uint                            shaderDenormFlushToZeroFloat32; 
	uint                            shaderDenormFlushToZeroFloat64; 
	uint                            shaderRoundingModeRTEFloat16; 
	uint                            shaderRoundingModeRTEFloat32; 
	uint                            shaderRoundingModeRTEFloat64; 
	uint                            shaderRoundingModeRTZFloat16; 
	uint                            shaderRoundingModeRTZFloat32; 
	uint                            shaderRoundingModeRTZFloat64; 
	uint                            maxUpdateAfterBindDescriptorsInAllPools; 
	uint                            shaderUniformBufferArrayNonUniformIndexingNative; 
	uint                            shaderSampledImageArrayNonUniformIndexingNative; 
	uint                            shaderStorageBufferArrayNonUniformIndexingNative; 
	uint                            shaderStorageImageArrayNonUniformIndexingNative; 
	uint                            shaderInputAttachmentArrayNonUniformIndexingNative; 
	uint                            robustBufferAccessUpdateAfterBind; 
	uint                            quadDivergentImplicitLod; 
	uint                            maxPerStageDescriptorUpdateAfterBindSamplers; 
	uint                            maxPerStageDescriptorUpdateAfterBindUniformBuffers; 
	uint                            maxPerStageDescriptorUpdateAfterBindStorageBuffers; 
	uint                            maxPerStageDescriptorUpdateAfterBindSampledImages; 
	uint                            maxPerStageDescriptorUpdateAfterBindStorageImages; 
	uint                            maxPerStageDescriptorUpdateAfterBindInputAttachments; 
	uint                            maxPerStageUpdateAfterBindResources; 
	uint                            maxDescriptorSetUpdateAfterBindSamplers; 
	uint                            maxDescriptorSetUpdateAfterBindUniformBuffers; 
	uint                            maxDescriptorSetUpdateAfterBindUniformBuffersDynamic; 
	uint                            maxDescriptorSetUpdateAfterBindStorageBuffers; 
	uint                            maxDescriptorSetUpdateAfterBindStorageBuffersDynamic; 
	uint                            maxDescriptorSetUpdateAfterBindSampledImages; 
	uint                            maxDescriptorSetUpdateAfterBindStorageImages; 
	uint                            maxDescriptorSetUpdateAfterBindInputAttachments; 
	ResolveModeFlags                supportedDepthResolveModes; 
	ResolveModeFlags                supportedStencilResolveModes; 
	uint                            independentResolveNone; 
	uint                            independentResolve; 
	uint                            filterMinmaxSingleComponentFormats; 
	uint                            filterMinmaxImageComponentMapping; 
	ulong                           maxTimelineSemaphoreValueDifference; 
	SampleCountFlags                framebufferIntegerColorSampleCounts; 
}

struct ImageFormatListCreateInfo {
	StructureType sType; 
	void*         pNext; 
	uint          viewFormatCount; 
	Format*       pViewFormats; 
}

struct AttachmentDescription2 {
	StructureType              sType; 
	void*                      pNext; 
	AttachmentDescriptionFlags flags; 
	Format                     format; 
	SampleCountFlags           samples; 
	AttachmentLoadOp           loadOp; 
	AttachmentStoreOp          storeOp; 
	AttachmentLoadOp           stencilLoadOp; 
	AttachmentStoreOp          stencilStoreOp; 
	ImageLayout                initialLayout; 
	ImageLayout                finalLayout; 
}

struct AttachmentReference2 {
	StructureType    sType; 
	void*            pNext; 
	uint             attachment; 
	ImageLayout      layout; 
	ImageAspectFlags aspectMask; 
}

struct SubpassDescription2 {
	StructureType           sType; 
	void*                   pNext; 
	SubpassDescriptionFlags flags; 
	PipelineBindPoint       pipelineBindPoint; 
	uint                    viewMask; 
	uint                    inputAttachmentCount; 
	AttachmentReference2*   pInputAttachments; 
	uint                    colorAttachmentCount; 
	AttachmentReference2*   pColorAttachments; 
	AttachmentReference2*   pResolveAttachments; 
	AttachmentReference2*   pDepthStencilAttachment; 
	uint                    preserveAttachmentCount; 
	uint*                   pPreserveAttachments; 
}

struct SubpassDependency2 {
	StructureType      sType; 
	void*              pNext; 
	uint               srcSubpass; 
	uint               dstSubpass; 
	PipelineStageFlags srcStageMask; 
	PipelineStageFlags dstStageMask; 
	AccessFlags        srcAccessMask; 
	AccessFlags        dstAccessMask; 
	DependencyFlags    dependencyFlags; 
	int                viewOffset; 
}

struct RenderPassCreateInfo2 {
	StructureType           sType; 
	void*                   pNext; 
	RenderPassCreateFlags   flags; 
	uint                    attachmentCount; 
	AttachmentDescription2* pAttachments; 
	uint                    subpassCount; 
	SubpassDescription2*    pSubpasses; 
	uint                    dependencyCount; 
	SubpassDependency2*     pDependencies; 
	uint                    correlatedViewMaskCount; 
	uint*                   pCorrelatedViewMasks; 
}

struct SubpassBeginInfo {
	StructureType   sType; 
	void*           pNext; 
	SubpassContents contents; 
}

struct SubpassEndInfo {
	StructureType sType; 
	void*         pNext; 
}

struct PhysicalDevice8BitStorageFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          storageBuffer8BitAccess; 
	uint          uniformAndStorageBuffer8BitAccess; 
	uint          storagePushConstant8; 
}

struct PhysicalDeviceDriverProperties {
	StructureType               sType; 
	void*                       pNext; 
	DriverId                    driverID; 
	ichar[MAX_DRIVER_NAME_SIZE] driverName; 
	ichar[MAX_DRIVER_INFO_SIZE] driverInfo; 
	ConformanceVersion          conformanceVersion; 
}

struct PhysicalDeviceShaderAtomicInt64Features {
	StructureType sType; 
	void*         pNext; 
	uint          shaderBufferInt64Atomics; 
	uint          shaderSharedInt64Atomics; 
}

struct PhysicalDeviceShaderFloat16Int8Features {
	StructureType sType; 
	void*         pNext; 
	uint          shaderFloat16; 
	uint          shaderInt8; 
}

struct PhysicalDeviceFloatControlsProperties {
	StructureType                   sType; 
	void*                           pNext; 
	ShaderFloatControlsIndependence denormBehaviorIndependence; 
	ShaderFloatControlsIndependence roundingModeIndependence; 
	uint                            shaderSignedZeroInfNanPreserveFloat16; 
	uint                            shaderSignedZeroInfNanPreserveFloat32; 
	uint                            shaderSignedZeroInfNanPreserveFloat64; 
	uint                            shaderDenormPreserveFloat16; 
	uint                            shaderDenormPreserveFloat32; 
	uint                            shaderDenormPreserveFloat64; 
	uint                            shaderDenormFlushToZeroFloat16; 
	uint                            shaderDenormFlushToZeroFloat32; 
	uint                            shaderDenormFlushToZeroFloat64; 
	uint                            shaderRoundingModeRTEFloat16; 
	uint                            shaderRoundingModeRTEFloat32; 
	uint                            shaderRoundingModeRTEFloat64; 
	uint                            shaderRoundingModeRTZFloat16; 
	uint                            shaderRoundingModeRTZFloat32; 
	uint                            shaderRoundingModeRTZFloat64; 
}

struct DescriptorSetLayoutBindingFlagsCreateInfo {
	StructureType           sType; 
	void*                   pNext; 
	uint                    bindingCount; 
	DescriptorBindingFlags* pBindingFlags; 
}

struct PhysicalDeviceDescriptorIndexingFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          shaderInputAttachmentArrayDynamicIndexing; 
	uint          shaderUniformTexelBufferArrayDynamicIndexing; 
	uint          shaderStorageTexelBufferArrayDynamicIndexing; 
	uint          shaderUniformBufferArrayNonUniformIndexing; 
	uint          shaderSampledImageArrayNonUniformIndexing; 
	uint          shaderStorageBufferArrayNonUniformIndexing; 
	uint          shaderStorageImageArrayNonUniformIndexing; 
	uint          shaderInputAttachmentArrayNonUniformIndexing; 
	uint          shaderUniformTexelBufferArrayNonUniformIndexing; 
	uint          shaderStorageTexelBufferArrayNonUniformIndexing; 
	uint          descriptorBindingUniformBufferUpdateAfterBind; 
	uint          descriptorBindingSampledImageUpdateAfterBind; 
	uint          descriptorBindingStorageImageUpdateAfterBind; 
	uint          descriptorBindingStorageBufferUpdateAfterBind; 
	uint          descriptorBindingUniformTexelBufferUpdateAfterBind; 
	uint          descriptorBindingStorageTexelBufferUpdateAfterBind; 
	uint          descriptorBindingUpdateUnusedWhilePending; 
	uint          descriptorBindingPartiallyBound; 
	uint          descriptorBindingVariableDescriptorCount; 
	uint          runtimeDescriptorArray; 
}

struct PhysicalDeviceDescriptorIndexingProperties {
	StructureType sType; 
	void*         pNext; 
	uint          maxUpdateAfterBindDescriptorsInAllPools; 
	uint          shaderUniformBufferArrayNonUniformIndexingNative; 
	uint          shaderSampledImageArrayNonUniformIndexingNative; 
	uint          shaderStorageBufferArrayNonUniformIndexingNative; 
	uint          shaderStorageImageArrayNonUniformIndexingNative; 
	uint          shaderInputAttachmentArrayNonUniformIndexingNative; 
	uint          robustBufferAccessUpdateAfterBind; 
	uint          quadDivergentImplicitLod; 
	uint          maxPerStageDescriptorUpdateAfterBindSamplers; 
	uint          maxPerStageDescriptorUpdateAfterBindUniformBuffers; 
	uint          maxPerStageDescriptorUpdateAfterBindStorageBuffers; 
	uint          maxPerStageDescriptorUpdateAfterBindSampledImages; 
	uint          maxPerStageDescriptorUpdateAfterBindStorageImages; 
	uint          maxPerStageDescriptorUpdateAfterBindInputAttachments; 
	uint          maxPerStageUpdateAfterBindResources; 
	uint          maxDescriptorSetUpdateAfterBindSamplers; 
	uint          maxDescriptorSetUpdateAfterBindUniformBuffers; 
	uint          maxDescriptorSetUpdateAfterBindUniformBuffersDynamic; 
	uint          maxDescriptorSetUpdateAfterBindStorageBuffers; 
	uint          maxDescriptorSetUpdateAfterBindStorageBuffersDynamic; 
	uint          maxDescriptorSetUpdateAfterBindSampledImages; 
	uint          maxDescriptorSetUpdateAfterBindStorageImages; 
	uint          maxDescriptorSetUpdateAfterBindInputAttachments; 
}

struct DescriptorSetVariableDescriptorCountAllocateInfo {
	StructureType sType; 
	void*         pNext; 
	uint          descriptorSetCount; 
	uint*         pDescriptorCounts; 
}

struct DescriptorSetVariableDescriptorCountLayoutSupport {
	StructureType sType; 
	void*         pNext; 
	uint          maxVariableDescriptorCount; 
}

struct SubpassDescriptionDepthStencilResolve {
	StructureType         sType; 
	void*                 pNext; 
	ResolveModeFlags      depthResolveMode; 
	ResolveModeFlags      stencilResolveMode; 
	AttachmentReference2* pDepthStencilResolveAttachment; 
}

struct PhysicalDeviceDepthStencilResolveProperties {
	StructureType    sType; 
	void*            pNext; 
	ResolveModeFlags supportedDepthResolveModes; 
	ResolveModeFlags supportedStencilResolveModes; 
	uint             independentResolveNone; 
	uint             independentResolve; 
}

struct PhysicalDeviceScalarBlockLayoutFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          scalarBlockLayout; 
}

struct ImageStencilUsageCreateInfo {
	StructureType   sType; 
	void*           pNext; 
	ImageUsageFlags stencilUsage; 
}

struct SamplerReductionModeCreateInfo {
	StructureType        sType; 
	void*                pNext; 
	SamplerReductionMode reductionMode; 
}

struct PhysicalDeviceSamplerFilterMinmaxProperties {
	StructureType sType; 
	void*         pNext; 
	uint          filterMinmaxSingleComponentFormats; 
	uint          filterMinmaxImageComponentMapping; 
}

struct PhysicalDeviceVulkanMemoryModelFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          vulkanMemoryModel; 
	uint          vulkanMemoryModelDeviceScope; 
	uint          vulkanMemoryModelAvailabilityVisibilityChains; 
}

struct PhysicalDeviceImagelessFramebufferFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          imagelessFramebuffer; 
}

struct FramebufferAttachmentImageInfo {
	StructureType    sType; 
	void*            pNext; 
	ImageCreateFlags flags; 
	ImageUsageFlags  usage; 
	uint             width; 
	uint             height; 
	uint             layerCount; 
	uint             viewFormatCount; 
	Format*          pViewFormats; 
}

struct FramebufferAttachmentsCreateInfo {
	StructureType                   sType; 
	void*                           pNext; 
	uint                            attachmentImageInfoCount; 
	FramebufferAttachmentImageInfo* pAttachmentImageInfos; 
}

struct RenderPassAttachmentBeginInfo {
	StructureType sType; 
	void*         pNext; 
	uint          attachmentCount; 
	ImageView*    pAttachments; 
}

struct PhysicalDeviceUniformBufferStandardLayoutFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          uniformBufferStandardLayout; 
}

struct PhysicalDeviceShaderSubgroupExtendedTypesFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          shaderSubgroupExtendedTypes; 
}

struct PhysicalDeviceSeparateDepthStencilLayoutsFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          separateDepthStencilLayouts; 
}

struct AttachmentReferenceStencilLayout {
	StructureType sType; 
	void*         pNext; 
	ImageLayout   stencilLayout; 
}

struct AttachmentDescriptionStencilLayout {
	StructureType sType; 
	void*         pNext; 
	ImageLayout   stencilInitialLayout; 
	ImageLayout   stencilFinalLayout; 
}

struct PhysicalDeviceHostQueryResetFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          hostQueryReset; 
}

struct PhysicalDeviceTimelineSemaphoreFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          timelineSemaphore; 
}

struct PhysicalDeviceTimelineSemaphoreProperties {
	StructureType sType; 
	void*         pNext; 
	ulong         maxTimelineSemaphoreValueDifference; 
}

struct SemaphoreTypeCreateInfo {
	StructureType sType; 
	void*         pNext; 
	SemaphoreType semaphoreType; 
	ulong         initialValue; 
}

struct TimelineSemaphoreSubmitInfo {
	StructureType sType; 
	void*         pNext; 
	uint          waitSemaphoreValueCount; 
	ulong*        pWaitSemaphoreValues; 
	uint          signalSemaphoreValueCount; 
	ulong*        pSignalSemaphoreValues; 
}

struct SemaphoreWaitInfo {
	StructureType      sType; 
	void*              pNext; 
	SemaphoreWaitFlags flags; 
	uint               semaphoreCount; 
	Semaphore*         pSemaphores; 
	ulong*             pValues; 
}

struct SemaphoreSignalInfo {
	StructureType sType; 
	void*         pNext; 
	Semaphore     semaphore; 
	ulong         value; 
}

struct PhysicalDeviceBufferDeviceAddressFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          bufferDeviceAddress; 
	uint          bufferDeviceAddressCaptureReplay; 
	uint          bufferDeviceAddressMultiDevice; 
}

struct BufferDeviceAddressInfo {
	StructureType sType; 
	void*         pNext; 
	Buffer        buffer; 
}

struct BufferOpaqueCaptureAddressCreateInfo {
	StructureType sType; 
	void*         pNext; 
	ulong         opaqueCaptureAddress; 
}

struct MemoryOpaqueCaptureAddressAllocateInfo {
	StructureType sType; 
	void*         pNext; 
	ulong         opaqueCaptureAddress; 
}

struct DeviceMemoryOpaqueCaptureAddressInfo {
	StructureType sType; 
	void*         pNext; 
	DeviceMemory  memory; 
}

struct PhysicalDeviceVulkan13Features {
	StructureType sType; 
	void*         pNext; 
	uint          robustImageAccess; 
	uint          inlineUniformBlock; 
	uint          descriptorBindingInlineUniformBlockUpdateAfterBind; 
	uint          pipelineCreationCacheControl; 
	uint          privateData; 
	uint          shaderDemoteToHelperInvocation; 
	uint          shaderTerminateInvocation; 
	uint          subgroupSizeControl; 
	uint          computeFullSubgroups; 
	uint          synchronization2; 
	uint          textureCompressionASTC_HDR; 
	uint          shaderZeroInitializeWorkgroupMemory; 
	uint          dynamicRendering; 
	uint          shaderIntegerDotProduct; 
	uint          maintenance4; 
}

struct PhysicalDeviceVulkan13Properties {
	StructureType    sType; 
	void*            pNext; 
	uint             minSubgroupSize; 
	uint             maxSubgroupSize; 
	uint             maxComputeWorkgroupSubgroups; 
	ShaderStageFlags requiredSubgroupSizeStages; 
	uint             maxInlineUniformBlockSize; 
	uint             maxPerStageDescriptorInlineUniformBlocks; 
	uint             maxPerStageDescriptorUpdateAfterBindInlineUniformBlocks; 
	uint             maxDescriptorSetInlineUniformBlocks; 
	uint             maxDescriptorSetUpdateAfterBindInlineUniformBlocks; 
	uint             maxInlineUniformTotalSize; 
	uint             integerDotProduct8BitUnsignedAccelerated; 
	uint             integerDotProduct8BitSignedAccelerated; 
	uint             integerDotProduct8BitMixedSignednessAccelerated; 
	uint             integerDotProduct4x8BitPackedUnsignedAccelerated; 
	uint             integerDotProduct4x8BitPackedSignedAccelerated; 
	uint             integerDotProduct4x8BitPackedMixedSignednessAccelerated; 
	uint             integerDotProduct16BitUnsignedAccelerated; 
	uint             integerDotProduct16BitSignedAccelerated; 
	uint             integerDotProduct16BitMixedSignednessAccelerated; 
	uint             integerDotProduct32BitUnsignedAccelerated; 
	uint             integerDotProduct32BitSignedAccelerated; 
	uint             integerDotProduct32BitMixedSignednessAccelerated; 
	uint             integerDotProduct64BitUnsignedAccelerated; 
	uint             integerDotProduct64BitSignedAccelerated; 
	uint             integerDotProduct64BitMixedSignednessAccelerated; 
	uint             integerDotProductAccumulatingSaturating8BitUnsignedAccelerated; 
	uint             integerDotProductAccumulatingSaturating8BitSignedAccelerated; 
	uint             integerDotProductAccumulatingSaturating8BitMixedSignednessAccelerated; 
	uint             integerDotProductAccumulatingSaturating4x8BitPackedUnsignedAccelerated; 
	uint             integerDotProductAccumulatingSaturating4x8BitPackedSignedAccelerated; 
	uint             integerDotProductAccumulatingSaturating4x8BitPackedMixedSignednessAccelerated; 
	uint             integerDotProductAccumulatingSaturating16BitUnsignedAccelerated; 
	uint             integerDotProductAccumulatingSaturating16BitSignedAccelerated; 
	uint             integerDotProductAccumulatingSaturating16BitMixedSignednessAccelerated; 
	uint             integerDotProductAccumulatingSaturating32BitUnsignedAccelerated; 
	uint             integerDotProductAccumulatingSaturating32BitSignedAccelerated; 
	uint             integerDotProductAccumulatingSaturating32BitMixedSignednessAccelerated; 
	uint             integerDotProductAccumulatingSaturating64BitUnsignedAccelerated; 
	uint             integerDotProductAccumulatingSaturating64BitSignedAccelerated; 
	uint             integerDotProductAccumulatingSaturating64BitMixedSignednessAccelerated; 
	DeviceSize       storageTexelBufferOffsetAlignmentBytes; 
	uint             storageTexelBufferOffsetSingleTexelAlignment; 
	DeviceSize       uniformTexelBufferOffsetAlignmentBytes; 
	uint             uniformTexelBufferOffsetSingleTexelAlignment; 
	DeviceSize       maxBufferSize; 
}

struct PipelineCreationFeedback {
	PipelineCreationFeedbackFlags flags; 
	ulong                         duration; 
}

struct PipelineCreationFeedbackCreateInfo {
	StructureType             sType; 
	void*                     pNext; 
	PipelineCreationFeedback* pPipelineCreationFeedback; 
	uint                      pipelineStageCreationFeedbackCount; 
	PipelineCreationFeedback* pPipelineStageCreationFeedbacks; 
}

struct PhysicalDeviceShaderTerminateInvocationFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          shaderTerminateInvocation; 
}

struct PhysicalDeviceToolProperties {
	StructureType                  sType; 
	void*                          pNext; 
	ichar[MAX_EXTENSION_NAME_SIZE] name; 
	ichar[MAX_EXTENSION_NAME_SIZE] version; 
	ToolPurposeFlags               purposes; 
	ichar[MAX_DESCRIPTION_SIZE]    description; 
	ichar[MAX_EXTENSION_NAME_SIZE] layer; 
}

struct PhysicalDeviceShaderDemoteToHelperInvocationFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          shaderDemoteToHelperInvocation; 
}

struct PhysicalDevicePrivateDataFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          privateData; 
}

struct DevicePrivateDataCreateInfo {
	StructureType sType; 
	void*         pNext; 
	uint          privateDataSlotRequestCount; 
}

struct PrivateDataSlotCreateInfo {
	StructureType              sType; 
	void*                      pNext; 
	PrivateDataSlotCreateFlags flags; 
}

struct PhysicalDevicePipelineCreationCacheControlFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          pipelineCreationCacheControl; 
}

struct MemoryBarrier2 {
	StructureType       sType; 
	void*               pNext; 
	PipelineStageFlags2 srcStageMask; 
	AccessFlags2        srcAccessMask; 
	PipelineStageFlags2 dstStageMask; 
	AccessFlags2        dstAccessMask; 
}

struct BufferMemoryBarrier2 {
	StructureType       sType; 
	void*               pNext; 
	PipelineStageFlags2 srcStageMask; 
	AccessFlags2        srcAccessMask; 
	PipelineStageFlags2 dstStageMask; 
	AccessFlags2        dstAccessMask; 
	uint                srcQueueFamilyIndex; 
	uint                dstQueueFamilyIndex; 
	Buffer              buffer; 
	DeviceSize          offset; 
	DeviceSize          size; 
}

struct ImageMemoryBarrier2 {
	StructureType         sType; 
	void*                 pNext; 
	PipelineStageFlags2   srcStageMask; 
	AccessFlags2          srcAccessMask; 
	PipelineStageFlags2   dstStageMask; 
	AccessFlags2          dstAccessMask; 
	ImageLayout           oldLayout; 
	ImageLayout           newLayout; 
	uint                  srcQueueFamilyIndex; 
	uint                  dstQueueFamilyIndex; 
	Image                 image; 
	ImageSubresourceRange subresourceRange; 
}

struct DependencyInfo {
	StructureType         sType; 
	void*                 pNext; 
	DependencyFlags       dependencyFlags; 
	uint                  memoryBarrierCount; 
	MemoryBarrier2*       pMemoryBarriers; 
	uint                  bufferMemoryBarrierCount; 
	BufferMemoryBarrier2* pBufferMemoryBarriers; 
	uint                  imageMemoryBarrierCount; 
	ImageMemoryBarrier2*  pImageMemoryBarriers; 
}

struct SemaphoreSubmitInfo {
	StructureType       sType; 
	void*               pNext; 
	Semaphore           semaphore; 
	ulong               value; 
	PipelineStageFlags2 stageMask; 
	uint                deviceIndex; 
}

struct CommandBufferSubmitInfo {
	StructureType sType; 
	void*         pNext; 
	CommandBuffer commandBuffer; 
	uint          deviceMask; 
}

struct SubmitInfo2 {
	StructureType            sType; 
	void*                    pNext; 
	SubmitFlags              flags; 
	uint                     waitSemaphoreInfoCount; 
	SemaphoreSubmitInfo*     pWaitSemaphoreInfos; 
	uint                     commandBufferInfoCount; 
	CommandBufferSubmitInfo* pCommandBufferInfos; 
	uint                     signalSemaphoreInfoCount; 
	SemaphoreSubmitInfo*     pSignalSemaphoreInfos; 
}

struct PhysicalDeviceSynchronization2Features {
	StructureType sType; 
	void*         pNext; 
	uint          synchronization2; 
}

struct PhysicalDeviceZeroInitializeWorkgroupMemoryFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          shaderZeroInitializeWorkgroupMemory; 
}

struct PhysicalDeviceImageRobustnessFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          robustImageAccess; 
}

struct BufferCopy2 {
	StructureType sType; 
	void*         pNext; 
	DeviceSize    srcOffset; 
	DeviceSize    dstOffset; 
	DeviceSize    size; 
}

struct CopyBufferInfo2 {
	StructureType sType; 
	void*         pNext; 
	Buffer        srcBuffer; 
	Buffer        dstBuffer; 
	uint          regionCount; 
	BufferCopy2*  pRegions; 
}

struct ImageCopy2 {
	StructureType          sType; 
	void*                  pNext; 
	ImageSubresourceLayers srcSubresource; 
	Offset3D               srcOffset; 
	ImageSubresourceLayers dstSubresource; 
	Offset3D               dstOffset; 
	Extent3D               extent; 
}

struct CopyImageInfo2 {
	StructureType sType; 
	void*         pNext; 
	Image         srcImage; 
	ImageLayout   srcImageLayout; 
	Image         dstImage; 
	ImageLayout   dstImageLayout; 
	uint          regionCount; 
	ImageCopy2*   pRegions; 
}

struct BufferImageCopy2 {
	StructureType          sType; 
	void*                  pNext; 
	DeviceSize             bufferOffset; 
	uint                   bufferRowLength; 
	uint                   bufferImageHeight; 
	ImageSubresourceLayers imageSubresource; 
	Offset3D               imageOffset; 
	Extent3D               imageExtent; 
}

struct CopyBufferToImageInfo2 {
	StructureType     sType; 
	void*             pNext; 
	Buffer            srcBuffer; 
	Image             dstImage; 
	ImageLayout       dstImageLayout; 
	uint              regionCount; 
	BufferImageCopy2* pRegions; 
}

struct CopyImageToBufferInfo2 {
	StructureType     sType; 
	void*             pNext; 
	Image             srcImage; 
	ImageLayout       srcImageLayout; 
	Buffer            dstBuffer; 
	uint              regionCount; 
	BufferImageCopy2* pRegions; 
}

struct ImageBlit2 {
	StructureType          sType; 
	void*                  pNext; 
	ImageSubresourceLayers srcSubresource; 
	Offset3D[2]            srcOffsets; 
	ImageSubresourceLayers dstSubresource; 
	Offset3D[2]            dstOffsets; 
}

struct BlitImageInfo2 {
	StructureType sType; 
	void*         pNext; 
	Image         srcImage; 
	ImageLayout   srcImageLayout; 
	Image         dstImage; 
	ImageLayout   dstImageLayout; 
	uint          regionCount; 
	ImageBlit2*   pRegions; 
	Filter        filter; 
}

struct ImageResolve2 {
	StructureType          sType; 
	void*                  pNext; 
	ImageSubresourceLayers srcSubresource; 
	Offset3D               srcOffset; 
	ImageSubresourceLayers dstSubresource; 
	Offset3D               dstOffset; 
	Extent3D               extent; 
}

struct ResolveImageInfo2 {
	StructureType  sType; 
	void*          pNext; 
	Image          srcImage; 
	ImageLayout    srcImageLayout; 
	Image          dstImage; 
	ImageLayout    dstImageLayout; 
	uint           regionCount; 
	ImageResolve2* pRegions; 
}

struct PhysicalDeviceSubgroupSizeControlFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          subgroupSizeControl; 
	uint          computeFullSubgroups; 
}

struct PhysicalDeviceSubgroupSizeControlProperties {
	StructureType    sType; 
	void*            pNext; 
	uint             minSubgroupSize; 
	uint             maxSubgroupSize; 
	uint             maxComputeWorkgroupSubgroups; 
	ShaderStageFlags requiredSubgroupSizeStages; 
}

struct PipelineShaderStageRequiredSubgroupSizeCreateInfo {
	StructureType sType; 
	void*         pNext; 
	uint          requiredSubgroupSize; 
}

struct PhysicalDeviceInlineUniformBlockFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          inlineUniformBlock; 
	uint          descriptorBindingInlineUniformBlockUpdateAfterBind; 
}

struct PhysicalDeviceInlineUniformBlockProperties {
	StructureType sType; 
	void*         pNext; 
	uint          maxInlineUniformBlockSize; 
	uint          maxPerStageDescriptorInlineUniformBlocks; 
	uint          maxPerStageDescriptorUpdateAfterBindInlineUniformBlocks; 
	uint          maxDescriptorSetInlineUniformBlocks; 
	uint          maxDescriptorSetUpdateAfterBindInlineUniformBlocks; 
}

struct WriteDescriptorSetInlineUniformBlock {
	StructureType sType; 
	void*         pNext; 
	uint          dataSize; 
	void*         pData; 
}

struct DescriptorPoolInlineUniformBlockCreateInfo {
	StructureType sType; 
	void*         pNext; 
	uint          maxInlineUniformBlockBindings; 
}

struct PhysicalDeviceTextureCompressionASTCHDRFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          textureCompressionASTC_HDR; 
}

struct RenderingAttachmentInfo {
	StructureType     sType; 
	void*             pNext; 
	ImageView         imageView; 
	ImageLayout       imageLayout; 
	ResolveModeFlags  resolveMode; 
	ImageView         resolveImageView; 
	ImageLayout       resolveImageLayout; 
	AttachmentLoadOp  loadOp; 
	AttachmentStoreOp storeOp; 
	ClearValue        clearValue; 
}

struct RenderingInfo {
	StructureType            sType; 
	void*                    pNext; 
	RenderingFlags           flags; 
	Rect2D                   renderArea; 
	uint                     layerCount; 
	uint                     viewMask; 
	uint                     colorAttachmentCount; 
	RenderingAttachmentInfo* pColorAttachments; 
	RenderingAttachmentInfo* pDepthAttachment; 
	RenderingAttachmentInfo* pStencilAttachment; 
}

struct PipelineRenderingCreateInfo {
	StructureType sType; 
	void*         pNext; 
	uint          viewMask; 
	uint          colorAttachmentCount; 
	Format*       pColorAttachmentFormats; 
	Format        depthAttachmentFormat; 
	Format        stencilAttachmentFormat; 
}

struct PhysicalDeviceDynamicRenderingFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          dynamicRendering; 
}

struct CommandBufferInheritanceRenderingInfo {
	StructureType    sType; 
	void*            pNext; 
	RenderingFlags   flags; 
	uint             viewMask; 
	uint             colorAttachmentCount; 
	Format*          pColorAttachmentFormats; 
	Format           depthAttachmentFormat; 
	Format           stencilAttachmentFormat; 
	SampleCountFlags rasterizationSamples; 
}

struct PhysicalDeviceShaderIntegerDotProductFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          shaderIntegerDotProduct; 
}

struct PhysicalDeviceShaderIntegerDotProductProperties {
	StructureType sType; 
	void*         pNext; 
	uint          integerDotProduct8BitUnsignedAccelerated; 
	uint          integerDotProduct8BitSignedAccelerated; 
	uint          integerDotProduct8BitMixedSignednessAccelerated; 
	uint          integerDotProduct4x8BitPackedUnsignedAccelerated; 
	uint          integerDotProduct4x8BitPackedSignedAccelerated; 
	uint          integerDotProduct4x8BitPackedMixedSignednessAccelerated; 
	uint          integerDotProduct16BitUnsignedAccelerated; 
	uint          integerDotProduct16BitSignedAccelerated; 
	uint          integerDotProduct16BitMixedSignednessAccelerated; 
	uint          integerDotProduct32BitUnsignedAccelerated; 
	uint          integerDotProduct32BitSignedAccelerated; 
	uint          integerDotProduct32BitMixedSignednessAccelerated; 
	uint          integerDotProduct64BitUnsignedAccelerated; 
	uint          integerDotProduct64BitSignedAccelerated; 
	uint          integerDotProduct64BitMixedSignednessAccelerated; 
	uint          integerDotProductAccumulatingSaturating8BitUnsignedAccelerated; 
	uint          integerDotProductAccumulatingSaturating8BitSignedAccelerated; 
	uint          integerDotProductAccumulatingSaturating8BitMixedSignednessAccelerated; 
	uint          integerDotProductAccumulatingSaturating4x8BitPackedUnsignedAccelerated; 
	uint          integerDotProductAccumulatingSaturating4x8BitPackedSignedAccelerated; 
	uint          integerDotProductAccumulatingSaturating4x8BitPackedMixedSignednessAccelerated; 
	uint          integerDotProductAccumulatingSaturating16BitUnsignedAccelerated; 
	uint          integerDotProductAccumulatingSaturating16BitSignedAccelerated; 
	uint          integerDotProductAccumulatingSaturating16BitMixedSignednessAccelerated; 
	uint          integerDotProductAccumulatingSaturating32BitUnsignedAccelerated; 
	uint          integerDotProductAccumulatingSaturating32BitSignedAccelerated; 
	uint          integerDotProductAccumulatingSaturating32BitMixedSignednessAccelerated; 
	uint          integerDotProductAccumulatingSaturating64BitUnsignedAccelerated; 
	uint          integerDotProductAccumulatingSaturating64BitSignedAccelerated; 
	uint          integerDotProductAccumulatingSaturating64BitMixedSignednessAccelerated; 
}

struct PhysicalDeviceTexelBufferAlignmentProperties {
	StructureType sType; 
	void*         pNext; 
	DeviceSize    storageTexelBufferOffsetAlignmentBytes; 
	uint          storageTexelBufferOffsetSingleTexelAlignment; 
	DeviceSize    uniformTexelBufferOffsetAlignmentBytes; 
	uint          uniformTexelBufferOffsetSingleTexelAlignment; 
}

struct FormatProperties3 {
	StructureType       sType; 
	void*               pNext; 
	FormatFeatureFlags2 linearTilingFeatures; 
	FormatFeatureFlags2 optimalTilingFeatures; 
	FormatFeatureFlags2 bufferFeatures; 
}

struct PhysicalDeviceMaintenance4Features {
	StructureType sType; 
	void*         pNext; 
	uint          maintenance4; 
}

struct PhysicalDeviceMaintenance4Properties {
	StructureType sType; 
	void*         pNext; 
	DeviceSize    maxBufferSize; 
}

struct DeviceBufferMemoryRequirements {
	StructureType     sType; 
	void*             pNext; 
	BufferCreateInfo* pCreateInfo; 
}

struct DeviceImageMemoryRequirements {
	StructureType    sType; 
	void*            pNext; 
	ImageCreateInfo* pCreateInfo; 
	ImageAspectFlags planeAspect; 
}

struct PhysicalDeviceVulkan14Features {
	StructureType sType; 
	void*         pNext; 
	uint          globalPriorityQuery; 
	uint          shaderSubgroupRotate; 
	uint          shaderSubgroupRotateClustered; 
	uint          shaderFloatControls2; 
	uint          shaderExpectAssume; 
	uint          rectangularLines; 
	uint          bresenhamLines; 
	uint          smoothLines; 
	uint          stippledRectangularLines; 
	uint          stippledBresenhamLines; 
	uint          stippledSmoothLines; 
	uint          vertexAttributeInstanceRateDivisor; 
	uint          vertexAttributeInstanceRateZeroDivisor; 
	uint          indexTypeUint8; 
	uint          dynamicRenderingLocalRead; 
	uint          maintenance5; 
	uint          maintenance6; 
	uint          pipelineProtectedAccess; 
	uint          pipelineRobustness; 
	uint          hostImageCopy; 
	uint          pushDescriptor; 
}

struct PhysicalDeviceVulkan14Properties {
	StructureType                    sType; 
	void*                            pNext; 
	uint                             lineSubPixelPrecisionBits; 
	uint                             maxVertexAttribDivisor; 
	uint                             supportsNonZeroFirstInstance; 
	uint                             maxPushDescriptors; 
	uint                             dynamicRenderingLocalReadDepthStencilAttachments; 
	uint                             dynamicRenderingLocalReadMultisampledAttachments; 
	uint                             earlyFragmentMultisampleCoverageAfterSampleCounting; 
	uint                             earlyFragmentSampleMaskTestBeforeSampleCounting; 
	uint                             depthStencilSwizzleOneSupport; 
	uint                             polygonModePointSize; 
	uint                             nonStrictSinglePixelWideLinesUseParallelogram; 
	uint                             nonStrictWideLinesUseParallelogram; 
	uint                             blockTexelViewCompatibleMultipleLayers; 
	uint                             maxCombinedImageSamplerDescriptorCount; 
	uint                             fragmentShadingRateClampCombinerInputs; 
	PipelineRobustnessBufferBehavior defaultRobustnessStorageBuffers; 
	PipelineRobustnessBufferBehavior defaultRobustnessUniformBuffers; 
	PipelineRobustnessBufferBehavior defaultRobustnessVertexInputs; 
	PipelineRobustnessImageBehavior  defaultRobustnessImages; 
	uint                             copySrcLayoutCount; 
	ImageLayout*                     pCopySrcLayouts; 
	uint                             copyDstLayoutCount; 
	ImageLayout*                     pCopyDstLayouts; 
	char[UUID_SIZE]                  optimalTilingLayoutUUID; 
	uint                             identicalMemoryTypeRequirements; 
}

struct DeviceQueueGlobalPriorityCreateInfo {
	StructureType       sType; 
	void*               pNext; 
	QueueGlobalPriority globalPriority; 
}

struct PhysicalDeviceGlobalPriorityQueryFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          globalPriorityQuery; 
}

struct QueueFamilyGlobalPriorityProperties {
	StructureType                                 sType; 
	void*                                         pNext; 
	uint                                          priorityCount; 
	QueueGlobalPriority[MAX_GLOBAL_PRIORITY_SIZE] priorities; 
}

struct PhysicalDeviceShaderSubgroupRotateFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          shaderSubgroupRotate; 
	uint          shaderSubgroupRotateClustered; 
}

struct PhysicalDeviceShaderFloatControls2Features {
	StructureType sType; 
	void*         pNext; 
	uint          shaderFloatControls2; 
}

struct PhysicalDeviceShaderExpectAssumeFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          shaderExpectAssume; 
}

struct PhysicalDeviceLineRasterizationFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          rectangularLines; 
	uint          bresenhamLines; 
	uint          smoothLines; 
	uint          stippledRectangularLines; 
	uint          stippledBresenhamLines; 
	uint          stippledSmoothLines; 
}

struct PhysicalDeviceLineRasterizationProperties {
	StructureType sType; 
	void*         pNext; 
	uint          lineSubPixelPrecisionBits; 
}

struct PipelineRasterizationLineStateCreateInfo {
	StructureType         sType; 
	void*                 pNext; 
	LineRasterizationMode lineRasterizationMode; 
	uint                  stippledLineEnable; 
	uint                  lineStippleFactor; 
	ushort                lineStipplePattern; 
}

struct PhysicalDeviceVertexAttributeDivisorProperties {
	StructureType sType; 
	void*         pNext; 
	uint          maxVertexAttribDivisor; 
	uint          supportsNonZeroFirstInstance; 
}

struct VertexInputBindingDivisorDescription {
	uint binding; 
	uint divisor; 
}

struct PipelineVertexInputDivisorStateCreateInfo {
	StructureType                         sType; 
	void*                                 pNext; 
	uint                                  vertexBindingDivisorCount; 
	VertexInputBindingDivisorDescription* pVertexBindingDivisors; 
}

struct PhysicalDeviceVertexAttributeDivisorFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          vertexAttributeInstanceRateDivisor; 
	uint          vertexAttributeInstanceRateZeroDivisor; 
}

struct PhysicalDeviceIndexTypeUint8Features {
	StructureType sType; 
	void*         pNext; 
	uint          indexTypeUint8; 
}

struct MemoryMapInfo {
	StructureType  sType; 
	void*          pNext; 
	MemoryMapFlags flags; 
	DeviceMemory   memory; 
	DeviceSize     offset; 
	DeviceSize     size; 
}

struct MemoryUnmapInfo {
	StructureType    sType; 
	void*            pNext; 
	MemoryUnmapFlags flags; 
	DeviceMemory     memory; 
}

struct PhysicalDeviceMaintenance5Features {
	StructureType sType; 
	void*         pNext; 
	uint          maintenance5; 
}

struct PhysicalDeviceMaintenance5Properties {
	StructureType sType; 
	void*         pNext; 
	uint          earlyFragmentMultisampleCoverageAfterSampleCounting; 
	uint          earlyFragmentSampleMaskTestBeforeSampleCounting; 
	uint          depthStencilSwizzleOneSupport; 
	uint          polygonModePointSize; 
	uint          nonStrictSinglePixelWideLinesUseParallelogram; 
	uint          nonStrictWideLinesUseParallelogram; 
}

struct RenderingAreaInfo {
	StructureType sType; 
	void*         pNext; 
	uint          viewMask; 
	uint          colorAttachmentCount; 
	Format*       pColorAttachmentFormats; 
	Format        depthAttachmentFormat; 
	Format        stencilAttachmentFormat; 
}

struct ImageSubresource2 {
	StructureType    sType; 
	void*            pNext; 
	ImageSubresource imageSubresource; 
}

struct DeviceImageSubresourceInfo {
	StructureType      sType; 
	void*              pNext; 
	ImageCreateInfo*   pCreateInfo; 
	ImageSubresource2* pSubresource; 
}

struct SubresourceLayout2 {
	StructureType     sType; 
	void*             pNext; 
	SubresourceLayout subresourceLayout; 
}

struct PipelineCreateFlags2CreateInfo {
	StructureType        sType; 
	void*                pNext; 
	PipelineCreateFlags2 flags; 
}

struct BufferUsageFlags2CreateInfo {
	StructureType     sType; 
	void*             pNext; 
	BufferUsageFlags2 usage; 
}

struct PhysicalDevicePushDescriptorProperties {
	StructureType sType; 
	void*         pNext; 
	uint          maxPushDescriptors; 
}

struct PhysicalDeviceDynamicRenderingLocalReadFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          dynamicRenderingLocalRead; 
}

struct RenderingAttachmentLocationInfo {
	StructureType sType; 
	void*         pNext; 
	uint          colorAttachmentCount; 
	uint*         pColorAttachmentLocations; 
}

struct RenderingInputAttachmentIndexInfo {
	StructureType sType; 
	void*         pNext; 
	uint          colorAttachmentCount; 
	uint*         pColorAttachmentInputIndices; 
	uint*         pDepthInputAttachmentIndex; 
	uint*         pStencilInputAttachmentIndex; 
}

struct PhysicalDeviceMaintenance6Features {
	StructureType sType; 
	void*         pNext; 
	uint          maintenance6; 
}

struct PhysicalDeviceMaintenance6Properties {
	StructureType sType; 
	void*         pNext; 
	uint          blockTexelViewCompatibleMultipleLayers; 
	uint          maxCombinedImageSamplerDescriptorCount; 
	uint          fragmentShadingRateClampCombinerInputs; 
}

struct BindMemoryStatus {
	StructureType sType; 
	void*         pNext; 
	Result*       pResult; 
}

struct BindDescriptorSetsInfo {
	StructureType    sType; 
	void*            pNext; 
	ShaderStageFlags stageFlags; 
	PipelineLayout   layout; 
	uint             firstSet; 
	uint             descriptorSetCount; 
	DescriptorSet*   pDescriptorSets; 
	uint             dynamicOffsetCount; 
	uint*            pDynamicOffsets; 
}

struct PushConstantsInfo {
	StructureType    sType; 
	void*            pNext; 
	PipelineLayout   layout; 
	ShaderStageFlags stageFlags; 
	uint             offset; 
	uint             size; 
	void*            pValues; 
}

struct PushDescriptorSetInfo {
	StructureType       sType; 
	void*               pNext; 
	ShaderStageFlags    stageFlags; 
	PipelineLayout      layout; 
	uint                set; 
	uint                descriptorWriteCount; 
	WriteDescriptorSet* pDescriptorWrites; 
}

struct PushDescriptorSetWithTemplateInfo {
	StructureType            sType; 
	void*                    pNext; 
	DescriptorUpdateTemplate descriptorUpdateTemplate; 
	PipelineLayout           layout; 
	uint                     set; 
	void*                    pData; 
}

struct PhysicalDevicePipelineProtectedAccessFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          pipelineProtectedAccess; 
}

struct PhysicalDevicePipelineRobustnessFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          pipelineRobustness; 
}

struct PhysicalDevicePipelineRobustnessProperties {
	StructureType                    sType; 
	void*                            pNext; 
	PipelineRobustnessBufferBehavior defaultRobustnessStorageBuffers; 
	PipelineRobustnessBufferBehavior defaultRobustnessUniformBuffers; 
	PipelineRobustnessBufferBehavior defaultRobustnessVertexInputs; 
	PipelineRobustnessImageBehavior  defaultRobustnessImages; 
}

struct PipelineRobustnessCreateInfo {
	StructureType                    sType; 
	void*                            pNext; 
	PipelineRobustnessBufferBehavior storageBuffers; 
	PipelineRobustnessBufferBehavior uniformBuffers; 
	PipelineRobustnessBufferBehavior vertexInputs; 
	PipelineRobustnessImageBehavior  images; 
}

struct PhysicalDeviceHostImageCopyFeatures {
	StructureType sType; 
	void*         pNext; 
	uint          hostImageCopy; 
}

struct PhysicalDeviceHostImageCopyProperties {
	StructureType   sType; 
	void*           pNext; 
	uint            copySrcLayoutCount; 
	ImageLayout*    pCopySrcLayouts; 
	uint            copyDstLayoutCount; 
	ImageLayout*    pCopyDstLayouts; 
	char[UUID_SIZE] optimalTilingLayoutUUID; 
	uint            identicalMemoryTypeRequirements; 
}

struct MemoryToImageCopy {
	StructureType          sType; 
	void*                  pNext; 
	void*                  pHostPointer; 
	uint                   memoryRowLength; 
	uint                   memoryImageHeight; 
	ImageSubresourceLayers imageSubresource; 
	Offset3D               imageOffset; 
	Extent3D               imageExtent; 
}

struct ImageToMemoryCopy {
	StructureType          sType; 
	void*                  pNext; 
	void*                  pHostPointer; 
	uint                   memoryRowLength; 
	uint                   memoryImageHeight; 
	ImageSubresourceLayers imageSubresource; 
	Offset3D               imageOffset; 
	Extent3D               imageExtent; 
}

struct CopyMemoryToImageInfo {
	StructureType      sType; 
	void*              pNext; 
	HostImageCopyFlags flags; 
	Image              dstImage; 
	ImageLayout        dstImageLayout; 
	uint               regionCount; 
	MemoryToImageCopy* pRegions; 
}

struct CopyImageToMemoryInfo {
	StructureType      sType; 
	void*              pNext; 
	HostImageCopyFlags flags; 
	Image              srcImage; 
	ImageLayout        srcImageLayout; 
	uint               regionCount; 
	ImageToMemoryCopy* pRegions; 
}

struct CopyImageToImageInfo {
	StructureType      sType; 
	void*              pNext; 
	HostImageCopyFlags flags; 
	Image              srcImage; 
	ImageLayout        srcImageLayout; 
	Image              dstImage; 
	ImageLayout        dstImageLayout; 
	uint               regionCount; 
	ImageCopy2*        pRegions; 
}

struct HostImageLayoutTransitionInfo {
	StructureType         sType; 
	void*                 pNext; 
	Image                 image; 
	ImageLayout           oldLayout; 
	ImageLayout           newLayout; 
	ImageSubresourceRange subresourceRange; 
}

struct SubresourceHostMemcpySize {
	StructureType sType; 
	void*         pNext; 
	DeviceSize    size; 
}

struct HostImageCopyDevicePerformanceQuery {
	StructureType sType; 
	void*         pNext; 
	uint          optimalDeviceAccess; 
	uint          identicalMemoryLayout; 
}

struct SurfaceCapabilitiesKHR {
	uint                     minImageCount; 
	uint                     maxImageCount; 
	Extent2D                 currentExtent; 
	Extent2D                 minImageExtent; 
	Extent2D                 maxImageExtent; 
	uint                     maxImageArrayLayers; 
	SurfaceTransformFlagsKHR supportedTransforms; 
	SurfaceTransformFlagsKHR currentTransform; 
	CompositeAlphaFlagsKHR   supportedCompositeAlpha; 
	ImageUsageFlags          supportedUsageFlags; 
}

struct SurfaceFormatKHR {
	Format        format; 
	ColorSpaceKHR colorSpace; 
}

struct SwapchainCreateInfoKHR {
	StructureType            sType; 
	void*                    pNext; 
	SwapchainCreateFlagsKHR  flags; 
	SurfaceKHR               surface; 
	uint                     minImageCount; 
	Format                   imageFormat; 
	ColorSpaceKHR            imageColorSpace; 
	Extent2D                 imageExtent; 
	uint                     imageArrayLayers; 
	ImageUsageFlags          imageUsage; 
	SharingMode              imageSharingMode; 
	uint                     queueFamilyIndexCount; 
	uint*                    pQueueFamilyIndices; 
	SurfaceTransformFlagsKHR preTransform; 
	CompositeAlphaFlagsKHR   compositeAlpha; 
	PresentModeKHR           presentMode; 
	uint                     clipped; 
	SwapchainKHR             oldSwapchain; 
}

struct PresentInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          waitSemaphoreCount; 
	Semaphore*    pWaitSemaphores; 
	uint          swapchainCount; 
	SwapchainKHR* pSwapchains; 
	uint*         pImageIndices; 
	Result*       pResults; 
}

struct ImageSwapchainCreateInfoKHR {
	StructureType sType; 
	void*         pNext; 
	SwapchainKHR  swapchain; 
}

struct BindImageMemorySwapchainInfoKHR {
	StructureType sType; 
	void*         pNext; 
	SwapchainKHR  swapchain; 
	uint          imageIndex; 
}

struct AcquireNextImageInfoKHR {
	StructureType sType; 
	void*         pNext; 
	SwapchainKHR  swapchain; 
	ulong         timeout; 
	Semaphore     semaphore; 
	Fence         fence; 
	uint          deviceMask; 
}

struct DeviceGroupPresentCapabilitiesKHR {
	StructureType                  sType; 
	void*                          pNext; 
	uint[MAX_DEVICE_GROUP_SIZE]    presentMask; 
	DeviceGroupPresentModeFlagsKHR modes; 
}

struct DeviceGroupPresentInfoKHR {
	StructureType                  sType; 
	void*                          pNext; 
	uint                           swapchainCount; 
	uint*                          pDeviceMasks; 
	DeviceGroupPresentModeFlagsKHR mode; 
}

struct DeviceGroupSwapchainCreateInfoKHR {
	StructureType                  sType; 
	void*                          pNext; 
	DeviceGroupPresentModeFlagsKHR modes; 
}

struct DisplayModeParametersKHR {
	Extent2D visibleRegion; 
	uint     refreshRate; 
}

struct DisplayModeCreateInfoKHR {
	StructureType             sType; 
	void*                     pNext; 
	DisplayModeCreateFlagsKHR flags; 
	DisplayModeParametersKHR  parameters; 
}

struct DisplayModePropertiesKHR {
	DisplayModeKHR           displayMode; 
	DisplayModeParametersKHR parameters; 
}

struct DisplayPlaneCapabilitiesKHR {
	DisplayPlaneAlphaFlagsKHR supportedAlpha; 
	Offset2D                  minSrcPosition; 
	Offset2D                  maxSrcPosition; 
	Extent2D                  minSrcExtent; 
	Extent2D                  maxSrcExtent; 
	Offset2D                  minDstPosition; 
	Offset2D                  maxDstPosition; 
	Extent2D                  minDstExtent; 
	Extent2D                  maxDstExtent; 
}

struct DisplayPlanePropertiesKHR {
	DisplayKHR currentDisplay; 
	uint       currentStackIndex; 
}

struct DisplayPropertiesKHR {
	DisplayKHR               display; 
	ZString                  displayName; 
	Extent2D                 physicalDimensions; 
	Extent2D                 physicalResolution; 
	SurfaceTransformFlagsKHR supportedTransforms; 
	uint                     planeReorderPossible; 
	uint                     persistentContent; 
}

struct DisplaySurfaceCreateInfoKHR {
	StructureType                sType; 
	void*                        pNext; 
	DisplaySurfaceCreateFlagsKHR flags; 
	DisplayModeKHR               displayMode; 
	uint                         planeIndex; 
	uint                         planeStackIndex; 
	SurfaceTransformFlagsKHR     transform; 
	float                        globalAlpha; 
	DisplayPlaneAlphaFlagsKHR    alphaMode; 
	Extent2D                     imageExtent; 
}

struct DisplayPresentInfoKHR {
	StructureType sType; 
	void*         pNext; 
	Rect2D        srcRect; 
	Rect2D        dstRect; 
	uint          persistent; 
}

struct QueueFamilyQueryResultStatusPropertiesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          queryResultStatusSupport; 
}

struct QueueFamilyVideoPropertiesKHR {
	StructureType               sType; 
	void*                       pNext; 
	VideoCodecOperationFlagsKHR videoCodecOperations; 
}

struct VideoProfileInfoKHR {
	StructureType                  sType; 
	void*                          pNext; 
	VideoCodecOperationFlagsKHR    videoCodecOperation; 
	VideoChromaSubsamplingFlagsKHR chromaSubsampling; 
	VideoComponentBitDepthFlagsKHR lumaBitDepth; 
	VideoComponentBitDepthFlagsKHR chromaBitDepth; 
}

struct VideoProfileListInfoKHR {
	StructureType        sType; 
	void*                pNext; 
	uint                 profileCount; 
	VideoProfileInfoKHR* pProfiles; 
}

struct VideoCapabilitiesKHR {
	StructureType           sType; 
	void*                   pNext; 
	VideoCapabilityFlagsKHR flags; 
	DeviceSize              minBitstreamBufferOffsetAlignment; 
	DeviceSize              minBitstreamBufferSizeAlignment; 
	Extent2D                pictureAccessGranularity; 
	Extent2D                minCodedExtent; 
	Extent2D                maxCodedExtent; 
	uint                    maxDpbSlots; 
	uint                    maxActiveReferencePictures; 
	ExtensionProperties     stdHeaderVersion; 
}

struct PhysicalDeviceVideoFormatInfoKHR {
	StructureType   sType; 
	void*           pNext; 
	ImageUsageFlags imageUsage; 
}

struct VideoFormatPropertiesKHR {
	StructureType    sType; 
	void*            pNext; 
	Format           format; 
	ComponentMapping componentMapping; 
	ImageCreateFlags imageCreateFlags; 
	ImageType        imageType; 
	ImageTiling      imageTiling; 
	ImageUsageFlags  imageUsageFlags; 
}

struct VideoPictureResourceInfoKHR {
	StructureType sType; 
	void*         pNext; 
	Offset2D      codedOffset; 
	Extent2D      codedExtent; 
	uint          baseArrayLayer; 
	ImageView     imageViewBinding; 
}

struct VideoReferenceSlotInfoKHR {
	StructureType                sType; 
	void*                        pNext; 
	int                          slotIndex; 
	VideoPictureResourceInfoKHR* pPictureResource; 
}

struct VideoSessionMemoryRequirementsKHR {
	StructureType      sType; 
	void*              pNext; 
	uint               memoryBindIndex; 
	MemoryRequirements memoryRequirements; 
}

struct BindVideoSessionMemoryInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          memoryBindIndex; 
	DeviceMemory  memory; 
	DeviceSize    memoryOffset; 
	DeviceSize    memorySize; 
}

struct VideoSessionCreateInfoKHR {
	StructureType              sType; 
	void*                      pNext; 
	uint                       queueFamilyIndex; 
	VideoSessionCreateFlagsKHR flags; 
	VideoProfileInfoKHR*       pVideoProfile; 
	Format                     pictureFormat; 
	Extent2D                   maxCodedExtent; 
	Format                     referencePictureFormat; 
	uint                       maxDpbSlots; 
	uint                       maxActiveReferencePictures; 
	ExtensionProperties*       pStdHeaderVersion; 
}

struct VideoSessionParametersCreateInfoKHR {
	StructureType                        sType; 
	void*                                pNext; 
	VideoSessionParametersCreateFlagsKHR flags; 
	VideoSessionParametersKHR            videoSessionParametersTemplate; 
	VideoSessionKHR                      videoSession; 
}

struct VideoSessionParametersUpdateInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          updateSequenceCount; 
}

struct VideoBeginCodingInfoKHR {
	StructureType              sType; 
	void*                      pNext; 
	VideoBeginCodingFlagsKHR   flags; 
	VideoSessionKHR            videoSession; 
	VideoSessionParametersKHR  videoSessionParameters; 
	uint                       referenceSlotCount; 
	VideoReferenceSlotInfoKHR* pReferenceSlots; 
}

struct VideoEndCodingInfoKHR {
	StructureType          sType; 
	void*                  pNext; 
	VideoEndCodingFlagsKHR flags; 
}

struct VideoCodingControlInfoKHR {
	StructureType              sType; 
	void*                      pNext; 
	VideoCodingControlFlagsKHR flags; 
}

struct VideoDecodeCapabilitiesKHR {
	StructureType                 sType; 
	void*                         pNext; 
	VideoDecodeCapabilityFlagsKHR flags; 
}

struct VideoDecodeUsageInfoKHR {
	StructureType            sType; 
	void*                    pNext; 
	VideoDecodeUsageFlagsKHR videoUsageHints; 
}

struct VideoDecodeInfoKHR {
	StructureType               sType; 
	void*                       pNext; 
	VideoDecodeFlagsKHR         flags; 
	Buffer                      srcBuffer; 
	DeviceSize                  srcBufferOffset; 
	DeviceSize                  srcBufferRange; 
	VideoPictureResourceInfoKHR dstPictureResource; 
	VideoReferenceSlotInfoKHR*  pSetupReferenceSlot; 
	uint                        referenceSlotCount; 
	VideoReferenceSlotInfoKHR*  pReferenceSlots; 
}

struct VideoEncodeH264CapabilitiesKHR {
	StructureType                     sType; 
	void*                             pNext; 
	VideoEncodeH264CapabilityFlagsKHR flags; 
	VideoH264LevelIdc                 maxLevelIdc; 
	uint                              maxSliceCount; 
	uint                              maxPPictureL0ReferenceCount; 
	uint                              maxBPictureL0ReferenceCount; 
	uint                              maxL1ReferenceCount; 
	uint                              maxTemporalLayerCount; 
	uint                              expectDyadicTemporalLayerPattern; 
	int                               minQp; 
	int                               maxQp; 
	uint                              prefersGopRemainingFrames; 
	uint                              requiresGopRemainingFrames; 
	VideoEncodeH264StdFlagsKHR        stdSyntaxFlags; 
}

struct VideoEncodeH264QpKHR {
	int qpI; 
	int qpP; 
	int qpB; 
}

struct VideoEncodeH264QualityLevelPropertiesKHR {
	StructureType                      sType; 
	void*                              pNext; 
	VideoEncodeH264RateControlFlagsKHR preferredRateControlFlags; 
	uint                               preferredGopFrameCount; 
	uint                               preferredIdrPeriod; 
	uint                               preferredConsecutiveBFrameCount; 
	uint                               preferredTemporalLayerCount; 
	VideoEncodeH264QpKHR               preferredConstantQp; 
	uint                               preferredMaxL0ReferenceCount; 
	uint                               preferredMaxL1ReferenceCount; 
	uint                               preferredStdEntropyCodingModeFlag; 
}

struct VideoEncodeH264SessionCreateInfoKHR {
	StructureType     sType; 
	void*             pNext; 
	uint              useMaxLevelIdc; 
	VideoH264LevelIdc maxLevelIdc; 
}

struct VideoEncodeH264SessionParametersAddInfoKHR {
	StructureType                  sType; 
	void*                          pNext; 
	uint                           stdSPSCount; 
	VideoH264SequenceParameterSet* pStdSPSs; 
	uint                           stdPPSCount; 
	VideoH264PictureParameterSet*  pStdPPSs; 
}

struct VideoEncodeH264SessionParametersCreateInfoKHR {
	StructureType                               sType; 
	void*                                       pNext; 
	uint                                        maxStdSPSCount; 
	uint                                        maxStdPPSCount; 
	VideoEncodeH264SessionParametersAddInfoKHR* pParametersAddInfo; 
}

struct VideoEncodeH264SessionParametersGetInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          writeStdSPS; 
	uint          writeStdPPS; 
	uint          stdSPSId; 
	uint          stdPPSId; 
}

struct VideoEncodeH264SessionParametersFeedbackInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          hasStdSPSOverrides; 
	uint          hasStdPPSOverrides; 
}

struct VideoEncodeH264NaluSliceInfoKHR {
	StructureType               sType; 
	void*                       pNext; 
	int                         constantQp; 
	VideoEncodeH264SliceHeader* pStdSliceHeader; 
}

struct VideoEncodeH264PictureInfoKHR {
	StructureType                    sType; 
	void*                            pNext; 
	uint                             naluSliceEntryCount; 
	VideoEncodeH264NaluSliceInfoKHR* pNaluSliceEntries; 
	VideoEncodeH264PictureInfo*      pStdPictureInfo; 
	uint                             generatePrefixNalu; 
}

struct VideoEncodeH264DpbSlotInfoKHR {
	StructureType                 sType; 
	void*                         pNext; 
	VideoEncodeH264ReferenceInfo* pStdReferenceInfo; 
}

struct VideoEncodeH264ProfileInfoKHR {
	StructureType       sType; 
	void*               pNext; 
	VideoH264ProfileIdc stdProfileIdc; 
}

struct VideoEncodeH264RateControlInfoKHR {
	StructureType                      sType; 
	void*                              pNext; 
	VideoEncodeH264RateControlFlagsKHR flags; 
	uint                               gopFrameCount; 
	uint                               idrPeriod; 
	uint                               consecutiveBFrameCount; 
	uint                               temporalLayerCount; 
}

struct VideoEncodeH264FrameSizeKHR {
	uint frameISize; 
	uint framePSize; 
	uint frameBSize; 
}

struct VideoEncodeH264RateControlLayerInfoKHR {
	StructureType               sType; 
	void*                       pNext; 
	uint                        useMinQp; 
	VideoEncodeH264QpKHR        minQp; 
	uint                        useMaxQp; 
	VideoEncodeH264QpKHR        maxQp; 
	uint                        useMaxFrameSize; 
	VideoEncodeH264FrameSizeKHR maxFrameSize; 
}

struct VideoEncodeH264GopRemainingFrameInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          useGopRemainingFrames; 
	uint          gopRemainingI; 
	uint          gopRemainingP; 
	uint          gopRemainingB; 
}

struct VideoEncodeH265CapabilitiesKHR {
	StructureType                             sType; 
	void*                                     pNext; 
	VideoEncodeH265CapabilityFlagsKHR         flags; 
	VideoH265LevelIdc                         maxLevelIdc; 
	uint                                      maxSliceSegmentCount; 
	Extent2D                                  maxTiles; 
	VideoEncodeH265CtbSizeFlagsKHR            ctbSizes; 
	VideoEncodeH265TransformBlockSizeFlagsKHR transformBlockSizes; 
	uint                                      maxPPictureL0ReferenceCount; 
	uint                                      maxBPictureL0ReferenceCount; 
	uint                                      maxL1ReferenceCount; 
	uint                                      maxSubLayerCount; 
	uint                                      expectDyadicTemporalSubLayerPattern; 
	int                                       minQp; 
	int                                       maxQp; 
	uint                                      prefersGopRemainingFrames; 
	uint                                      requiresGopRemainingFrames; 
	VideoEncodeH265StdFlagsKHR                stdSyntaxFlags; 
}

struct VideoEncodeH265SessionCreateInfoKHR {
	StructureType     sType; 
	void*             pNext; 
	uint              useMaxLevelIdc; 
	VideoH265LevelIdc maxLevelIdc; 
}

struct VideoEncodeH265QpKHR {
	int qpI; 
	int qpP; 
	int qpB; 
}

struct VideoEncodeH265QualityLevelPropertiesKHR {
	StructureType                      sType; 
	void*                              pNext; 
	VideoEncodeH265RateControlFlagsKHR preferredRateControlFlags; 
	uint                               preferredGopFrameCount; 
	uint                               preferredIdrPeriod; 
	uint                               preferredConsecutiveBFrameCount; 
	uint                               preferredSubLayerCount; 
	VideoEncodeH265QpKHR               preferredConstantQp; 
	uint                               preferredMaxL0ReferenceCount; 
	uint                               preferredMaxL1ReferenceCount; 
}

struct VideoEncodeH265SessionParametersAddInfoKHR {
	StructureType                  sType; 
	void*                          pNext; 
	uint                           stdVPSCount; 
	VideoH265VideoParameterSet*    pStdVPSs; 
	uint                           stdSPSCount; 
	VideoH265SequenceParameterSet* pStdSPSs; 
	uint                           stdPPSCount; 
	VideoH265PictureParameterSet*  pStdPPSs; 
}

struct VideoEncodeH265SessionParametersCreateInfoKHR {
	StructureType                               sType; 
	void*                                       pNext; 
	uint                                        maxStdVPSCount; 
	uint                                        maxStdSPSCount; 
	uint                                        maxStdPPSCount; 
	VideoEncodeH265SessionParametersAddInfoKHR* pParametersAddInfo; 
}

struct VideoEncodeH265SessionParametersGetInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          writeStdVPS; 
	uint          writeStdSPS; 
	uint          writeStdPPS; 
	uint          stdVPSId; 
	uint          stdSPSId; 
	uint          stdPPSId; 
}

struct VideoEncodeH265SessionParametersFeedbackInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          hasStdVPSOverrides; 
	uint          hasStdSPSOverrides; 
	uint          hasStdPPSOverrides; 
}

struct VideoEncodeH265NaluSliceSegmentInfoKHR {
	StructureType                      sType; 
	void*                              pNext; 
	int                                constantQp; 
	VideoEncodeH265SliceSegmentHeader* pStdSliceSegmentHeader; 
}

struct VideoEncodeH265PictureInfoKHR {
	StructureType                           sType; 
	void*                                   pNext; 
	uint                                    naluSliceSegmentEntryCount; 
	VideoEncodeH265NaluSliceSegmentInfoKHR* pNaluSliceSegmentEntries; 
	VideoEncodeH265PictureInfo*             pStdPictureInfo; 
}

struct VideoEncodeH265DpbSlotInfoKHR {
	StructureType                 sType; 
	void*                         pNext; 
	VideoEncodeH265ReferenceInfo* pStdReferenceInfo; 
}

struct VideoEncodeH265ProfileInfoKHR {
	StructureType       sType; 
	void*               pNext; 
	VideoH265ProfileIdc stdProfileIdc; 
}

struct VideoEncodeH265RateControlInfoKHR {
	StructureType                      sType; 
	void*                              pNext; 
	VideoEncodeH265RateControlFlagsKHR flags; 
	uint                               gopFrameCount; 
	uint                               idrPeriod; 
	uint                               consecutiveBFrameCount; 
	uint                               subLayerCount; 
}

struct VideoEncodeH265FrameSizeKHR {
	uint frameISize; 
	uint framePSize; 
	uint frameBSize; 
}

struct VideoEncodeH265RateControlLayerInfoKHR {
	StructureType               sType; 
	void*                       pNext; 
	uint                        useMinQp; 
	VideoEncodeH265QpKHR        minQp; 
	uint                        useMaxQp; 
	VideoEncodeH265QpKHR        maxQp; 
	uint                        useMaxFrameSize; 
	VideoEncodeH265FrameSizeKHR maxFrameSize; 
}

struct VideoEncodeH265GopRemainingFrameInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          useGopRemainingFrames; 
	uint          gopRemainingI; 
	uint          gopRemainingP; 
	uint          gopRemainingB; 
}

struct VideoDecodeH264ProfileInfoKHR {
	StructureType                        sType; 
	void*                                pNext; 
	VideoH264ProfileIdc                  stdProfileIdc; 
	VideoDecodeH264PictureLayoutFlagsKHR pictureLayout; 
}

struct VideoDecodeH264CapabilitiesKHR {
	StructureType     sType; 
	void*             pNext; 
	VideoH264LevelIdc maxLevelIdc; 
	Offset2D          fieldOffsetGranularity; 
}

struct VideoDecodeH264SessionParametersAddInfoKHR {
	StructureType                  sType; 
	void*                          pNext; 
	uint                           stdSPSCount; 
	VideoH264SequenceParameterSet* pStdSPSs; 
	uint                           stdPPSCount; 
	VideoH264PictureParameterSet*  pStdPPSs; 
}

struct VideoDecodeH264SessionParametersCreateInfoKHR {
	StructureType                               sType; 
	void*                                       pNext; 
	uint                                        maxStdSPSCount; 
	uint                                        maxStdPPSCount; 
	VideoDecodeH264SessionParametersAddInfoKHR* pParametersAddInfo; 
}

struct VideoDecodeH264PictureInfoKHR {
	StructureType               sType; 
	void*                       pNext; 
	VideoDecodeH264PictureInfo* pStdPictureInfo; 
	uint                        sliceCount; 
	uint*                       pSliceOffsets; 
}

struct VideoDecodeH264DpbSlotInfoKHR {
	StructureType                 sType; 
	void*                         pNext; 
	VideoDecodeH264ReferenceInfo* pStdReferenceInfo; 
}

struct ImportMemoryFdInfoKHR {
	StructureType                 sType; 
	void*                         pNext; 
	ExternalMemoryHandleTypeFlags handleType; 
	CInt                          fd; 
}

struct MemoryFdPropertiesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          memoryTypeBits; 
}

struct MemoryGetFdInfoKHR {
	StructureType                 sType; 
	void*                         pNext; 
	DeviceMemory                  memory; 
	ExternalMemoryHandleTypeFlags handleType; 
}

struct ImportSemaphoreFdInfoKHR {
	StructureType                    sType; 
	void*                            pNext; 
	Semaphore                        semaphore; 
	SemaphoreImportFlags             flags; 
	ExternalSemaphoreHandleTypeFlags handleType; 
	CInt                             fd; 
}

struct SemaphoreGetFdInfoKHR {
	StructureType                    sType; 
	void*                            pNext; 
	Semaphore                        semaphore; 
	ExternalSemaphoreHandleTypeFlags handleType; 
}

struct RectLayerKHR {
	Offset2D offset; 
	Extent2D extent; 
	uint     layer; 
}

struct PresentRegionKHR {
	uint          rectangleCount; 
	RectLayerKHR* pRectangles; 
}

struct PresentRegionsKHR {
	StructureType     sType; 
	void*             pNext; 
	uint              swapchainCount; 
	PresentRegionKHR* pRegions; 
}

struct SharedPresentSurfaceCapabilitiesKHR {
	StructureType   sType; 
	void*           pNext; 
	ImageUsageFlags sharedPresentSupportedUsageFlags; 
}

struct ImportFenceFdInfoKHR {
	StructureType                sType; 
	void*                        pNext; 
	Fence                        fence; 
	FenceImportFlags             flags; 
	ExternalFenceHandleTypeFlags handleType; 
	CInt                         fd; 
}

struct FenceGetFdInfoKHR {
	StructureType                sType; 
	void*                        pNext; 
	Fence                        fence; 
	ExternalFenceHandleTypeFlags handleType; 
}

struct PhysicalDevicePerformanceQueryFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          performanceCounterQueryPools; 
	uint          performanceCounterMultipleQueryPools; 
}

struct PhysicalDevicePerformanceQueryPropertiesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          allowCommandBufferQueryCopies; 
}

struct PerformanceCounterKHR {
	StructureType                sType; 
	void*                        pNext; 
	PerformanceCounterUnitKHR    unit; 
	PerformanceCounterScopeKHR   scope; 
	PerformanceCounterStorageKHR storage; 
	char[UUID_SIZE]              uuid; 
}

struct PerformanceCounterDescriptionKHR {
	StructureType                         sType; 
	void*                                 pNext; 
	PerformanceCounterDescriptionFlagsKHR flags; 
	ichar[MAX_DESCRIPTION_SIZE]           name; 
	ichar[MAX_DESCRIPTION_SIZE]           category; 
	ichar[MAX_DESCRIPTION_SIZE]           description; 
}

struct QueryPoolPerformanceCreateInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          queueFamilyIndex; 
	uint          counterIndexCount; 
	uint*         pCounterIndices; 
}

union PerformanceCounterResultKHR {
	int    int32; 
	long   int64; 
	uint   uint32; 
	ulong  uint64; 
	float  float32; 
	double float64; 
}

struct AcquireProfilingLockInfoKHR {
	StructureType                sType; 
	void*                        pNext; 
	AcquireProfilingLockFlagsKHR flags; 
	ulong                        timeout; 
}

struct PerformanceQuerySubmitInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          counterPassIndex; 
}

struct PhysicalDeviceSurfaceInfo2KHR {
	StructureType sType; 
	void*         pNext; 
	SurfaceKHR    surface; 
}

struct SurfaceCapabilities2KHR {
	StructureType          sType; 
	void*                  pNext; 
	SurfaceCapabilitiesKHR surfaceCapabilities; 
}

struct SurfaceFormat2KHR {
	StructureType    sType; 
	void*            pNext; 
	SurfaceFormatKHR surfaceFormat; 
}

struct DisplayProperties2KHR {
	StructureType        sType; 
	void*                pNext; 
	DisplayPropertiesKHR displayProperties; 
}

struct DisplayPlaneProperties2KHR {
	StructureType             sType; 
	void*                     pNext; 
	DisplayPlanePropertiesKHR displayPlaneProperties; 
}

struct DisplayModeProperties2KHR {
	StructureType            sType; 
	void*                    pNext; 
	DisplayModePropertiesKHR displayModeProperties; 
}

struct DisplayPlaneInfo2KHR {
	StructureType  sType; 
	void*          pNext; 
	DisplayModeKHR mode; 
	uint           planeIndex; 
}

struct DisplayPlaneCapabilities2KHR {
	StructureType               sType; 
	void*                       pNext; 
	DisplayPlaneCapabilitiesKHR capabilities; 
}

struct PhysicalDeviceShaderClockFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          shaderSubgroupClock; 
	uint          shaderDeviceClock; 
}

struct VideoDecodeH265ProfileInfoKHR {
	StructureType       sType; 
	void*               pNext; 
	VideoH265ProfileIdc stdProfileIdc; 
}

struct VideoDecodeH265CapabilitiesKHR {
	StructureType     sType; 
	void*             pNext; 
	VideoH265LevelIdc maxLevelIdc; 
}

struct VideoDecodeH265SessionParametersAddInfoKHR {
	StructureType                  sType; 
	void*                          pNext; 
	uint                           stdVPSCount; 
	VideoH265VideoParameterSet*    pStdVPSs; 
	uint                           stdSPSCount; 
	VideoH265SequenceParameterSet* pStdSPSs; 
	uint                           stdPPSCount; 
	VideoH265PictureParameterSet*  pStdPPSs; 
}

struct VideoDecodeH265SessionParametersCreateInfoKHR {
	StructureType                               sType; 
	void*                                       pNext; 
	uint                                        maxStdVPSCount; 
	uint                                        maxStdSPSCount; 
	uint                                        maxStdPPSCount; 
	VideoDecodeH265SessionParametersAddInfoKHR* pParametersAddInfo; 
}

struct VideoDecodeH265PictureInfoKHR {
	StructureType               sType; 
	void*                       pNext; 
	VideoDecodeH265PictureInfo* pStdPictureInfo; 
	uint                        sliceSegmentCount; 
	uint*                       pSliceSegmentOffsets; 
}

struct VideoDecodeH265DpbSlotInfoKHR {
	StructureType                 sType; 
	void*                         pNext; 
	VideoDecodeH265ReferenceInfo* pStdReferenceInfo; 
}

struct FragmentShadingRateAttachmentInfoKHR {
	StructureType         sType; 
	void*                 pNext; 
	AttachmentReference2* pFragmentShadingRateAttachment; 
	Extent2D              shadingRateAttachmentTexelSize; 
}

struct PipelineFragmentShadingRateStateCreateInfoKHR {
	StructureType                       sType; 
	void*                               pNext; 
	Extent2D                            fragmentSize; 
	FragmentShadingRateCombinerOpKHR[2] combinerOps; 
}

struct PhysicalDeviceFragmentShadingRateFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          pipelineFragmentShadingRate; 
	uint          primitiveFragmentShadingRate; 
	uint          attachmentFragmentShadingRate; 
}

struct PhysicalDeviceFragmentShadingRatePropertiesKHR {
	StructureType    sType; 
	void*            pNext; 
	Extent2D         minFragmentShadingRateAttachmentTexelSize; 
	Extent2D         maxFragmentShadingRateAttachmentTexelSize; 
	uint             maxFragmentShadingRateAttachmentTexelSizeAspectRatio; 
	uint             primitiveFragmentShadingRateWithMultipleViewports; 
	uint             layeredShadingRateAttachments; 
	uint             fragmentShadingRateNonTrivialCombinerOps; 
	Extent2D         maxFragmentSize; 
	uint             maxFragmentSizeAspectRatio; 
	uint             maxFragmentShadingRateCoverageSamples; 
	SampleCountFlags maxFragmentShadingRateRasterizationSamples; 
	uint             fragmentShadingRateWithShaderDepthStencilWrites; 
	uint             fragmentShadingRateWithSampleMask; 
	uint             fragmentShadingRateWithShaderSampleMask; 
	uint             fragmentShadingRateWithConservativeRasterization; 
	uint             fragmentShadingRateWithFragmentShaderInterlock; 
	uint             fragmentShadingRateWithCustomSampleLocations; 
	uint             fragmentShadingRateStrictMultiplyCombiner; 
}

struct PhysicalDeviceFragmentShadingRateKHR {
	StructureType    sType; 
	void*            pNext; 
	SampleCountFlags sampleCounts; 
	Extent2D         fragmentSize; 
}

struct RenderingFragmentShadingRateAttachmentInfoKHR {
	StructureType sType; 
	void*         pNext; 
	ImageView     imageView; 
	ImageLayout   imageLayout; 
	Extent2D      shadingRateAttachmentTexelSize; 
}

struct PhysicalDeviceShaderQuadControlFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          shaderQuadControl; 
}

struct SurfaceProtectedCapabilitiesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          supportsProtected; 
}

struct PhysicalDevicePresentWaitFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          presentWait; 
}

struct PhysicalDevicePipelineExecutablePropertiesFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          pipelineExecutableInfo; 
}

struct PipelineInfoKHR {
	StructureType sType; 
	void*         pNext; 
	Pipeline      pipeline; 
}

struct PipelineExecutablePropertiesKHR {
	StructureType               sType; 
	void*                       pNext; 
	ShaderStageFlags            stages; 
	ichar[MAX_DESCRIPTION_SIZE] name; 
	ichar[MAX_DESCRIPTION_SIZE] description; 
	uint                        subgroupSize; 
}

struct PipelineExecutableInfoKHR {
	StructureType sType; 
	void*         pNext; 
	Pipeline      pipeline; 
	uint          executableIndex; 
}

union PipelineExecutableStatisticValueKHR {
	uint   b32; 
	long   i64; 
	ulong  u64; 
	double f64; 
}

struct PipelineExecutableStatisticKHR {
	StructureType                        sType; 
	void*                                pNext; 
	ichar[MAX_DESCRIPTION_SIZE]          name; 
	ichar[MAX_DESCRIPTION_SIZE]          description; 
	PipelineExecutableStatisticFormatKHR format; 
	PipelineExecutableStatisticValueKHR  value; 
}

struct PipelineExecutableInternalRepresentationKHR {
	StructureType               sType; 
	void*                       pNext; 
	ichar[MAX_DESCRIPTION_SIZE] name; 
	ichar[MAX_DESCRIPTION_SIZE] description; 
	uint                        isText; 
	usz                         dataSize; 
	void*                       pData; 
}

struct PipelineLibraryCreateInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          libraryCount; 
	Pipeline*     pLibraries; 
}

struct PresentIdKHR {
	StructureType sType; 
	void*         pNext; 
	uint          swapchainCount; 
	ulong*        pPresentIds; 
}

struct PhysicalDevicePresentIdFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          presentId; 
}

struct VideoEncodeInfoKHR {
	StructureType               sType; 
	void*                       pNext; 
	VideoEncodeFlagsKHR         flags; 
	Buffer                      dstBuffer; 
	DeviceSize                  dstBufferOffset; 
	DeviceSize                  dstBufferRange; 
	VideoPictureResourceInfoKHR srcPictureResource; 
	VideoReferenceSlotInfoKHR*  pSetupReferenceSlot; 
	uint                        referenceSlotCount; 
	VideoReferenceSlotInfoKHR*  pReferenceSlots; 
	uint                        precedingExternallyEncodedBytes; 
}

struct VideoEncodeCapabilitiesKHR {
	StructureType                      sType; 
	void*                              pNext; 
	VideoEncodeCapabilityFlagsKHR      flags; 
	VideoEncodeRateControlModeFlagsKHR rateControlModes; 
	uint                               maxRateControlLayers; 
	ulong                              maxBitrate; 
	uint                               maxQualityLevels; 
	Extent2D                           encodeInputPictureGranularity; 
	VideoEncodeFeedbackFlagsKHR        supportedEncodeFeedbackFlags; 
}

struct QueryPoolVideoEncodeFeedbackCreateInfoKHR {
	StructureType               sType; 
	void*                       pNext; 
	VideoEncodeFeedbackFlagsKHR encodeFeedbackFlags; 
}

struct VideoEncodeUsageInfoKHR {
	StructureType              sType; 
	void*                      pNext; 
	VideoEncodeUsageFlagsKHR   videoUsageHints; 
	VideoEncodeContentFlagsKHR videoContentHints; 
	VideoEncodeTuningModeKHR   tuningMode; 
}

struct VideoEncodeRateControlLayerInfoKHR {
	StructureType sType; 
	void*         pNext; 
	ulong         averageBitrate; 
	ulong         maxBitrate; 
	uint          frameRateNumerator; 
	uint          frameRateDenominator; 
}

struct VideoEncodeRateControlInfoKHR {
	StructureType                       sType; 
	void*                               pNext; 
	VideoEncodeRateControlFlagsKHR      flags; 
	VideoEncodeRateControlModeFlagsKHR  rateControlMode; 
	uint                                layerCount; 
	VideoEncodeRateControlLayerInfoKHR* pLayers; 
	uint                                virtualBufferSizeInMs; 
	uint                                initialVirtualBufferSizeInMs; 
}

struct PhysicalDeviceVideoEncodeQualityLevelInfoKHR {
	StructureType        sType; 
	void*                pNext; 
	VideoProfileInfoKHR* pVideoProfile; 
	uint                 qualityLevel; 
}

struct VideoEncodeQualityLevelPropertiesKHR {
	StructureType                      sType; 
	void*                              pNext; 
	VideoEncodeRateControlModeFlagsKHR preferredRateControlMode; 
	uint                               preferredRateControlLayerCount; 
}

struct VideoEncodeQualityLevelInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          qualityLevel; 
}

struct VideoEncodeSessionParametersGetInfoKHR {
	StructureType             sType; 
	void*                     pNext; 
	VideoSessionParametersKHR videoSessionParameters; 
}

struct VideoEncodeSessionParametersFeedbackInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          hasOverrides; 
}

struct PhysicalDeviceFragmentShaderBarycentricFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          fragmentShaderBarycentric; 
}

struct PhysicalDeviceFragmentShaderBarycentricPropertiesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          triStripVertexOrderIndependentOfProvokingVertex; 
}

struct PhysicalDeviceShaderSubgroupUniformControlFlowFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          shaderSubgroupUniformControlFlow; 
}

struct PhysicalDeviceWorkgroupMemoryExplicitLayoutFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          workgroupMemoryExplicitLayout; 
	uint          workgroupMemoryExplicitLayoutScalarBlockLayout; 
	uint          workgroupMemoryExplicitLayout8BitAccess; 
	uint          workgroupMemoryExplicitLayout16BitAccess; 
}

struct PhysicalDeviceRayTracingMaintenance1FeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          rayTracingMaintenance1; 
	uint          rayTracingPipelineTraceRaysIndirect2; 
}

struct TraceRaysIndirectCommand2KHR {
	DeviceAddress raygenShaderRecordAddress; 
	DeviceSize    raygenShaderRecordSize; 
	DeviceAddress missShaderBindingTableAddress; 
	DeviceSize    missShaderBindingTableSize; 
	DeviceSize    missShaderBindingTableStride; 
	DeviceAddress hitShaderBindingTableAddress; 
	DeviceSize    hitShaderBindingTableSize; 
	DeviceSize    hitShaderBindingTableStride; 
	DeviceAddress callableShaderBindingTableAddress; 
	DeviceSize    callableShaderBindingTableSize; 
	DeviceSize    callableShaderBindingTableStride; 
	uint          width; 
	uint          height; 
	uint          depth; 
}

struct PhysicalDeviceShaderMaximalReconvergenceFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          shaderMaximalReconvergence; 
}

struct PhysicalDeviceRayTracingPositionFetchFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          rayTracingPositionFetch; 
}

struct PhysicalDevicePipelineBinaryFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          pipelineBinaries; 
}

struct PhysicalDevicePipelineBinaryPropertiesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          pipelineBinaryInternalCache; 
	uint          pipelineBinaryInternalCacheControl; 
	uint          pipelineBinaryPrefersInternalCache; 
	uint          pipelineBinaryPrecompiledInternalCache; 
	uint          pipelineBinaryCompressedData; 
}

struct DevicePipelineBinaryInternalCacheControlKHR {
	StructureType sType; 
	void*         pNext; 
	uint          disableInternalCache; 
}

struct PipelineBinaryKeyKHR {
	StructureType                          sType; 
	void*                                  pNext; 
	uint                                   keySize; 
	char[MAX_PIPELINE_BINARY_KEY_SIZE_KHR] key; 
}

struct PipelineBinaryDataKHR {
	usz   dataSize; 
	void* pData; 
}

struct PipelineBinaryKeysAndDataKHR {
	uint                   binaryCount; 
	PipelineBinaryKeyKHR*  pPipelineBinaryKeys; 
	PipelineBinaryDataKHR* pPipelineBinaryData; 
}

struct PipelineCreateInfoKHR {
	StructureType sType; 
	void*         pNext; 
}

struct PipelineBinaryCreateInfoKHR {
	StructureType                 sType; 
	void*                         pNext; 
	PipelineBinaryKeysAndDataKHR* pKeysAndDataInfo; 
	Pipeline                      pipeline; 
	PipelineCreateInfoKHR*        pPipelineCreateInfo; 
}

struct PipelineBinaryInfoKHR {
	StructureType      sType; 
	void*              pNext; 
	uint               binaryCount; 
	PipelineBinaryKHR* pPipelineBinaries; 
}

struct ReleaseCapturedPipelineDataInfoKHR {
	StructureType sType; 
	void*         pNext; 
	Pipeline      pipeline; 
}

struct PipelineBinaryDataInfoKHR {
	StructureType     sType; 
	void*             pNext; 
	PipelineBinaryKHR pipelineBinary; 
}

struct PipelineBinaryHandlesInfoKHR {
	StructureType      sType; 
	void*              pNext; 
	uint               pipelineBinaryCount; 
	PipelineBinaryKHR* pPipelineBinaries; 
}

struct CooperativeMatrixPropertiesKHR {
	StructureType    sType; 
	void*            pNext; 
	uint             mSize; 
	uint             nSize; 
	uint             kSize; 
	ComponentTypeKHR aType; 
	ComponentTypeKHR bType; 
	ComponentTypeKHR cType; 
	ComponentTypeKHR resultType; 
	uint             saturatingAccumulation; 
	ScopeKHR         scope; 
}

struct PhysicalDeviceCooperativeMatrixFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          cooperativeMatrix; 
	uint          cooperativeMatrixRobustBufferAccess; 
}

struct PhysicalDeviceCooperativeMatrixPropertiesKHR {
	StructureType    sType; 
	void*            pNext; 
	ShaderStageFlags cooperativeMatrixSupportedStages; 
}

struct PhysicalDeviceComputeShaderDerivativesFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          computeDerivativeGroupQuads; 
	uint          computeDerivativeGroupLinear; 
}

struct PhysicalDeviceComputeShaderDerivativesPropertiesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          meshAndTaskShaderDerivatives; 
}

struct VideoDecodeAV1ProfileInfoKHR {
	StructureType   sType; 
	void*           pNext; 
	VideoAV1Profile stdProfile; 
	uint            filmGrainSupport; 
}

struct VideoDecodeAV1CapabilitiesKHR {
	StructureType sType; 
	void*         pNext; 
	VideoAV1Level maxLevel; 
}

struct VideoDecodeAV1SessionParametersCreateInfoKHR {
	StructureType           sType; 
	void*                   pNext; 
	VideoAV1SequenceHeader* pStdSequenceHeader; 
}

struct VideoDecodeAV1PictureInfoKHR {
	StructureType                               sType; 
	void*                                       pNext; 
	VideoDecodeAV1PictureInfo*                  pStdPictureInfo; 
	int[MAX_VIDEO_AV1_REFERENCES_PER_FRAME_KHR] referenceNameSlotIndices; 
	uint                                        frameHeaderOffset; 
	uint                                        tileCount; 
	uint*                                       pTileOffsets; 
	uint*                                       pTileSizes; 
}

struct VideoDecodeAV1DpbSlotInfoKHR {
	StructureType                sType; 
	void*                        pNext; 
	VideoDecodeAV1ReferenceInfo* pStdReferenceInfo; 
}

struct PhysicalDeviceVideoEncodeAV1FeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          videoEncodeAV1; 
}

struct VideoEncodeAV1CapabilitiesKHR {
	StructureType                        sType; 
	void*                                pNext; 
	VideoEncodeAV1CapabilityFlagsKHR     flags; 
	VideoAV1Level                        maxLevel; 
	Extent2D                             codedPictureAlignment; 
	Extent2D                             maxTiles; 
	Extent2D                             minTileSize; 
	Extent2D                             maxTileSize; 
	VideoEncodeAV1SuperblockSizeFlagsKHR superblockSizes; 
	uint                                 maxSingleReferenceCount; 
	uint                                 singleReferenceNameMask; 
	uint                                 maxUnidirectionalCompoundReferenceCount; 
	uint                                 maxUnidirectionalCompoundGroup1ReferenceCount; 
	uint                                 unidirectionalCompoundReferenceNameMask; 
	uint                                 maxBidirectionalCompoundReferenceCount; 
	uint                                 maxBidirectionalCompoundGroup1ReferenceCount; 
	uint                                 maxBidirectionalCompoundGroup2ReferenceCount; 
	uint                                 bidirectionalCompoundReferenceNameMask; 
	uint                                 maxTemporalLayerCount; 
	uint                                 maxSpatialLayerCount; 
	uint                                 maxOperatingPoints; 
	uint                                 minQIndex; 
	uint                                 maxQIndex; 
	uint                                 prefersGopRemainingFrames; 
	uint                                 requiresGopRemainingFrames; 
	VideoEncodeAV1StdFlagsKHR            stdSyntaxFlags; 
}

struct VideoEncodeAV1QIndexKHR {
	uint intraQIndex; 
	uint predictiveQIndex; 
	uint bipredictiveQIndex; 
}

struct VideoEncodeAV1QualityLevelPropertiesKHR {
	StructureType                     sType; 
	void*                             pNext; 
	VideoEncodeAV1RateControlFlagsKHR preferredRateControlFlags; 
	uint                              preferredGopFrameCount; 
	uint                              preferredKeyFramePeriod; 
	uint                              preferredConsecutiveBipredictiveFrameCount; 
	uint                              preferredTemporalLayerCount; 
	VideoEncodeAV1QIndexKHR           preferredConstantQIndex; 
	uint                              preferredMaxSingleReferenceCount; 
	uint                              preferredSingleReferenceNameMask; 
	uint                              preferredMaxUnidirectionalCompoundReferenceCount; 
	uint                              preferredMaxUnidirectionalCompoundGroup1ReferenceCount; 
	uint                              preferredUnidirectionalCompoundReferenceNameMask; 
	uint                              preferredMaxBidirectionalCompoundReferenceCount; 
	uint                              preferredMaxBidirectionalCompoundGroup1ReferenceCount; 
	uint                              preferredMaxBidirectionalCompoundGroup2ReferenceCount; 
	uint                              preferredBidirectionalCompoundReferenceNameMask; 
}

struct VideoEncodeAV1SessionCreateInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          useMaxLevel; 
	VideoAV1Level maxLevel; 
}

struct VideoEncodeAV1SessionParametersCreateInfoKHR {
	StructureType                     sType; 
	void*                             pNext; 
	VideoAV1SequenceHeader*           pStdSequenceHeader; 
	VideoEncodeAV1DecoderModelInfo*   pStdDecoderModelInfo; 
	uint                              stdOperatingPointCount; 
	VideoEncodeAV1OperatingPointInfo* pStdOperatingPoints; 
}

struct VideoEncodeAV1PictureInfoKHR {
	StructureType                               sType; 
	void*                                       pNext; 
	VideoEncodeAV1PredictionModeKHR             predictionMode; 
	VideoEncodeAV1RateControlGroupKHR           rateControlGroup; 
	uint                                        constantQIndex; 
	VideoEncodeAV1PictureInfo*                  pStdPictureInfo; 
	int[MAX_VIDEO_AV1_REFERENCES_PER_FRAME_KHR] referenceNameSlotIndices; 
	uint                                        primaryReferenceCdfOnly; 
	uint                                        generateObuExtensionHeader; 
}

struct VideoEncodeAV1DpbSlotInfoKHR {
	StructureType                sType; 
	void*                        pNext; 
	VideoEncodeAV1ReferenceInfo* pStdReferenceInfo; 
}

struct VideoEncodeAV1ProfileInfoKHR {
	StructureType   sType; 
	void*           pNext; 
	VideoAV1Profile stdProfile; 
}

struct VideoEncodeAV1FrameSizeKHR {
	uint intraFrameSize; 
	uint predictiveFrameSize; 
	uint bipredictiveFrameSize; 
}

struct VideoEncodeAV1GopRemainingFrameInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          useGopRemainingFrames; 
	uint          gopRemainingIntra; 
	uint          gopRemainingPredictive; 
	uint          gopRemainingBipredictive; 
}

struct VideoEncodeAV1RateControlInfoKHR {
	StructureType                     sType; 
	void*                             pNext; 
	VideoEncodeAV1RateControlFlagsKHR flags; 
	uint                              gopFrameCount; 
	uint                              keyFramePeriod; 
	uint                              consecutiveBipredictiveFrameCount; 
	uint                              temporalLayerCount; 
}

struct VideoEncodeAV1RateControlLayerInfoKHR {
	StructureType              sType; 
	void*                      pNext; 
	uint                       useMinQIndex; 
	VideoEncodeAV1QIndexKHR    minQIndex; 
	uint                       useMaxQIndex; 
	VideoEncodeAV1QIndexKHR    maxQIndex; 
	uint                       useMaxFrameSize; 
	VideoEncodeAV1FrameSizeKHR maxFrameSize; 
}

struct PhysicalDeviceVideoMaintenance1FeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          videoMaintenance1; 
}

struct VideoInlineQueryInfoKHR {
	StructureType sType; 
	void*         pNext; 
	QueryPool     queryPool; 
	uint          firstQuery; 
	uint          queryCount; 
}

struct CalibratedTimestampInfoKHR {
	StructureType sType; 
	void*         pNext; 
	TimeDomainKHR timeDomain; 
}

struct SetDescriptorBufferOffsetsInfoEXT {
	StructureType    sType; 
	void*            pNext; 
	ShaderStageFlags stageFlags; 
	PipelineLayout   layout; 
	uint             firstSet; 
	uint             setCount; 
	uint*            pBufferIndices; 
	DeviceSize*      pOffsets; 
}

struct BindDescriptorBufferEmbeddedSamplersInfoEXT {
	StructureType    sType; 
	void*            pNext; 
	ShaderStageFlags stageFlags; 
	PipelineLayout   layout; 
	uint             set; 
}

struct VideoEncodeQuantizationMapCapabilitiesKHR {
	StructureType sType; 
	void*         pNext; 
	Extent2D      maxQuantizationMapExtent; 
}

struct VideoFormatQuantizationMapPropertiesKHR {
	StructureType sType; 
	void*         pNext; 
	Extent2D      quantizationMapTexelSize; 
}

struct VideoEncodeQuantizationMapInfoKHR {
	StructureType sType; 
	void*         pNext; 
	ImageView     quantizationMap; 
	Extent2D      quantizationMapExtent; 
}

struct VideoEncodeQuantizationMapSessionParametersCreateInfoKHR {
	StructureType sType; 
	void*         pNext; 
	Extent2D      quantizationMapTexelSize; 
}

struct PhysicalDeviceVideoEncodeQuantizationMapFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          videoEncodeQuantizationMap; 
}

struct VideoEncodeH264QuantizationMapCapabilitiesKHR {
	StructureType sType; 
	void*         pNext; 
	int           minQpDelta; 
	int           maxQpDelta; 
}

struct VideoEncodeH265QuantizationMapCapabilitiesKHR {
	StructureType sType; 
	void*         pNext; 
	int           minQpDelta; 
	int           maxQpDelta; 
}

struct VideoFormatH265QuantizationMapPropertiesKHR {
	StructureType                  sType; 
	void*                          pNext; 
	VideoEncodeH265CtbSizeFlagsKHR compatibleCtbSizes; 
}

struct VideoEncodeAV1QuantizationMapCapabilitiesKHR {
	StructureType sType; 
	void*         pNext; 
	int           minQIndexDelta; 
	int           maxQIndexDelta; 
}

struct VideoFormatAV1QuantizationMapPropertiesKHR {
	StructureType                        sType; 
	void*                                pNext; 
	VideoEncodeAV1SuperblockSizeFlagsKHR compatibleSuperblockSizes; 
}

struct PhysicalDeviceShaderRelaxedExtendedInstructionFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          shaderRelaxedExtendedInstruction; 
}

struct PhysicalDeviceMaintenance7FeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          maintenance7; 
}

struct PhysicalDeviceMaintenance7PropertiesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          robustFragmentShadingRateAttachmentAccess; 
	uint          separateDepthStencilAttachmentAccess; 
	uint          maxDescriptorSetTotalUniformBuffersDynamic; 
	uint          maxDescriptorSetTotalStorageBuffersDynamic; 
	uint          maxDescriptorSetTotalBuffersDynamic; 
	uint          maxDescriptorSetUpdateAfterBindTotalUniformBuffersDynamic; 
	uint          maxDescriptorSetUpdateAfterBindTotalStorageBuffersDynamic; 
	uint          maxDescriptorSetUpdateAfterBindTotalBuffersDynamic; 
}

struct PhysicalDeviceLayeredApiPropertiesKHR {
	StructureType                        sType; 
	void*                                pNext; 
	uint                                 vendorID; 
	uint                                 deviceID; 
	PhysicalDeviceLayeredApiKHR          layeredAPI; 
	ichar[MAX_PHYSICAL_DEVICE_NAME_SIZE] deviceName; 
}

struct PhysicalDeviceLayeredApiPropertiesListKHR {
	StructureType                          sType; 
	void*                                  pNext; 
	uint                                   layeredApiCount; 
	PhysicalDeviceLayeredApiPropertiesKHR* pLayeredApis; 
}

struct PhysicalDeviceLayeredApiVulkanPropertiesKHR {
	StructureType             sType; 
	void*                     pNext; 
	PhysicalDeviceProperties2 properties; 
}

struct DebugReportCallbackCreateInfoEXT {
	StructureType              sType; 
	void*                      pNext; 
	DebugReportFlagsEXT        flags; 
	ProcDebugReportCallbackEXT pfnCallback; 
	void*                      pUserData; 
}

struct PipelineRasterizationStateRasterizationOrderAMD {
	StructureType         sType; 
	void*                 pNext; 
	RasterizationOrderAMD rasterizationOrder; 
}

struct DebugMarkerObjectNameInfoEXT {
	StructureType            sType; 
	void*                    pNext; 
	DebugReportObjectTypeEXT objectType; 
	ulong                    object; 
	ZString                  pObjectName; 
}

struct DebugMarkerObjectTagInfoEXT {
	StructureType            sType; 
	void*                    pNext; 
	DebugReportObjectTypeEXT objectType; 
	ulong                    object; 
	ulong                    tagName; 
	usz                      tagSize; 
	void*                    pTag; 
}

struct DebugMarkerMarkerInfoEXT {
	StructureType sType; 
	void*         pNext; 
	ZString       pMarkerName; 
	float[4]      color; 
}

struct DedicatedAllocationImageCreateInfoNV {
	StructureType sType; 
	void*         pNext; 
	uint          dedicatedAllocation; 
}

struct DedicatedAllocationBufferCreateInfoNV {
	StructureType sType; 
	void*         pNext; 
	uint          dedicatedAllocation; 
}

struct DedicatedAllocationMemoryAllocateInfoNV {
	StructureType sType; 
	void*         pNext; 
	Image         image; 
	Buffer        buffer; 
}

struct PhysicalDeviceTransformFeedbackFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          transformFeedback; 
	uint          geometryStreams; 
}

struct PhysicalDeviceTransformFeedbackPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          maxTransformFeedbackStreams; 
	uint          maxTransformFeedbackBuffers; 
	DeviceSize    maxTransformFeedbackBufferSize; 
	uint          maxTransformFeedbackStreamDataSize; 
	uint          maxTransformFeedbackBufferDataSize; 
	uint          maxTransformFeedbackBufferDataStride; 
	uint          transformFeedbackQueries; 
	uint          transformFeedbackStreamsLinesTriangles; 
	uint          transformFeedbackRasterizationStreamSelect; 
	uint          transformFeedbackDraw; 
}

struct PipelineRasterizationStateStreamCreateInfoEXT {
	StructureType                                  sType; 
	void*                                          pNext; 
	PipelineRasterizationStateStreamCreateFlagsEXT flags; 
	uint                                           rasterizationStream; 
}

struct CuModuleCreateInfoNVX {
	StructureType sType; 
	void*         pNext; 
	usz           dataSize; 
	void*         pData; 
}

struct CuModuleTexturingModeCreateInfoNVX {
	StructureType sType; 
	void*         pNext; 
	uint          use64bitTexturing; 
}

struct CuFunctionCreateInfoNVX {
	StructureType sType; 
	void*         pNext; 
	CuModuleNVX   module_; 
	ZString       pName; 
}

struct CuLaunchInfoNVX {
	StructureType sType; 
	void*         pNext; 
	CuFunctionNVX function; 
	uint          gridDimX; 
	uint          gridDimY; 
	uint          gridDimZ; 
	uint          blockDimX; 
	uint          blockDimY; 
	uint          blockDimZ; 
	uint          sharedMemBytes; 
	usz           paramCount; 
	void**        pParams; 
	usz           extraCount; 
	void**        pExtras; 
}

struct ImageViewHandleInfoNVX {
	StructureType  sType; 
	void*          pNext; 
	ImageView      imageView; 
	DescriptorType descriptorType; 
	Sampler        sampler; 
}

struct ImageViewAddressPropertiesNVX {
	StructureType sType; 
	void*         pNext; 
	DeviceAddress deviceAddress; 
	DeviceSize    size; 
}

struct TextureLODGatherFormatPropertiesAMD {
	StructureType sType; 
	void*         pNext; 
	uint          supportsTextureGatherLODBiasAMD; 
}

struct ShaderResourceUsageAMD {
	uint numUsedVgprs; 
	uint numUsedSgprs; 
	uint ldsSizePerLocalWorkGroup; 
	usz  ldsUsageSizeInBytes; 
	usz  scratchMemUsageInBytes; 
}

struct ShaderStatisticsInfoAMD {
	ShaderStageFlags       shaderStageMask; 
	ShaderResourceUsageAMD resourceUsage; 
	uint                   numPhysicalVgprs; 
	uint                   numPhysicalSgprs; 
	uint                   numAvailableVgprs; 
	uint                   numAvailableSgprs; 
	uint[3]                computeWorkGroupSize; 
}

struct PhysicalDeviceCornerSampledImageFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          cornerSampledImage; 
}

struct ExternalImageFormatPropertiesNV {
	ImageFormatProperties           imageFormatProperties; 
	ExternalMemoryFeatureFlagsNV    externalMemoryFeatures; 
	ExternalMemoryHandleTypeFlagsNV exportFromImportedHandleTypes; 
	ExternalMemoryHandleTypeFlagsNV compatibleHandleTypes; 
}

struct ExternalMemoryImageCreateInfoNV {
	StructureType                   sType; 
	void*                           pNext; 
	ExternalMemoryHandleTypeFlagsNV handleTypes; 
}

struct ExportMemoryAllocateInfoNV {
	StructureType                   sType; 
	void*                           pNext; 
	ExternalMemoryHandleTypeFlagsNV handleTypes; 
}

struct ValidationFlagsEXT {
	StructureType       sType; 
	void*               pNext; 
	uint                disabledValidationCheckCount; 
	ValidationCheckEXT* pDisabledValidationChecks; 
}

struct ImageViewASTCDecodeModeEXT {
	StructureType sType; 
	void*         pNext; 
	Format        decodeMode; 
}

struct PhysicalDeviceASTCDecodeFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          decodeModeSharedExponent; 
}

struct ConditionalRenderingBeginInfoEXT {
	StructureType                sType; 
	void*                        pNext; 
	Buffer                       buffer; 
	DeviceSize                   offset; 
	ConditionalRenderingFlagsEXT flags; 
}

struct PhysicalDeviceConditionalRenderingFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          conditionalRendering; 
	uint          inheritedConditionalRendering; 
}

struct CommandBufferInheritanceConditionalRenderingInfoEXT {
	StructureType sType; 
	void*         pNext; 
	uint          conditionalRenderingEnable; 
}

struct ViewportWScalingNV {
	float xcoeff; 
	float ycoeff; 
}

struct PipelineViewportWScalingStateCreateInfoNV {
	StructureType       sType; 
	void*               pNext; 
	uint                viewportWScalingEnable; 
	uint                viewportCount; 
	ViewportWScalingNV* pViewportWScalings; 
}

struct SurfaceCapabilities2EXT {
	StructureType            sType; 
	void*                    pNext; 
	uint                     minImageCount; 
	uint                     maxImageCount; 
	Extent2D                 currentExtent; 
	Extent2D                 minImageExtent; 
	Extent2D                 maxImageExtent; 
	uint                     maxImageArrayLayers; 
	SurfaceTransformFlagsKHR supportedTransforms; 
	SurfaceTransformFlagsKHR currentTransform; 
	CompositeAlphaFlagsKHR   supportedCompositeAlpha; 
	ImageUsageFlags          supportedUsageFlags; 
	SurfaceCounterFlagsEXT   supportedSurfaceCounters; 
}

struct DisplayPowerInfoEXT {
	StructureType        sType; 
	void*                pNext; 
	DisplayPowerStateEXT powerState; 
}

struct DeviceEventInfoEXT {
	StructureType      sType; 
	void*              pNext; 
	DeviceEventTypeEXT deviceEvent; 
}

struct DisplayEventInfoEXT {
	StructureType       sType; 
	void*               pNext; 
	DisplayEventTypeEXT displayEvent; 
}

struct SwapchainCounterCreateInfoEXT {
	StructureType          sType; 
	void*                  pNext; 
	SurfaceCounterFlagsEXT surfaceCounters; 
}

struct RefreshCycleDurationGOOGLE {
	ulong refreshDuration; 
}

struct PastPresentationTimingGOOGLE {
	uint  presentID; 
	ulong desiredPresentTime; 
	ulong actualPresentTime; 
	ulong earliestPresentTime; 
	ulong presentMargin; 
}

struct PresentTimeGOOGLE {
	uint  presentID; 
	ulong desiredPresentTime; 
}

struct PresentTimesInfoGOOGLE {
	StructureType      sType; 
	void*              pNext; 
	uint               swapchainCount; 
	PresentTimeGOOGLE* pTimes; 
}

struct PhysicalDeviceMultiviewPerViewAttributesPropertiesNVX {
	StructureType sType; 
	void*         pNext; 
	uint          perViewPositionAllComponents; 
}

struct MultiviewPerViewAttributesInfoNVX {
	StructureType sType; 
	void*         pNext; 
	uint          perViewAttributes; 
	uint          perViewAttributesPositionXOnly; 
}

struct ViewportSwizzleNV {
	ViewportCoordinateSwizzleNV x; 
	ViewportCoordinateSwizzleNV y; 
	ViewportCoordinateSwizzleNV z; 
	ViewportCoordinateSwizzleNV w; 
}

struct PipelineViewportSwizzleStateCreateInfoNV {
	StructureType                             sType; 
	void*                                     pNext; 
	PipelineViewportSwizzleStateCreateFlagsNV flags; 
	uint                                      viewportCount; 
	ViewportSwizzleNV*                        pViewportSwizzles; 
}

struct PhysicalDeviceDiscardRectanglePropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          maxDiscardRectangles; 
}

struct PipelineDiscardRectangleStateCreateInfoEXT {
	StructureType                               sType; 
	void*                                       pNext; 
	PipelineDiscardRectangleStateCreateFlagsEXT flags; 
	DiscardRectangleModeEXT                     discardRectangleMode; 
	uint                                        discardRectangleCount; 
	Rect2D*                                     pDiscardRectangles; 
}

struct PhysicalDeviceConservativeRasterizationPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	float         primitiveOverestimationSize; 
	float         maxExtraPrimitiveOverestimationSize; 
	float         extraPrimitiveOverestimationSizeGranularity; 
	uint          primitiveUnderestimation; 
	uint          conservativePointAndLineRasterization; 
	uint          degenerateTrianglesRasterized; 
	uint          degenerateLinesRasterized; 
	uint          fullyCoveredFragmentShaderInputVariable; 
	uint          conservativeRasterizationPostDepthCoverage; 
}

struct PipelineRasterizationConservativeStateCreateInfoEXT {
	StructureType                                        sType; 
	void*                                                pNext; 
	PipelineRasterizationConservativeStateCreateFlagsEXT flags; 
	ConservativeRasterizationModeEXT                     conservativeRasterizationMode; 
	float                                                extraPrimitiveOverestimationSize; 
}

struct PhysicalDeviceDepthClipEnableFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          depthClipEnable; 
}

struct PipelineRasterizationDepthClipStateCreateInfoEXT {
	StructureType                                     sType; 
	void*                                             pNext; 
	PipelineRasterizationDepthClipStateCreateFlagsEXT flags; 
	uint                                              depthClipEnable; 
}

struct XYColorEXT {
	float x; 
	float y; 
}

struct HdrMetadataEXT {
	StructureType sType; 
	void*         pNext; 
	XYColorEXT    displayPrimaryRed; 
	XYColorEXT    displayPrimaryGreen; 
	XYColorEXT    displayPrimaryBlue; 
	XYColorEXT    whitePoint; 
	float         maxLuminance; 
	float         minLuminance; 
	float         maxContentLightLevel; 
	float         maxFrameAverageLightLevel; 
}

struct PhysicalDeviceRelaxedLineRasterizationFeaturesIMG {
	StructureType sType; 
	void*         pNext; 
	uint          relaxedLineRasterization; 
}

struct DebugUtilsLabelEXT {
	StructureType sType; 
	void*         pNext; 
	ZString       pLabelName; 
	float[4]      color; 
}

struct DebugUtilsObjectNameInfoEXT {
	StructureType sType; 
	void*         pNext; 
	ObjectType    objectType; 
	ulong         objectHandle; 
	ZString       pObjectName; 
}

struct DebugUtilsMessengerCallbackDataEXT {
	StructureType                           sType; 
	void*                                   pNext; 
	DebugUtilsMessengerCallbackDataFlagsEXT flags; 
	ZString                                 pMessageIdName; 
	int                                     messageIdNumber; 
	ZString                                 pMessage; 
	uint                                    queueLabelCount; 
	DebugUtilsLabelEXT*                     pQueueLabels; 
	uint                                    cmdBufLabelCount; 
	DebugUtilsLabelEXT*                     pCmdBufLabels; 
	uint                                    objectCount; 
	DebugUtilsObjectNameInfoEXT*            pObjects; 
}

struct DebugUtilsMessengerCreateInfoEXT {
	StructureType                      sType; 
	void*                              pNext; 
	DebugUtilsMessengerCreateFlagsEXT  flags; 
	DebugUtilsMessageSeverityFlagsEXT  messageSeverity; 
	DebugUtilsMessageTypeFlagsEXT      messageType; 
	ProcDebugUtilsMessengerCallbackEXT pfnUserCallback; 
	void*                              pUserData; 
}

struct DebugUtilsObjectTagInfoEXT {
	StructureType sType; 
	void*         pNext; 
	ObjectType    objectType; 
	ulong         objectHandle; 
	ulong         tagName; 
	usz           tagSize; 
	void*         pTag; 
}

struct AttachmentSampleCountInfoAMD {
	StructureType     sType; 
	void*             pNext; 
	uint              colorAttachmentCount; 
	SampleCountFlags* pColorAttachmentSamples; 
	SampleCountFlags  depthStencilAttachmentSamples; 
}

struct SampleLocationEXT {
	float x; 
	float y; 
}

struct SampleLocationsInfoEXT {
	StructureType      sType; 
	void*              pNext; 
	SampleCountFlags   sampleLocationsPerPixel; 
	Extent2D           sampleLocationGridSize; 
	uint               sampleLocationsCount; 
	SampleLocationEXT* pSampleLocations; 
}

struct AttachmentSampleLocationsEXT {
	uint                   attachmentIndex; 
	SampleLocationsInfoEXT sampleLocationsInfo; 
}

struct SubpassSampleLocationsEXT {
	uint                   subpassIndex; 
	SampleLocationsInfoEXT sampleLocationsInfo; 
}

struct RenderPassSampleLocationsBeginInfoEXT {
	StructureType                 sType; 
	void*                         pNext; 
	uint                          attachmentInitialSampleLocationsCount; 
	AttachmentSampleLocationsEXT* pAttachmentInitialSampleLocations; 
	uint                          postSubpassSampleLocationsCount; 
	SubpassSampleLocationsEXT*    pPostSubpassSampleLocations; 
}

struct PipelineSampleLocationsStateCreateInfoEXT {
	StructureType          sType; 
	void*                  pNext; 
	uint                   sampleLocationsEnable; 
	SampleLocationsInfoEXT sampleLocationsInfo; 
}

struct PhysicalDeviceSampleLocationsPropertiesEXT {
	StructureType    sType; 
	void*            pNext; 
	SampleCountFlags sampleLocationSampleCounts; 
	Extent2D         maxSampleLocationGridSize; 
	float[2]         sampleLocationCoordinateRange; 
	uint             sampleLocationSubPixelBits; 
	uint             variableSampleLocations; 
}

struct MultisamplePropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	Extent2D      maxSampleLocationGridSize; 
}

struct PhysicalDeviceBlendOperationAdvancedFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          advancedBlendCoherentOperations; 
}

struct PhysicalDeviceBlendOperationAdvancedPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          advancedBlendMaxColorAttachments; 
	uint          advancedBlendIndependentBlend; 
	uint          advancedBlendNonPremultipliedSrcColor; 
	uint          advancedBlendNonPremultipliedDstColor; 
	uint          advancedBlendCorrelatedOverlap; 
	uint          advancedBlendAllOperations; 
}

struct PipelineColorBlendAdvancedStateCreateInfoEXT {
	StructureType   sType; 
	void*           pNext; 
	uint            srcPremultiplied; 
	uint            dstPremultiplied; 
	BlendOverlapEXT blendOverlap; 
}

struct PipelineCoverageToColorStateCreateInfoNV {
	StructureType                             sType; 
	void*                                     pNext; 
	PipelineCoverageToColorStateCreateFlagsNV flags; 
	uint                                      coverageToColorEnable; 
	uint                                      coverageToColorLocation; 
}

struct PipelineCoverageModulationStateCreateInfoNV {
	StructureType                                sType; 
	void*                                        pNext; 
	PipelineCoverageModulationStateCreateFlagsNV flags; 
	CoverageModulationModeNV                     coverageModulationMode; 
	uint                                         coverageModulationTableEnable; 
	uint                                         coverageModulationTableCount; 
	float*                                       pCoverageModulationTable; 
}

struct PhysicalDeviceShaderSMBuiltinsPropertiesNV {
	StructureType sType; 
	void*         pNext; 
	uint          shaderSMCount; 
	uint          shaderWarpsPerSM; 
}

struct PhysicalDeviceShaderSMBuiltinsFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          shaderSMBuiltins; 
}

struct DrmFormatModifierPropertiesEXT {
	ulong              drmFormatModifier; 
	uint               drmFormatModifierPlaneCount; 
	FormatFeatureFlags drmFormatModifierTilingFeatures; 
}

struct DrmFormatModifierPropertiesListEXT {
	StructureType                   sType; 
	void*                           pNext; 
	uint                            drmFormatModifierCount; 
	DrmFormatModifierPropertiesEXT* pDrmFormatModifierProperties; 
}

struct PhysicalDeviceImageDrmFormatModifierInfoEXT {
	StructureType sType; 
	void*         pNext; 
	ulong         drmFormatModifier; 
	SharingMode   sharingMode; 
	uint          queueFamilyIndexCount; 
	uint*         pQueueFamilyIndices; 
}

struct ImageDrmFormatModifierListCreateInfoEXT {
	StructureType sType; 
	void*         pNext; 
	uint          drmFormatModifierCount; 
	ulong*        pDrmFormatModifiers; 
}

struct ImageDrmFormatModifierExplicitCreateInfoEXT {
	StructureType      sType; 
	void*              pNext; 
	ulong              drmFormatModifier; 
	uint               drmFormatModifierPlaneCount; 
	SubresourceLayout* pPlaneLayouts; 
}

struct ImageDrmFormatModifierPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	ulong         drmFormatModifier; 
}

struct DrmFormatModifierProperties2EXT {
	ulong               drmFormatModifier; 
	uint                drmFormatModifierPlaneCount; 
	FormatFeatureFlags2 drmFormatModifierTilingFeatures; 
}

struct DrmFormatModifierPropertiesList2EXT {
	StructureType                    sType; 
	void*                            pNext; 
	uint                             drmFormatModifierCount; 
	DrmFormatModifierProperties2EXT* pDrmFormatModifierProperties; 
}

struct ValidationCacheCreateInfoEXT {
	StructureType                 sType; 
	void*                         pNext; 
	ValidationCacheCreateFlagsEXT flags; 
	usz                           initialDataSize; 
	void*                         pInitialData; 
}

struct ShaderModuleValidationCacheCreateInfoEXT {
	StructureType      sType; 
	void*              pNext; 
	ValidationCacheEXT validationCache; 
}

struct ShadingRatePaletteNV {
	uint                       shadingRatePaletteEntryCount; 
	ShadingRatePaletteEntryNV* pShadingRatePaletteEntries; 
}

struct PipelineViewportShadingRateImageStateCreateInfoNV {
	StructureType         sType; 
	void*                 pNext; 
	uint                  shadingRateImageEnable; 
	uint                  viewportCount; 
	ShadingRatePaletteNV* pShadingRatePalettes; 
}

struct PhysicalDeviceShadingRateImageFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          shadingRateImage; 
	uint          shadingRateCoarseSampleOrder; 
}

struct PhysicalDeviceShadingRateImagePropertiesNV {
	StructureType sType; 
	void*         pNext; 
	Extent2D      shadingRateTexelSize; 
	uint          shadingRatePaletteSize; 
	uint          shadingRateMaxCoarseSamples; 
}

struct CoarseSampleLocationNV {
	uint pixelX; 
	uint pixelY; 
	uint sample; 
}

struct CoarseSampleOrderCustomNV {
	ShadingRatePaletteEntryNV shadingRate; 
	uint                      sampleCount; 
	uint                      sampleLocationCount; 
	CoarseSampleLocationNV*   pSampleLocations; 
}

struct PipelineViewportCoarseSampleOrderStateCreateInfoNV {
	StructureType              sType; 
	void*                      pNext; 
	CoarseSampleOrderTypeNV    sampleOrderType; 
	uint                       customSampleOrderCount; 
	CoarseSampleOrderCustomNV* pCustomSampleOrders; 
}

struct RayTracingShaderGroupCreateInfoNV {
	StructureType                sType; 
	void*                        pNext; 
	RayTracingShaderGroupTypeKHR type; 
	uint                         generalShader; 
	uint                         closestHitShader; 
	uint                         anyHitShader; 
	uint                         intersectionShader; 
}

struct RayTracingPipelineCreateInfoNV {
	StructureType                      sType; 
	void*                              pNext; 
	PipelineCreateFlags                flags; 
	uint                               stageCount; 
	PipelineShaderStageCreateInfo*     pStages; 
	uint                               groupCount; 
	RayTracingShaderGroupCreateInfoNV* pGroups; 
	uint                               maxRecursionDepth; 
	PipelineLayout                     layout; 
	Pipeline                           basePipelineHandle; 
	int                                basePipelineIndex; 
}

struct GeometryTrianglesNV {
	StructureType sType; 
	void*         pNext; 
	Buffer        vertexData; 
	DeviceSize    vertexOffset; 
	uint          vertexCount; 
	DeviceSize    vertexStride; 
	Format        vertexFormat; 
	Buffer        indexData; 
	DeviceSize    indexOffset; 
	uint          indexCount; 
	IndexType     indexType; 
	Buffer        transformData; 
	DeviceSize    transformOffset; 
}

struct GeometryAABBNV {
	StructureType sType; 
	void*         pNext; 
	Buffer        aabbData; 
	uint          numAABBs; 
	uint          stride; 
	DeviceSize    offset; 
}

struct GeometryDataNV {
	GeometryTrianglesNV triangles; 
	GeometryAABBNV      aabbs; 
}

struct GeometryNV {
	StructureType    sType; 
	void*            pNext; 
	GeometryTypeKHR  geometryType; 
	GeometryDataNV   geometry; 
	GeometryFlagsKHR flags; 
}

struct AccelerationStructureInfoNV {
	StructureType                     sType; 
	void*                             pNext; 
	AccelerationStructureTypeNV       type; 
	BuildAccelerationStructureFlagsNV flags; 
	uint                              instanceCount; 
	uint                              geometryCount; 
	GeometryNV*                       pGeometries; 
}

struct AccelerationStructureCreateInfoNV {
	StructureType               sType; 
	void*                       pNext; 
	DeviceSize                  compactedSize; 
	AccelerationStructureInfoNV info; 
}

struct BindAccelerationStructureMemoryInfoNV {
	StructureType           sType; 
	void*                   pNext; 
	AccelerationStructureNV accelerationStructure; 
	DeviceMemory            memory; 
	DeviceSize              memoryOffset; 
	uint                    deviceIndexCount; 
	uint*                   pDeviceIndices; 
}

struct WriteDescriptorSetAccelerationStructureNV {
	StructureType            sType; 
	void*                    pNext; 
	uint                     accelerationStructureCount; 
	AccelerationStructureNV* pAccelerationStructures; 
}

struct AccelerationStructureMemoryRequirementsInfoNV {
	StructureType                                 sType; 
	void*                                         pNext; 
	AccelerationStructureMemoryRequirementsTypeNV type; 
	AccelerationStructureNV                       accelerationStructure; 
}

struct PhysicalDeviceRayTracingPropertiesNV {
	StructureType sType; 
	void*         pNext; 
	uint          shaderGroupHandleSize; 
	uint          maxRecursionDepth; 
	uint          maxShaderGroupStride; 
	uint          shaderGroupBaseAlignment; 
	ulong         maxGeometryCount; 
	ulong         maxInstanceCount; 
	ulong         maxTriangleCount; 
	uint          maxDescriptorSetAccelerationStructures; 
}

struct TransformMatrixKHR {
	float[3][4] mat; 
}

struct AabbPositionsKHR {
	float minX; 
	float minY; 
	float minZ; 
	float maxX; 
	float maxY; 
	float maxZ; 
}

struct AccelerationStructureInstanceKHR {
	TransformMatrixKHR transform; 
	uint               instanceCustomIndexAndMask;  // Most significant byte is mask
	uint               instanceShaderBindingTableRecordOffsetAndFlags;  // Most significant byte is flags
	ulong              accelerationStructureReference; 
}

struct PhysicalDeviceRepresentativeFragmentTestFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          representativeFragmentTest; 
}

struct PipelineRepresentativeFragmentTestStateCreateInfoNV {
	StructureType sType; 
	void*         pNext; 
	uint          representativeFragmentTestEnable; 
}

struct PhysicalDeviceImageViewImageFormatInfoEXT {
	StructureType sType; 
	void*         pNext; 
	ImageViewType imageViewType; 
}

struct FilterCubicImageViewImageFormatPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          filterCubic; 
	uint          filterCubicMinmax; 
}

struct ImportMemoryHostPointerInfoEXT {
	StructureType                 sType; 
	void*                         pNext; 
	ExternalMemoryHandleTypeFlags handleType; 
	void*                         pHostPointer; 
}

struct MemoryHostPointerPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          memoryTypeBits; 
}

struct PhysicalDeviceExternalMemoryHostPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	DeviceSize    minImportedHostPointerAlignment; 
}

struct PipelineCompilerControlCreateInfoAMD {
	StructureType                   sType; 
	void*                           pNext; 
	PipelineCompilerControlFlagsAMD compilerControlFlags; 
}

struct PhysicalDeviceShaderCorePropertiesAMD {
	StructureType sType; 
	void*         pNext; 
	uint          shaderEngineCount; 
	uint          shaderArraysPerEngineCount; 
	uint          computeUnitsPerShaderArray; 
	uint          simdPerComputeUnit; 
	uint          wavefrontsPerSimd; 
	uint          wavefrontSize; 
	uint          sgprsPerSimd; 
	uint          minSgprAllocation; 
	uint          maxSgprAllocation; 
	uint          sgprAllocationGranularity; 
	uint          vgprsPerSimd; 
	uint          minVgprAllocation; 
	uint          maxVgprAllocation; 
	uint          vgprAllocationGranularity; 
}

struct DeviceMemoryOverallocationCreateInfoAMD {
	StructureType                   sType; 
	void*                           pNext; 
	MemoryOverallocationBehaviorAMD overallocationBehavior; 
}

struct PhysicalDeviceVertexAttributeDivisorPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          maxVertexAttribDivisor; 
}

struct PhysicalDeviceMeshShaderFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          taskShader; 
	uint          meshShader; 
}

struct PhysicalDeviceMeshShaderPropertiesNV {
	StructureType sType; 
	void*         pNext; 
	uint          maxDrawMeshTasksCount; 
	uint          maxTaskWorkGroupInvocations; 
	uint[3]       maxTaskWorkGroupSize; 
	uint          maxTaskTotalMemorySize; 
	uint          maxTaskOutputCount; 
	uint          maxMeshWorkGroupInvocations; 
	uint[3]       maxMeshWorkGroupSize; 
	uint          maxMeshTotalMemorySize; 
	uint          maxMeshOutputVertices; 
	uint          maxMeshOutputPrimitives; 
	uint          maxMeshMultiviewViewCount; 
	uint          meshOutputPerVertexGranularity; 
	uint          meshOutputPerPrimitiveGranularity; 
}

struct DrawMeshTasksIndirectCommandNV {
	uint taskCount; 
	uint firstTask; 
}

struct PhysicalDeviceShaderImageFootprintFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          imageFootprint; 
}

struct PipelineViewportExclusiveScissorStateCreateInfoNV {
	StructureType sType; 
	void*         pNext; 
	uint          exclusiveScissorCount; 
	Rect2D*       pExclusiveScissors; 
}

struct PhysicalDeviceExclusiveScissorFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          exclusiveScissor; 
}

struct QueueFamilyCheckpointPropertiesNV {
	StructureType      sType; 
	void*              pNext; 
	PipelineStageFlags checkpointExecutionStageMask; 
}

struct CheckpointDataNV {
	StructureType      sType; 
	void*              pNext; 
	PipelineStageFlags stage; 
	void*              pCheckpointMarker; 
}

struct QueueFamilyCheckpointProperties2NV {
	StructureType       sType; 
	void*               pNext; 
	PipelineStageFlags2 checkpointExecutionStageMask; 
}

struct CheckpointData2NV {
	StructureType       sType; 
	void*               pNext; 
	PipelineStageFlags2 stage; 
	void*               pCheckpointMarker; 
}

struct PhysicalDeviceShaderIntegerFunctions2FeaturesINTEL {
	StructureType sType; 
	void*         pNext; 
	uint          shaderIntegerFunctions2; 
}

union PerformanceValueDataINTEL {
	uint    value32; 
	ulong   value64; 
	float   valueFloat; 
	uint    valueBool; 
	ZString valueString; 
}

struct PerformanceValueINTEL {
	PerformanceValueTypeINTEL type; 
	PerformanceValueDataINTEL data; 
}

struct InitializePerformanceApiInfoINTEL {
	StructureType sType; 
	void*         pNext; 
	void*         pUserData; 
}

struct QueryPoolPerformanceQueryCreateInfoINTEL {
	StructureType              sType; 
	void*                      pNext; 
	QueryPoolSamplingModeINTEL performanceCountersSampling; 
}

struct PerformanceMarkerInfoINTEL {
	StructureType sType; 
	void*         pNext; 
	ulong         marker; 
}

struct PerformanceStreamMarkerInfoINTEL {
	StructureType sType; 
	void*         pNext; 
	uint          marker; 
}

struct PerformanceOverrideInfoINTEL {
	StructureType                sType; 
	void*                        pNext; 
	PerformanceOverrideTypeINTEL type; 
	uint                         enable; 
	ulong                        parameter; 
}

struct PerformanceConfigurationAcquireInfoINTEL {
	StructureType                     sType; 
	void*                             pNext; 
	PerformanceConfigurationTypeINTEL type; 
}

struct PhysicalDevicePCIBusInfoPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          pciDomain; 
	uint          pciBus; 
	uint          pciDevice; 
	uint          pciFunction; 
}

struct DisplayNativeHdrSurfaceCapabilitiesAMD {
	StructureType sType; 
	void*         pNext; 
	uint          localDimmingSupport; 
}

struct SwapchainDisplayNativeHdrCreateInfoAMD {
	StructureType sType; 
	void*         pNext; 
	uint          localDimmingEnable; 
}

struct PhysicalDeviceFragmentDensityMapFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          fragmentDensityMap; 
	uint          fragmentDensityMapDynamic; 
	uint          fragmentDensityMapNonSubsampledImages; 
}

struct PhysicalDeviceFragmentDensityMapPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	Extent2D      minFragmentDensityTexelSize; 
	Extent2D      maxFragmentDensityTexelSize; 
	uint          fragmentDensityInvocations; 
}

struct RenderPassFragmentDensityMapCreateInfoEXT {
	StructureType       sType; 
	void*               pNext; 
	AttachmentReference fragmentDensityMapAttachment; 
}

struct RenderingFragmentDensityMapAttachmentInfoEXT {
	StructureType sType; 
	void*         pNext; 
	ImageView     imageView; 
	ImageLayout   imageLayout; 
}

struct PhysicalDeviceShaderCoreProperties2AMD {
	StructureType                sType; 
	void*                        pNext; 
	ShaderCorePropertiesFlagsAMD shaderCoreFeatures; 
	uint                         activeComputeUnitCount; 
}

struct PhysicalDeviceCoherentMemoryFeaturesAMD {
	StructureType sType; 
	void*         pNext; 
	uint          deviceCoherentMemory; 
}

struct PhysicalDeviceShaderImageAtomicInt64FeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          shaderImageInt64Atomics; 
	uint          sparseImageInt64Atomics; 
}

struct PhysicalDeviceMemoryBudgetPropertiesEXT {
	StructureType                sType; 
	void*                        pNext; 
	DeviceSize[MAX_MEMORY_HEAPS] heapBudget; 
	DeviceSize[MAX_MEMORY_HEAPS] heapUsage; 
}

struct PhysicalDeviceMemoryPriorityFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          memoryPriority; 
}

struct MemoryPriorityAllocateInfoEXT {
	StructureType sType; 
	void*         pNext; 
	float         priority; 
}

struct PhysicalDeviceDedicatedAllocationImageAliasingFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          dedicatedAllocationImageAliasing; 
}

struct PhysicalDeviceBufferDeviceAddressFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          bufferDeviceAddress; 
	uint          bufferDeviceAddressCaptureReplay; 
	uint          bufferDeviceAddressMultiDevice; 
}

struct BufferDeviceAddressCreateInfoEXT {
	StructureType sType; 
	void*         pNext; 
	DeviceAddress deviceAddress; 
}

struct ValidationFeaturesEXT {
	StructureType                sType; 
	void*                        pNext; 
	uint                         enabledValidationFeatureCount; 
	ValidationFeatureEnableEXT*  pEnabledValidationFeatures; 
	uint                         disabledValidationFeatureCount; 
	ValidationFeatureDisableEXT* pDisabledValidationFeatures; 
}

struct CooperativeMatrixPropertiesNV {
	StructureType   sType; 
	void*           pNext; 
	uint            mSize; 
	uint            nSize; 
	uint            kSize; 
	ComponentTypeNV aType; 
	ComponentTypeNV bType; 
	ComponentTypeNV cType; 
	ComponentTypeNV dType; 
	ScopeNV         scope; 
}

struct PhysicalDeviceCooperativeMatrixFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          cooperativeMatrix; 
	uint          cooperativeMatrixRobustBufferAccess; 
}

struct PhysicalDeviceCooperativeMatrixPropertiesNV {
	StructureType    sType; 
	void*            pNext; 
	ShaderStageFlags cooperativeMatrixSupportedStages; 
}

struct PhysicalDeviceCoverageReductionModeFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          coverageReductionMode; 
}

struct PipelineCoverageReductionStateCreateInfoNV {
	StructureType                               sType; 
	void*                                       pNext; 
	PipelineCoverageReductionStateCreateFlagsNV flags; 
	CoverageReductionModeNV                     coverageReductionMode; 
}

struct FramebufferMixedSamplesCombinationNV {
	StructureType           sType; 
	void*                   pNext; 
	CoverageReductionModeNV coverageReductionMode; 
	SampleCountFlags        rasterizationSamples; 
	SampleCountFlags        depthStencilSamples; 
	SampleCountFlags        colorSamples; 
}

struct PhysicalDeviceFragmentShaderInterlockFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          fragmentShaderSampleInterlock; 
	uint          fragmentShaderPixelInterlock; 
	uint          fragmentShaderShadingRateInterlock; 
}

struct PhysicalDeviceYcbcrImageArraysFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          ycbcrImageArrays; 
}

struct PhysicalDeviceProvokingVertexFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          provokingVertexLast; 
	uint          transformFeedbackPreservesProvokingVertex; 
}

struct PhysicalDeviceProvokingVertexPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          provokingVertexModePerPipeline; 
	uint          transformFeedbackPreservesTriangleFanProvokingVertex; 
}

struct PipelineRasterizationProvokingVertexStateCreateInfoEXT {
	StructureType          sType; 
	void*                  pNext; 
	ProvokingVertexModeEXT provokingVertexMode; 
}

struct HeadlessSurfaceCreateInfoEXT {
	StructureType                 sType; 
	void*                         pNext; 
	HeadlessSurfaceCreateFlagsEXT flags; 
}

struct PhysicalDeviceShaderAtomicFloatFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          shaderBufferFloat32Atomics; 
	uint          shaderBufferFloat32AtomicAdd; 
	uint          shaderBufferFloat64Atomics; 
	uint          shaderBufferFloat64AtomicAdd; 
	uint          shaderSharedFloat32Atomics; 
	uint          shaderSharedFloat32AtomicAdd; 
	uint          shaderSharedFloat64Atomics; 
	uint          shaderSharedFloat64AtomicAdd; 
	uint          shaderImageFloat32Atomics; 
	uint          shaderImageFloat32AtomicAdd; 
	uint          sparseImageFloat32Atomics; 
	uint          sparseImageFloat32AtomicAdd; 
}

struct PhysicalDeviceExtendedDynamicStateFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          extendedDynamicState; 
}

struct PhysicalDeviceMapMemoryPlacedFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          memoryMapPlaced; 
	uint          memoryMapRangePlaced; 
	uint          memoryUnmapReserve; 
}

struct PhysicalDeviceMapMemoryPlacedPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	DeviceSize    minPlacedMemoryMapAlignment; 
}

struct MemoryMapPlacedInfoEXT {
	StructureType sType; 
	void*         pNext; 
	void*         pPlacedAddress; 
}

struct PhysicalDeviceShaderAtomicFloat2FeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          shaderBufferFloat16Atomics; 
	uint          shaderBufferFloat16AtomicAdd; 
	uint          shaderBufferFloat16AtomicMinMax; 
	uint          shaderBufferFloat32AtomicMinMax; 
	uint          shaderBufferFloat64AtomicMinMax; 
	uint          shaderSharedFloat16Atomics; 
	uint          shaderSharedFloat16AtomicAdd; 
	uint          shaderSharedFloat16AtomicMinMax; 
	uint          shaderSharedFloat32AtomicMinMax; 
	uint          shaderSharedFloat64AtomicMinMax; 
	uint          shaderImageFloat32AtomicMinMax; 
	uint          sparseImageFloat32AtomicMinMax; 
}

struct SurfacePresentModeEXT {
	StructureType  sType; 
	void*          pNext; 
	PresentModeKHR presentMode; 
}

struct SurfacePresentScalingCapabilitiesEXT {
	StructureType          sType; 
	void*                  pNext; 
	PresentScalingFlagsEXT supportedPresentScaling; 
	PresentGravityFlagsEXT supportedPresentGravityX; 
	PresentGravityFlagsEXT supportedPresentGravityY; 
	Extent2D               minScaledImageExtent; 
	Extent2D               maxScaledImageExtent; 
}

struct SurfacePresentModeCompatibilityEXT {
	StructureType   sType; 
	void*           pNext; 
	uint            presentModeCount; 
	PresentModeKHR* pPresentModes; 
}

struct PhysicalDeviceSwapchainMaintenance1FeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          swapchainMaintenance1; 
}

struct SwapchainPresentFenceInfoEXT {
	StructureType sType; 
	void*         pNext; 
	uint          swapchainCount; 
	Fence*        pFences; 
}

struct SwapchainPresentModesCreateInfoEXT {
	StructureType   sType; 
	void*           pNext; 
	uint            presentModeCount; 
	PresentModeKHR* pPresentModes; 
}

struct SwapchainPresentModeInfoEXT {
	StructureType   sType; 
	void*           pNext; 
	uint            swapchainCount; 
	PresentModeKHR* pPresentModes; 
}

struct SwapchainPresentScalingCreateInfoEXT {
	StructureType          sType; 
	void*                  pNext; 
	PresentScalingFlagsEXT scalingBehavior; 
	PresentGravityFlagsEXT presentGravityX; 
	PresentGravityFlagsEXT presentGravityY; 
}

struct ReleaseSwapchainImagesInfoEXT {
	StructureType sType; 
	void*         pNext; 
	SwapchainKHR  swapchain; 
	uint          imageIndexCount; 
	uint*         pImageIndices; 
}

struct PhysicalDeviceDeviceGeneratedCommandsPropertiesNV {
	StructureType sType; 
	void*         pNext; 
	uint          maxGraphicsShaderGroupCount; 
	uint          maxIndirectSequenceCount; 
	uint          maxIndirectCommandsTokenCount; 
	uint          maxIndirectCommandsStreamCount; 
	uint          maxIndirectCommandsTokenOffset; 
	uint          maxIndirectCommandsStreamStride; 
	uint          minSequencesCountBufferOffsetAlignment; 
	uint          minSequencesIndexBufferOffsetAlignment; 
	uint          minIndirectCommandsBufferOffsetAlignment; 
}

struct PhysicalDeviceDeviceGeneratedCommandsFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          deviceGeneratedCommands; 
}

struct GraphicsShaderGroupCreateInfoNV {
	StructureType                        sType; 
	void*                                pNext; 
	uint                                 stageCount; 
	PipelineShaderStageCreateInfo*       pStages; 
	PipelineVertexInputStateCreateInfo*  pVertexInputState; 
	PipelineTessellationStateCreateInfo* pTessellationState; 
}

struct GraphicsPipelineShaderGroupsCreateInfoNV {
	StructureType                    sType; 
	void*                            pNext; 
	uint                             groupCount; 
	GraphicsShaderGroupCreateInfoNV* pGroups; 
	uint                             pipelineCount; 
	Pipeline*                        pPipelines; 
}

struct BindShaderGroupIndirectCommandNV {
	uint groupIndex; 
}

struct BindIndexBufferIndirectCommandNV {
	DeviceAddress bufferAddress; 
	uint          size; 
	IndexType     indexType; 
}

struct BindVertexBufferIndirectCommandNV {
	DeviceAddress bufferAddress; 
	uint          size; 
	uint          stride; 
}

struct SetStateFlagsIndirectCommandNV {
	uint data; 
}

struct IndirectCommandsStreamNV {
	Buffer     buffer; 
	DeviceSize offset; 
}

struct IndirectCommandsLayoutTokenNV {
	StructureType               sType; 
	void*                       pNext; 
	IndirectCommandsTokenTypeNV tokenType; 
	uint                        stream; 
	uint                        offset; 
	uint                        vertexBindingUnit; 
	uint                        vertexDynamicStride; 
	PipelineLayout              pushconstantPipelineLayout; 
	ShaderStageFlags            pushconstantShaderStageFlags; 
	uint                        pushconstantOffset; 
	uint                        pushconstantSize; 
	IndirectStateFlagsNV        indirectStateFlags; 
	uint                        indexTypeCount; 
	IndexType*                  pIndexTypes; 
	uint*                       pIndexTypeValues; 
}

struct IndirectCommandsLayoutCreateInfoNV {
	StructureType                      sType; 
	void*                              pNext; 
	IndirectCommandsLayoutUsageFlagsNV flags; 
	PipelineBindPoint                  pipelineBindPoint; 
	uint                               tokenCount; 
	IndirectCommandsLayoutTokenNV*     pTokens; 
	uint                               streamCount; 
	uint*                              pStreamStrides; 
}

struct GeneratedCommandsInfoNV {
	StructureType             sType; 
	void*                     pNext; 
	PipelineBindPoint         pipelineBindPoint; 
	Pipeline                  pipeline; 
	IndirectCommandsLayoutNV  indirectCommandsLayout; 
	uint                      streamCount; 
	IndirectCommandsStreamNV* pStreams; 
	uint                      sequencesCount; 
	Buffer                    preprocessBuffer; 
	DeviceSize                preprocessOffset; 
	DeviceSize                preprocessSize; 
	Buffer                    sequencesCountBuffer; 
	DeviceSize                sequencesCountOffset; 
	Buffer                    sequencesIndexBuffer; 
	DeviceSize                sequencesIndexOffset; 
}

struct GeneratedCommandsMemoryRequirementsInfoNV {
	StructureType            sType; 
	void*                    pNext; 
	PipelineBindPoint        pipelineBindPoint; 
	Pipeline                 pipeline; 
	IndirectCommandsLayoutNV indirectCommandsLayout; 
	uint                     maxSequencesCount; 
}

struct PhysicalDeviceInheritedViewportScissorFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          inheritedViewportScissor2D; 
}

struct CommandBufferInheritanceViewportScissorInfoNV {
	StructureType sType; 
	void*         pNext; 
	uint          viewportScissor2D; 
	uint          viewportDepthCount; 
	Viewport*     pViewportDepths; 
}

struct PhysicalDeviceTexelBufferAlignmentFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          texelBufferAlignment; 
}

struct RenderPassTransformBeginInfoQCOM {
	StructureType            sType; 
	void*                    pNext; 
	SurfaceTransformFlagsKHR transform; 
}

struct CommandBufferInheritanceRenderPassTransformInfoQCOM {
	StructureType            sType; 
	void*                    pNext; 
	SurfaceTransformFlagsKHR transform; 
	Rect2D                   renderArea; 
}

struct PhysicalDeviceDepthBiasControlFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          depthBiasControl; 
	uint          leastRepresentableValueForceUnormRepresentation; 
	uint          floatRepresentation; 
	uint          depthBiasExact; 
}

struct DepthBiasInfoEXT {
	StructureType sType; 
	void*         pNext; 
	float         depthBiasConstantFactor; 
	float         depthBiasClamp; 
	float         depthBiasSlopeFactor; 
}

struct DepthBiasRepresentationInfoEXT {
	StructureType              sType; 
	void*                      pNext; 
	DepthBiasRepresentationEXT depthBiasRepresentation; 
	uint                       depthBiasExact; 
}

struct PhysicalDeviceDeviceMemoryReportFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          deviceMemoryReport; 
}

struct DeviceMemoryReportCallbackDataEXT {
	StructureType                  sType; 
	void*                          pNext; 
	DeviceMemoryReportFlagsEXT     flags; 
	DeviceMemoryReportEventTypeEXT type; 
	ulong                          memoryObjectId; 
	DeviceSize                     size; 
	ObjectType                     objectType; 
	ulong                          objectHandle; 
	uint                           heapIndex; 
}

struct DeviceDeviceMemoryReportCreateInfoEXT {
	StructureType                     sType; 
	void*                             pNext; 
	DeviceMemoryReportFlagsEXT        flags; 
	ProcDeviceMemoryReportCallbackEXT pfnUserCallback; 
	void*                             pUserData; 
}

struct PhysicalDeviceRobustness2FeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          robustBufferAccess2; 
	uint          robustImageAccess2; 
	uint          nullDescriptor; 
}

struct PhysicalDeviceRobustness2PropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	DeviceSize    robustStorageBufferAccessSizeAlignment; 
	DeviceSize    robustUniformBufferAccessSizeAlignment; 
}

struct SamplerCustomBorderColorCreateInfoEXT {
	StructureType   sType; 
	void*           pNext; 
	ClearColorValue customBorderColor; 
	Format          format; 
}

struct PhysicalDeviceCustomBorderColorPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          maxCustomBorderColorSamplers; 
}

struct PhysicalDeviceCustomBorderColorFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          customBorderColors; 
	uint          customBorderColorWithoutFormat; 
}

struct PhysicalDevicePresentBarrierFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          presentBarrier; 
}

struct SurfaceCapabilitiesPresentBarrierNV {
	StructureType sType; 
	void*         pNext; 
	uint          presentBarrierSupported; 
}

struct SwapchainPresentBarrierCreateInfoNV {
	StructureType sType; 
	void*         pNext; 
	uint          presentBarrierEnable; 
}

struct PhysicalDeviceDiagnosticsConfigFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          diagnosticsConfig; 
}

struct DeviceDiagnosticsConfigCreateInfoNV {
	StructureType                  sType; 
	void*                          pNext; 
	DeviceDiagnosticsConfigFlagsNV flags; 
}

struct CudaModuleCreateInfoNV {
	StructureType sType; 
	void*         pNext; 
	usz           dataSize; 
	void*         pData; 
}

struct CudaFunctionCreateInfoNV {
	StructureType sType; 
	void*         pNext; 
	CudaModuleNV  module_; 
	ZString       pName; 
}

struct CudaLaunchInfoNV {
	StructureType  sType; 
	void*          pNext; 
	CudaFunctionNV function; 
	uint           gridDimX; 
	uint           gridDimY; 
	uint           gridDimZ; 
	uint           blockDimX; 
	uint           blockDimY; 
	uint           blockDimZ; 
	uint           sharedMemBytes; 
	usz            paramCount; 
	void**         pParams; 
	usz            extraCount; 
	void**         pExtras; 
}

struct PhysicalDeviceCudaKernelLaunchFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          cudaKernelLaunchFeatures; 
}

struct PhysicalDeviceCudaKernelLaunchPropertiesNV {
	StructureType sType; 
	void*         pNext; 
	uint          computeCapabilityMinor; 
	uint          computeCapabilityMajor; 
}

struct QueryLowLatencySupportNV {
	StructureType sType; 
	void*         pNext; 
	void*         pQueriedLowLatencyData; 
}

struct PhysicalDeviceDescriptorBufferPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          combinedImageSamplerDescriptorSingleArray; 
	uint          bufferlessPushDescriptors; 
	uint          allowSamplerImageViewPostSubmitCreation; 
	DeviceSize    descriptorBufferOffsetAlignment; 
	uint          maxDescriptorBufferBindings; 
	uint          maxResourceDescriptorBufferBindings; 
	uint          maxSamplerDescriptorBufferBindings; 
	uint          maxEmbeddedImmutableSamplerBindings; 
	uint          maxEmbeddedImmutableSamplers; 
	usz           bufferCaptureReplayDescriptorDataSize; 
	usz           imageCaptureReplayDescriptorDataSize; 
	usz           imageViewCaptureReplayDescriptorDataSize; 
	usz           samplerCaptureReplayDescriptorDataSize; 
	usz           accelerationStructureCaptureReplayDescriptorDataSize; 
	usz           samplerDescriptorSize; 
	usz           combinedImageSamplerDescriptorSize; 
	usz           sampledImageDescriptorSize; 
	usz           storageImageDescriptorSize; 
	usz           uniformTexelBufferDescriptorSize; 
	usz           robustUniformTexelBufferDescriptorSize; 
	usz           storageTexelBufferDescriptorSize; 
	usz           robustStorageTexelBufferDescriptorSize; 
	usz           uniformBufferDescriptorSize; 
	usz           robustUniformBufferDescriptorSize; 
	usz           storageBufferDescriptorSize; 
	usz           robustStorageBufferDescriptorSize; 
	usz           inputAttachmentDescriptorSize; 
	usz           accelerationStructureDescriptorSize; 
	DeviceSize    maxSamplerDescriptorBufferRange; 
	DeviceSize    maxResourceDescriptorBufferRange; 
	DeviceSize    samplerDescriptorBufferAddressSpaceSize; 
	DeviceSize    resourceDescriptorBufferAddressSpaceSize; 
	DeviceSize    descriptorBufferAddressSpaceSize; 
}

struct PhysicalDeviceDescriptorBufferDensityMapPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	usz           combinedImageSamplerDensityMapDescriptorSize; 
}

struct PhysicalDeviceDescriptorBufferFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          descriptorBuffer; 
	uint          descriptorBufferCaptureReplay; 
	uint          descriptorBufferImageLayoutIgnored; 
	uint          descriptorBufferPushDescriptors; 
}

struct DescriptorAddressInfoEXT {
	StructureType sType; 
	void*         pNext; 
	DeviceAddress address; 
	DeviceSize    range; 
	Format        format; 
}

struct DescriptorBufferBindingInfoEXT {
	StructureType    sType; 
	void*            pNext; 
	DeviceAddress    address; 
	BufferUsageFlags usage; 
}

struct DescriptorBufferBindingPushDescriptorBufferHandleEXT {
	StructureType sType; 
	void*         pNext; 
	Buffer        buffer; 
}

union DescriptorDataEXT {
	Sampler*                  pSampler; 
	DescriptorImageInfo*      pCombinedImageSampler; 
	DescriptorImageInfo*      pInputAttachmentImage; 
	DescriptorImageInfo*      pSampledImage; 
	DescriptorImageInfo*      pStorageImage; 
	DescriptorAddressInfoEXT* pUniformTexelBuffer; 
	DescriptorAddressInfoEXT* pStorageTexelBuffer; 
	DescriptorAddressInfoEXT* pUniformBuffer; 
	DescriptorAddressInfoEXT* pStorageBuffer; 
	DeviceAddress             accelerationStructure; 
}

struct DescriptorGetInfoEXT {
	StructureType     sType; 
	void*             pNext; 
	DescriptorType    type; 
	DescriptorDataEXT data; 
}

struct BufferCaptureDescriptorDataInfoEXT {
	StructureType sType; 
	void*         pNext; 
	Buffer        buffer; 
}

struct ImageCaptureDescriptorDataInfoEXT {
	StructureType sType; 
	void*         pNext; 
	Image         image; 
}

struct ImageViewCaptureDescriptorDataInfoEXT {
	StructureType sType; 
	void*         pNext; 
	ImageView     imageView; 
}

struct SamplerCaptureDescriptorDataInfoEXT {
	StructureType sType; 
	void*         pNext; 
	Sampler       sampler; 
}

struct OpaqueCaptureDescriptorDataCreateInfoEXT {
	StructureType sType; 
	void*         pNext; 
	void*         opaqueCaptureDescriptorData; 
}

struct AccelerationStructureCaptureDescriptorDataInfoEXT {
	StructureType            sType; 
	void*                    pNext; 
	AccelerationStructureKHR accelerationStructure; 
	AccelerationStructureNV  accelerationStructureNV; 
}

struct PhysicalDeviceGraphicsPipelineLibraryFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          graphicsPipelineLibrary; 
}

struct PhysicalDeviceGraphicsPipelineLibraryPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          graphicsPipelineLibraryFastLinking; 
	uint          graphicsPipelineLibraryIndependentInterpolationDecoration; 
}

struct GraphicsPipelineLibraryCreateInfoEXT {
	StructureType                   sType; 
	void*                           pNext; 
	GraphicsPipelineLibraryFlagsEXT flags; 
}

struct PhysicalDeviceShaderEarlyAndLateFragmentTestsFeaturesAMD {
	StructureType sType; 
	void*         pNext; 
	uint          shaderEarlyAndLateFragmentTests; 
}

struct PhysicalDeviceFragmentShadingRateEnumsFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          fragmentShadingRateEnums; 
	uint          supersampleFragmentShadingRates; 
	uint          noInvocationFragmentShadingRates; 
}

struct PhysicalDeviceFragmentShadingRateEnumsPropertiesNV {
	StructureType    sType; 
	void*            pNext; 
	SampleCountFlags maxFragmentShadingRateInvocationCount; 
}

struct PipelineFragmentShadingRateEnumStateCreateInfoNV {
	StructureType                       sType; 
	void*                               pNext; 
	FragmentShadingRateTypeNV           shadingRateType; 
	FragmentShadingRateNV               shadingRate; 
	FragmentShadingRateCombinerOpKHR[2] combinerOps; 
}

union DeviceOrHostAddressConstKHR {
	DeviceAddress deviceAddress; 
	void*         hostAddress; 
}

struct AccelerationStructureGeometryMotionTrianglesDataNV {
	StructureType               sType; 
	void*                       pNext; 
	DeviceOrHostAddressConstKHR vertexData; 
}

struct AccelerationStructureMotionInfoNV {
	StructureType                          sType; 
	void*                                  pNext; 
	uint                                   maxInstances; 
	AccelerationStructureMotionInfoFlagsNV flags; 
}

struct AccelerationStructureMatrixMotionInstanceNV {
	TransformMatrixKHR transformT0; 
	TransformMatrixKHR transformT1; 
	uint               instanceCustomIndexAndMask;  // Most significant byte is mask
	uint               instanceShaderBindingTableRecordOffsetAndFlags;  // Most significant byte is flags
	ulong              accelerationStructureReference; 
}

struct SRTDataNV {
	float sx; 
	float a; 
	float b; 
	float pvx; 
	float sy; 
	float c; 
	float pvy; 
	float sz; 
	float pvz; 
	float qx; 
	float qy; 
	float qz; 
	float qw; 
	float tx; 
	float ty; 
	float tz; 
}

struct AccelerationStructureSRTMotionInstanceNV {
	SRTDataNV transformT0; 
	SRTDataNV transformT1; 
	uint      instanceCustomIndexAndMask;  // Most significant byte is mask
	uint      instanceShaderBindingTableRecordOffsetAndFlags;  // Most significant byte is flags
	ulong     accelerationStructureReference; 
}

union AccelerationStructureMotionInstanceDataNV {
	AccelerationStructureInstanceKHR            staticInstance; 
	AccelerationStructureMatrixMotionInstanceNV matrixMotionInstance; 
	AccelerationStructureSRTMotionInstanceNV    srtMotionInstance; 
}

struct AccelerationStructureMotionInstanceNV {
	AccelerationStructureMotionInstanceTypeNV  type; 
	AccelerationStructureMotionInstanceFlagsNV flags; 
	AccelerationStructureMotionInstanceDataNV  data; 
}

struct PhysicalDeviceRayTracingMotionBlurFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          rayTracingMotionBlur; 
	uint          rayTracingMotionBlurPipelineTraceRaysIndirect; 
}

struct PhysicalDeviceYcbcr2Plane444FormatsFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          ycbcr2plane444Formats; 
}

struct PhysicalDeviceFragmentDensityMap2FeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          fragmentDensityMapDeferred; 
}

struct PhysicalDeviceFragmentDensityMap2PropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          subsampledLoads; 
	uint          subsampledCoarseReconstructionEarlyAccess; 
	uint          maxSubsampledArrayLayers; 
	uint          maxDescriptorSetSubsampledSamplers; 
}

struct CopyCommandTransformInfoQCOM {
	StructureType            sType; 
	void*                    pNext; 
	SurfaceTransformFlagsKHR transform; 
}

struct PhysicalDeviceImageCompressionControlFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          imageCompressionControl; 
}

struct ImageCompressionControlEXT {
	StructureType                      sType; 
	void*                              pNext; 
	ImageCompressionFlagsEXT           flags; 
	uint                               compressionControlPlaneCount; 
	ImageCompressionFixedRateFlagsEXT* pFixedRateFlags; 
}

struct ImageCompressionPropertiesEXT {
	StructureType                     sType; 
	void*                             pNext; 
	ImageCompressionFlagsEXT          imageCompressionFlags; 
	ImageCompressionFixedRateFlagsEXT imageCompressionFixedRateFlags; 
}

struct PhysicalDeviceAttachmentFeedbackLoopLayoutFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          attachmentFeedbackLoopLayout; 
}

struct PhysicalDevice4444FormatsFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          formatA4R4G4B4; 
	uint          formatA4B4G4R4; 
}

struct PhysicalDeviceFaultFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          deviceFault; 
	uint          deviceFaultVendorBinary; 
}

struct DeviceFaultCountsEXT {
	StructureType sType; 
	void*         pNext; 
	uint          addressInfoCount; 
	uint          vendorInfoCount; 
	DeviceSize    vendorBinarySize; 
}

struct DeviceFaultAddressInfoEXT {
	DeviceFaultAddressTypeEXT addressType; 
	DeviceAddress             reportedAddress; 
	DeviceSize                addressPrecision; 
}

struct DeviceFaultVendorInfoEXT {
	ichar[MAX_DESCRIPTION_SIZE] description; 
	ulong                       vendorFaultCode; 
	ulong                       vendorFaultData; 
}

struct DeviceFaultInfoEXT {
	StructureType               sType; 
	void*                       pNext; 
	ichar[MAX_DESCRIPTION_SIZE] description; 
	DeviceFaultAddressInfoEXT*  pAddressInfos; 
	DeviceFaultVendorInfoEXT*   pVendorInfos; 
	void*                       pVendorBinaryData; 
}

struct DeviceFaultVendorBinaryHeaderVersionOneEXT {
	uint                                    headerSize; 
	DeviceFaultVendorBinaryHeaderVersionEXT headerVersion; 
	uint                                    vendorID; 
	uint                                    deviceID; 
	uint                                    driverVersion; 
	char[UUID_SIZE]                         pipelineCacheUUID; 
	uint                                    applicationNameOffset; 
	uint                                    applicationVersion; 
	uint                                    engineNameOffset; 
	uint                                    engineVersion; 
	uint                                    apiVersion; 
}

struct PhysicalDeviceRasterizationOrderAttachmentAccessFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          rasterizationOrderColorAttachmentAccess; 
	uint          rasterizationOrderDepthAttachmentAccess; 
	uint          rasterizationOrderStencilAttachmentAccess; 
}

struct PhysicalDeviceRGBA10X6FormatsFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          formatRgba10x6WithoutYCbCrSampler; 
}

struct PhysicalDeviceMutableDescriptorTypeFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          mutableDescriptorType; 
}

struct MutableDescriptorTypeListEXT {
	uint            descriptorTypeCount; 
	DescriptorType* pDescriptorTypes; 
}

struct MutableDescriptorTypeCreateInfoEXT {
	StructureType                 sType; 
	void*                         pNext; 
	uint                          mutableDescriptorTypeListCount; 
	MutableDescriptorTypeListEXT* pMutableDescriptorTypeLists; 
}

struct PhysicalDeviceVertexInputDynamicStateFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          vertexInputDynamicState; 
}

struct VertexInputBindingDescription2EXT {
	StructureType   sType; 
	void*           pNext; 
	uint            binding; 
	uint            stride; 
	VertexInputRate inputRate; 
	uint            divisor; 
}

struct VertexInputAttributeDescription2EXT {
	StructureType sType; 
	void*         pNext; 
	uint          location; 
	uint          binding; 
	Format        format; 
	uint          offset; 
}

struct PhysicalDeviceDrmPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          hasPrimary; 
	uint          hasRender; 
	long          primaryMajor; 
	long          primaryMinor; 
	long          renderMajor; 
	long          renderMinor; 
}

struct PhysicalDeviceAddressBindingReportFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          reportAddressBinding; 
}

struct DeviceAddressBindingCallbackDataEXT {
	StructureType                sType; 
	void*                        pNext; 
	DeviceAddressBindingFlagsEXT flags; 
	DeviceAddress                baseAddress; 
	DeviceSize                   size; 
	DeviceAddressBindingTypeEXT  bindingType; 
}

struct PhysicalDeviceDepthClipControlFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          depthClipControl; 
}

struct PipelineViewportDepthClipControlCreateInfoEXT {
	StructureType sType; 
	void*         pNext; 
	uint          negativeOneToOne; 
}

struct PhysicalDevicePrimitiveTopologyListRestartFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          primitiveTopologyListRestart; 
	uint          primitiveTopologyPatchListRestart; 
}

struct PhysicalDevicePresentModeFifoLatestReadyFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          presentModeFifoLatestReady; 
}

struct SubpassShadingPipelineCreateInfoHUAWEI {
	StructureType sType; 
	void*         pNext; 
	RenderPass    renderPass; 
	uint          subpass; 
}

struct PhysicalDeviceSubpassShadingFeaturesHUAWEI {
	StructureType sType; 
	void*         pNext; 
	uint          subpassShading; 
}

struct PhysicalDeviceSubpassShadingPropertiesHUAWEI {
	StructureType sType; 
	void*         pNext; 
	uint          maxSubpassShadingWorkgroupSizeAspectRatio; 
}

struct PhysicalDeviceInvocationMaskFeaturesHUAWEI {
	StructureType sType; 
	void*         pNext; 
	uint          invocationMask; 
}

struct MemoryGetRemoteAddressInfoNV {
	StructureType                 sType; 
	void*                         pNext; 
	DeviceMemory                  memory; 
	ExternalMemoryHandleTypeFlags handleType; 
}

struct PhysicalDeviceExternalMemoryRDMAFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          externalMemoryRDMA; 
}

struct PipelinePropertiesIdentifierEXT {
	StructureType   sType; 
	void*           pNext; 
	char[UUID_SIZE] pipelineIdentifier; 
}

struct PhysicalDevicePipelinePropertiesFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          pipelinePropertiesIdentifier; 
}

struct PhysicalDeviceFrameBoundaryFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          frameBoundary; 
}

struct FrameBoundaryEXT {
	StructureType         sType; 
	void*                 pNext; 
	FrameBoundaryFlagsEXT flags; 
	ulong                 frameID; 
	uint                  imageCount; 
	Image*                pImages; 
	uint                  bufferCount; 
	Buffer*               pBuffers; 
	ulong                 tagName; 
	usz                   tagSize; 
	void*                 pTag; 
}

struct PhysicalDeviceMultisampledRenderToSingleSampledFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          multisampledRenderToSingleSampled; 
}

struct SubpassResolvePerformanceQueryEXT {
	StructureType sType; 
	void*         pNext; 
	uint          optimal; 
}

struct MultisampledRenderToSingleSampledInfoEXT {
	StructureType    sType; 
	void*            pNext; 
	uint             multisampledRenderToSingleSampledEnable; 
	SampleCountFlags rasterizationSamples; 
}

struct PhysicalDeviceExtendedDynamicState2FeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          extendedDynamicState2; 
	uint          extendedDynamicState2LogicOp; 
	uint          extendedDynamicState2PatchControlPoints; 
}

struct PhysicalDeviceColorWriteEnableFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          colorWriteEnable; 
}

struct PipelineColorWriteCreateInfoEXT {
	StructureType sType; 
	void*         pNext; 
	uint          attachmentCount; 
	uint*         pColorWriteEnables; 
}

struct PhysicalDevicePrimitivesGeneratedQueryFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          primitivesGeneratedQuery; 
	uint          primitivesGeneratedQueryWithRasterizerDiscard; 
	uint          primitivesGeneratedQueryWithNonZeroStreams; 
}

struct PhysicalDeviceImageViewMinLodFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          minLod; 
}

struct ImageViewMinLodCreateInfoEXT {
	StructureType sType; 
	void*         pNext; 
	float         minLod; 
}

struct PhysicalDeviceMultiDrawFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          multiDraw; 
}

struct PhysicalDeviceMultiDrawPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          maxMultiDrawCount; 
}

struct MultiDrawInfoEXT {
	uint firstVertex; 
	uint vertexCount; 
}

struct MultiDrawIndexedInfoEXT {
	uint firstIndex; 
	uint indexCount; 
	int  vertexOffset; 
}

struct PhysicalDeviceImage2DViewOf3DFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          image2DViewOf3D; 
	uint          sampler2DViewOf3D; 
}

struct PhysicalDeviceShaderTileImageFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          shaderTileImageColorReadAccess; 
	uint          shaderTileImageDepthReadAccess; 
	uint          shaderTileImageStencilReadAccess; 
}

struct PhysicalDeviceShaderTileImagePropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          shaderTileImageCoherentReadAccelerated; 
	uint          shaderTileImageReadSampleFromPixelRateInvocation; 
	uint          shaderTileImageReadFromHelperInvocation; 
}

struct MicromapUsageEXT {
	uint count; 
	uint subdivisionLevel; 
	uint format; 
}

union DeviceOrHostAddressKHR {
	DeviceAddress deviceAddress; 
	void*         hostAddress; 
}

struct MicromapBuildInfoEXT {
	StructureType               sType; 
	void*                       pNext; 
	MicromapTypeEXT             type; 
	BuildMicromapFlagsEXT       flags; 
	BuildMicromapModeEXT        mode; 
	MicromapEXT                 dstMicromap; 
	uint                        usageCountsCount; 
	MicromapUsageEXT*           pUsageCounts; 
	MicromapUsageEXT*[]         ppUsageCounts; 
	DeviceOrHostAddressConstKHR data; 
	DeviceOrHostAddressKHR      scratchData; 
	DeviceOrHostAddressConstKHR triangleArray; 
	DeviceSize                  triangleArrayStride; 
}

struct MicromapCreateInfoEXT {
	StructureType          sType; 
	void*                  pNext; 
	MicromapCreateFlagsEXT createFlags; 
	Buffer                 buffer; 
	DeviceSize             offset; 
	DeviceSize             size; 
	MicromapTypeEXT        type; 
	DeviceAddress          deviceAddress; 
}

struct PhysicalDeviceOpacityMicromapFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          micromap; 
	uint          micromapCaptureReplay; 
	uint          micromapHostCommands; 
}

struct PhysicalDeviceOpacityMicromapPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          maxOpacity2StateSubdivisionLevel; 
	uint          maxOpacity4StateSubdivisionLevel; 
}

struct MicromapVersionInfoEXT {
	StructureType sType; 
	void*         pNext; 
	char*         pVersionData; 
}

struct CopyMicromapToMemoryInfoEXT {
	StructureType          sType; 
	void*                  pNext; 
	MicromapEXT            src; 
	DeviceOrHostAddressKHR dst; 
	CopyMicromapModeEXT    mode; 
}

struct CopyMemoryToMicromapInfoEXT {
	StructureType               sType; 
	void*                       pNext; 
	DeviceOrHostAddressConstKHR src; 
	MicromapEXT                 dst; 
	CopyMicromapModeEXT         mode; 
}

struct CopyMicromapInfoEXT {
	StructureType       sType; 
	void*               pNext; 
	MicromapEXT         src; 
	MicromapEXT         dst; 
	CopyMicromapModeEXT mode; 
}

struct MicromapBuildSizesInfoEXT {
	StructureType sType; 
	void*         pNext; 
	DeviceSize    micromapSize; 
	DeviceSize    buildScratchSize; 
	uint          discardable; 
}

struct AccelerationStructureTrianglesOpacityMicromapEXT {
	StructureType               sType; 
	void*                       pNext; 
	IndexType                   indexType; 
	DeviceOrHostAddressConstKHR indexBuffer; 
	DeviceSize                  indexStride; 
	uint                        baseTriangle; 
	uint                        usageCountsCount; 
	MicromapUsageEXT*           pUsageCounts; 
	MicromapUsageEXT*[]         ppUsageCounts; 
	MicromapEXT                 micromap; 
}

struct MicromapTriangleEXT {
	uint   dataOffset; 
	ushort subdivisionLevel; 
	ushort format; 
}

struct PhysicalDeviceClusterCullingShaderFeaturesHUAWEI {
	StructureType sType; 
	void*         pNext; 
	uint          clustercullingShader; 
	uint          multiviewClusterCullingShader; 
}

struct PhysicalDeviceClusterCullingShaderPropertiesHUAWEI {
	StructureType sType; 
	void*         pNext; 
	uint[3]       maxWorkGroupCount; 
	uint[3]       maxWorkGroupSize; 
	uint          maxOutputClusterCount; 
	DeviceSize    indirectBufferOffsetAlignment; 
}

struct PhysicalDeviceClusterCullingShaderVrsFeaturesHUAWEI {
	StructureType sType; 
	void*         pNext; 
	uint          clusterShadingRate; 
}

struct PhysicalDeviceBorderColorSwizzleFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          borderColorSwizzle; 
	uint          borderColorSwizzleFromImage; 
}

struct SamplerBorderColorComponentMappingCreateInfoEXT {
	StructureType    sType; 
	void*            pNext; 
	ComponentMapping components; 
	uint             srgb; 
}

struct PhysicalDevicePageableDeviceLocalMemoryFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          pageableDeviceLocalMemory; 
}

struct PhysicalDeviceShaderCorePropertiesARM {
	StructureType sType; 
	void*         pNext; 
	uint          pixelRate; 
	uint          texelRate; 
	uint          fmaRate; 
}

struct DeviceQueueShaderCoreControlCreateInfoARM {
	StructureType sType; 
	void*         pNext; 
	uint          shaderCoreCount; 
}

struct PhysicalDeviceSchedulingControlsFeaturesARM {
	StructureType sType; 
	void*         pNext; 
	uint          schedulingControls; 
}

struct PhysicalDeviceSchedulingControlsPropertiesARM {
	StructureType                            sType; 
	void*                                    pNext; 
	PhysicalDeviceSchedulingControlsFlagsARM schedulingControlsFlags; 
}

struct PhysicalDeviceImageSlicedViewOf3DFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          imageSlicedViewOf3D; 
}

struct ImageViewSlicedCreateInfoEXT {
	StructureType sType; 
	void*         pNext; 
	uint          sliceOffset; 
	uint          sliceCount; 
}

struct PhysicalDeviceDescriptorSetHostMappingFeaturesVALVE {
	StructureType sType; 
	void*         pNext; 
	uint          descriptorSetHostMapping; 
}

struct DescriptorSetBindingReferenceVALVE {
	StructureType       sType; 
	void*               pNext; 
	DescriptorSetLayout descriptorSetLayout; 
	uint                binding; 
}

struct DescriptorSetLayoutHostMappingInfoVALVE {
	StructureType sType; 
	void*         pNext; 
	usz           descriptorOffset; 
	uint          descriptorSize; 
}

struct PhysicalDeviceDepthClampZeroOneFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          depthClampZeroOne; 
}

struct PhysicalDeviceNonSeamlessCubeMapFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          nonSeamlessCubeMap; 
}

struct PhysicalDeviceRenderPassStripedFeaturesARM {
	StructureType sType; 
	void*         pNext; 
	uint          renderPassStriped; 
}

struct PhysicalDeviceRenderPassStripedPropertiesARM {
	StructureType sType; 
	void*         pNext; 
	Extent2D      renderPassStripeGranularity; 
	uint          maxRenderPassStripes; 
}

struct RenderPassStripeInfoARM {
	StructureType sType; 
	void*         pNext; 
	Rect2D        stripeArea; 
}

struct RenderPassStripeBeginInfoARM {
	StructureType            sType; 
	void*                    pNext; 
	uint                     stripeInfoCount; 
	RenderPassStripeInfoARM* pStripeInfos; 
}

struct RenderPassStripeSubmitInfoARM {
	StructureType        sType; 
	void*                pNext; 
	uint                 stripeSemaphoreInfoCount; 
	SemaphoreSubmitInfo* pStripeSemaphoreInfos; 
}

struct PhysicalDeviceFragmentDensityMapOffsetFeaturesQCOM {
	StructureType sType; 
	void*         pNext; 
	uint          fragmentDensityMapOffset; 
}

struct PhysicalDeviceFragmentDensityMapOffsetPropertiesQCOM {
	StructureType sType; 
	void*         pNext; 
	Extent2D      fragmentDensityOffsetGranularity; 
}

struct SubpassFragmentDensityMapOffsetEndInfoQCOM {
	StructureType sType; 
	void*         pNext; 
	uint          fragmentDensityOffsetCount; 
	Offset2D*     pFragmentDensityOffsets; 
}

struct CopyMemoryIndirectCommandNV {
	DeviceAddress srcAddress; 
	DeviceAddress dstAddress; 
	DeviceSize    size; 
}

struct CopyMemoryToImageIndirectCommandNV {
	DeviceAddress          srcAddress; 
	uint                   bufferRowLength; 
	uint                   bufferImageHeight; 
	ImageSubresourceLayers imageSubresource; 
	Offset3D               imageOffset; 
	Extent3D               imageExtent; 
}

struct PhysicalDeviceCopyMemoryIndirectFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          indirectCopy; 
}

struct PhysicalDeviceCopyMemoryIndirectPropertiesNV {
	StructureType sType; 
	void*         pNext; 
	QueueFlags    supportedQueues; 
}

struct DecompressMemoryRegionNV {
	DeviceAddress                    srcAddress; 
	DeviceAddress                    dstAddress; 
	DeviceSize                       compressedSize; 
	DeviceSize                       decompressedSize; 
	MemoryDecompressionMethodFlagsNV decompressionMethod; 
}

struct PhysicalDeviceMemoryDecompressionFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          memoryDecompression; 
}

struct PhysicalDeviceMemoryDecompressionPropertiesNV {
	StructureType                    sType; 
	void*                            pNext; 
	MemoryDecompressionMethodFlagsNV decompressionMethods; 
	ulong                            maxDecompressionIndirectCount; 
}

struct PhysicalDeviceDeviceGeneratedCommandsComputeFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          deviceGeneratedCompute; 
	uint          deviceGeneratedComputePipelines; 
	uint          deviceGeneratedComputeCaptureReplay; 
}

struct ComputePipelineIndirectBufferInfoNV {
	StructureType sType; 
	void*         pNext; 
	DeviceAddress deviceAddress; 
	DeviceSize    size; 
	DeviceAddress pipelineDeviceAddressCaptureReplay; 
}

struct PipelineIndirectDeviceAddressInfoNV {
	StructureType     sType; 
	void*             pNext; 
	PipelineBindPoint pipelineBindPoint; 
	Pipeline          pipeline; 
}

struct BindPipelineIndirectCommandNV {
	DeviceAddress pipelineAddress; 
}

struct PhysicalDeviceLinearColorAttachmentFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          linearColorAttachment; 
}

struct PhysicalDeviceImageCompressionControlSwapchainFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          imageCompressionControlSwapchain; 
}

struct ImageViewSampleWeightCreateInfoQCOM {
	StructureType sType; 
	void*         pNext; 
	Offset2D      filterCenter; 
	Extent2D      filterSize; 
	uint          numPhases; 
}

struct PhysicalDeviceImageProcessingFeaturesQCOM {
	StructureType sType; 
	void*         pNext; 
	uint          textureSampleWeighted; 
	uint          textureBoxFilter; 
	uint          textureBlockMatch; 
}

struct PhysicalDeviceImageProcessingPropertiesQCOM {
	StructureType sType; 
	void*         pNext; 
	uint          maxWeightFilterPhases; 
	Extent2D      maxWeightFilterDimension; 
	Extent2D      maxBlockMatchRegion; 
	Extent2D      maxBoxFilterBlockSize; 
}

struct PhysicalDeviceNestedCommandBufferFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          nestedCommandBuffer; 
	uint          nestedCommandBufferRendering; 
	uint          nestedCommandBufferSimultaneousUse; 
}

struct PhysicalDeviceNestedCommandBufferPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          maxCommandBufferNestingLevel; 
}

struct ExternalMemoryAcquireUnmodifiedEXT {
	StructureType sType; 
	void*         pNext; 
	uint          acquireUnmodifiedMemory; 
}

struct PhysicalDeviceExtendedDynamicState3FeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          extendedDynamicState3TessellationDomainOrigin; 
	uint          extendedDynamicState3DepthClampEnable; 
	uint          extendedDynamicState3PolygonMode; 
	uint          extendedDynamicState3RasterizationSamples; 
	uint          extendedDynamicState3SampleMask; 
	uint          extendedDynamicState3AlphaToCoverageEnable; 
	uint          extendedDynamicState3AlphaToOneEnable; 
	uint          extendedDynamicState3LogicOpEnable; 
	uint          extendedDynamicState3ColorBlendEnable; 
	uint          extendedDynamicState3ColorBlendEquation; 
	uint          extendedDynamicState3ColorWriteMask; 
	uint          extendedDynamicState3RasterizationStream; 
	uint          extendedDynamicState3ConservativeRasterizationMode; 
	uint          extendedDynamicState3ExtraPrimitiveOverestimationSize; 
	uint          extendedDynamicState3DepthClipEnable; 
	uint          extendedDynamicState3SampleLocationsEnable; 
	uint          extendedDynamicState3ColorBlendAdvanced; 
	uint          extendedDynamicState3ProvokingVertexMode; 
	uint          extendedDynamicState3LineRasterizationMode; 
	uint          extendedDynamicState3LineStippleEnable; 
	uint          extendedDynamicState3DepthClipNegativeOneToOne; 
	uint          extendedDynamicState3ViewportWScalingEnable; 
	uint          extendedDynamicState3ViewportSwizzle; 
	uint          extendedDynamicState3CoverageToColorEnable; 
	uint          extendedDynamicState3CoverageToColorLocation; 
	uint          extendedDynamicState3CoverageModulationMode; 
	uint          extendedDynamicState3CoverageModulationTableEnable; 
	uint          extendedDynamicState3CoverageModulationTable; 
	uint          extendedDynamicState3CoverageReductionMode; 
	uint          extendedDynamicState3RepresentativeFragmentTestEnable; 
	uint          extendedDynamicState3ShadingRateImageEnable; 
}

struct PhysicalDeviceExtendedDynamicState3PropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          dynamicPrimitiveTopologyUnrestricted; 
}

struct ColorBlendEquationEXT {
	BlendFactor srcColorBlendFactor; 
	BlendFactor dstColorBlendFactor; 
	BlendOp     colorBlendOp; 
	BlendFactor srcAlphaBlendFactor; 
	BlendFactor dstAlphaBlendFactor; 
	BlendOp     alphaBlendOp; 
}

struct ColorBlendAdvancedEXT {
	BlendOp         advancedBlendOp; 
	uint            srcPremultiplied; 
	uint            dstPremultiplied; 
	BlendOverlapEXT blendOverlap; 
	uint            clampResults; 
}

struct PhysicalDeviceSubpassMergeFeedbackFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          subpassMergeFeedback; 
}

struct RenderPassCreationControlEXT {
	StructureType sType; 
	void*         pNext; 
	uint          disallowMerging; 
}

struct RenderPassCreationFeedbackInfoEXT {
	uint postMergeSubpassCount; 
}

struct RenderPassCreationFeedbackCreateInfoEXT {
	StructureType                      sType; 
	void*                              pNext; 
	RenderPassCreationFeedbackInfoEXT* pRenderPassFeedback; 
}

struct RenderPassSubpassFeedbackInfoEXT {
	SubpassMergeStatusEXT       subpassMergeStatus; 
	ichar[MAX_DESCRIPTION_SIZE] description; 
	uint                        postMergeIndex; 
}

struct RenderPassSubpassFeedbackCreateInfoEXT {
	StructureType                     sType; 
	void*                             pNext; 
	RenderPassSubpassFeedbackInfoEXT* pSubpassFeedback; 
}

struct DirectDriverLoadingInfoLUNARG {
	StructureType                  sType; 
	void*                          pNext; 
	DirectDriverLoadingFlagsLUNARG flags; 
	ProcGetInstanceProcAddrLUNARG  pfnGetInstanceProcAddr; 
}

struct DirectDriverLoadingListLUNARG {
	StructureType                  sType; 
	void*                          pNext; 
	DirectDriverLoadingModeLUNARG  mode; 
	uint                           driverCount; 
	DirectDriverLoadingInfoLUNARG* pDrivers; 
}

struct PhysicalDeviceShaderModuleIdentifierFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          shaderModuleIdentifier; 
}

struct PhysicalDeviceShaderModuleIdentifierPropertiesEXT {
	StructureType   sType; 
	void*           pNext; 
	char[UUID_SIZE] shaderModuleIdentifierAlgorithmUUID; 
}

struct PipelineShaderStageModuleIdentifierCreateInfoEXT {
	StructureType sType; 
	void*         pNext; 
	uint          identifierSize; 
	char*         pIdentifier; 
}

struct ShaderModuleIdentifierEXT {
	StructureType                               sType; 
	void*                                       pNext; 
	uint                                        identifierSize; 
	char[MAX_SHADER_MODULE_IDENTIFIER_SIZE_EXT] identifier; 
}

struct PhysicalDeviceOpticalFlowFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          opticalFlow; 
}

struct PhysicalDeviceOpticalFlowPropertiesNV {
	StructureType              sType; 
	void*                      pNext; 
	OpticalFlowGridSizeFlagsNV supportedOutputGridSizes; 
	OpticalFlowGridSizeFlagsNV supportedHintGridSizes; 
	uint                       hintSupported; 
	uint                       costSupported; 
	uint                       bidirectionalFlowSupported; 
	uint                       globalFlowSupported; 
	uint                       minWidth; 
	uint                       minHeight; 
	uint                       maxWidth; 
	uint                       maxHeight; 
	uint                       maxNumRegionsOfInterest; 
}

struct OpticalFlowImageFormatInfoNV {
	StructureType           sType; 
	void*                   pNext; 
	OpticalFlowUsageFlagsNV usage; 
}

struct OpticalFlowImageFormatPropertiesNV {
	StructureType sType; 
	void*         pNext; 
	Format        format; 
}

struct OpticalFlowSessionCreateInfoNV {
	StructureType                   sType; 
	void*                           pNext; 
	uint                            width; 
	uint                            height; 
	Format                          imageFormat; 
	Format                          flowVectorFormat; 
	Format                          costFormat; 
	OpticalFlowGridSizeFlagsNV      outputGridSize; 
	OpticalFlowGridSizeFlagsNV      hintGridSize; 
	OpticalFlowPerformanceLevelNV   performanceLevel; 
	OpticalFlowSessionCreateFlagsNV flags; 
}

struct OpticalFlowSessionCreatePrivateDataInfoNV {
	StructureType sType; 
	void*         pNext; 
	uint          id; 
	uint          size; 
	void*         pPrivateData; 
}

struct OpticalFlowExecuteInfoNV {
	StructureType             sType; 
	void*                     pNext; 
	OpticalFlowExecuteFlagsNV flags; 
	uint                      regionCount; 
	Rect2D*                   pRegions; 
}

struct PhysicalDeviceLegacyDitheringFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          legacyDithering; 
}

struct PhysicalDeviceAntiLagFeaturesAMD {
	StructureType sType; 
	void*         pNext; 
	uint          antiLag; 
}

struct AntiLagPresentationInfoAMD {
	StructureType   sType; 
	void*           pNext; 
	AntiLagStageAMD stage; 
	ulong           frameIndex; 
}

struct AntiLagDataAMD {
	StructureType               sType; 
	void*                       pNext; 
	AntiLagModeAMD              mode; 
	uint                        maxFPS; 
	AntiLagPresentationInfoAMD* pPresentationInfo; 
}

struct PhysicalDeviceShaderObjectFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          shaderObject; 
}

struct PhysicalDeviceShaderObjectPropertiesEXT {
	StructureType   sType; 
	void*           pNext; 
	char[UUID_SIZE] shaderBinaryUUID; 
	uint            shaderBinaryVersion; 
}

struct ShaderCreateInfoEXT {
	StructureType        sType; 
	void*                pNext; 
	ShaderCreateFlagsEXT flags; 
	ShaderStageFlags     stage; 
	ShaderStageFlags     nextStage; 
	ShaderCodeTypeEXT    codeType; 
	usz                  codeSize; 
	void*                pCode; 
	ZString              pName; 
	uint                 setLayoutCount; 
	DescriptorSetLayout* pSetLayouts; 
	uint                 pushConstantRangeCount; 
	PushConstantRange*   pPushConstantRanges; 
	SpecializationInfo*  pSpecializationInfo; 
}

struct DepthClampRangeEXT {
	float minDepthClamp; 
	float maxDepthClamp; 
}

struct PhysicalDeviceTilePropertiesFeaturesQCOM {
	StructureType sType; 
	void*         pNext; 
	uint          tileProperties; 
}

struct TilePropertiesQCOM {
	StructureType sType; 
	void*         pNext; 
	Extent3D      tileSize; 
	Extent2D      apronSize; 
	Offset2D      origin; 
}

struct PhysicalDeviceAmigoProfilingFeaturesSEC {
	StructureType sType; 
	void*         pNext; 
	uint          amigoProfiling; 
}

struct AmigoProfilingSubmitInfoSEC {
	StructureType sType; 
	void*         pNext; 
	ulong         firstDrawTimestamp; 
	ulong         swapBufferTimestamp; 
}

struct PhysicalDeviceMultiviewPerViewViewportsFeaturesQCOM {
	StructureType sType; 
	void*         pNext; 
	uint          multiviewPerViewViewports; 
}

struct PhysicalDeviceRayTracingInvocationReorderPropertiesNV {
	StructureType                     sType; 
	void*                             pNext; 
	RayTracingInvocationReorderModeNV rayTracingInvocationReorderReorderingHint; 
}

struct PhysicalDeviceRayTracingInvocationReorderFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          rayTracingInvocationReorder; 
}

struct PhysicalDeviceExtendedSparseAddressSpaceFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          extendedSparseAddressSpace; 
}

struct PhysicalDeviceExtendedSparseAddressSpacePropertiesNV {
	StructureType    sType; 
	void*            pNext; 
	DeviceSize       extendedSparseAddressSpaceSize; 
	ImageUsageFlags  extendedSparseImageUsageFlags; 
	BufferUsageFlags extendedSparseBufferUsageFlags; 
}

struct PhysicalDeviceLegacyVertexAttributesFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          legacyVertexAttributes; 
}

struct PhysicalDeviceLegacyVertexAttributesPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          nativeUnalignedPerformance; 
}

struct LayerSettingEXT {
	ZString             pLayerName; 
	ZString             pSettingName; 
	LayerSettingTypeEXT type; 
	uint                valueCount; 
	void*               pValues; 
}

struct LayerSettingsCreateInfoEXT {
	StructureType    sType; 
	void*            pNext; 
	uint             settingCount; 
	LayerSettingEXT* pSettings; 
}

struct PhysicalDeviceShaderCoreBuiltinsFeaturesARM {
	StructureType sType; 
	void*         pNext; 
	uint          shaderCoreBuiltins; 
}

struct PhysicalDeviceShaderCoreBuiltinsPropertiesARM {
	StructureType sType; 
	void*         pNext; 
	ulong         shaderCoreMask; 
	uint          shaderCoreCount; 
	uint          shaderWarpsPerCore; 
}

struct PhysicalDevicePipelineLibraryGroupHandlesFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          pipelineLibraryGroupHandles; 
}

struct PhysicalDeviceDynamicRenderingUnusedAttachmentsFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          dynamicRenderingUnusedAttachments; 
}

struct LatencySleepModeInfoNV {
	StructureType sType; 
	void*         pNext; 
	uint          lowLatencyMode; 
	uint          lowLatencyBoost; 
	uint          minimumIntervalUs; 
}

struct LatencySleepInfoNV {
	StructureType sType; 
	void*         pNext; 
	Semaphore     signalSemaphore; 
	ulong         value; 
}

struct SetLatencyMarkerInfoNV {
	StructureType   sType; 
	void*           pNext; 
	ulong           presentID; 
	LatencyMarkerNV marker; 
}

struct LatencyTimingsFrameReportNV {
	StructureType sType; 
	void*         pNext; 
	ulong         presentID; 
	ulong         inputSampleTimeUs; 
	ulong         simStartTimeUs; 
	ulong         simEndTimeUs; 
	ulong         renderSubmitStartTimeUs; 
	ulong         renderSubmitEndTimeUs; 
	ulong         presentStartTimeUs; 
	ulong         presentEndTimeUs; 
	ulong         driverStartTimeUs; 
	ulong         driverEndTimeUs; 
	ulong         osRenderQueueStartTimeUs; 
	ulong         osRenderQueueEndTimeUs; 
	ulong         gpuRenderStartTimeUs; 
	ulong         gpuRenderEndTimeUs; 
}

struct GetLatencyMarkerInfoNV {
	StructureType                sType; 
	void*                        pNext; 
	uint                         timingCount; 
	LatencyTimingsFrameReportNV* pTimings; 
}

struct LatencySubmissionPresentIdNV {
	StructureType sType; 
	void*         pNext; 
	ulong         presentID; 
}

struct SwapchainLatencyCreateInfoNV {
	StructureType sType; 
	void*         pNext; 
	uint          latencyModeEnable; 
}

struct OutOfBandQueueTypeInfoNV {
	StructureType        sType; 
	void*                pNext; 
	OutOfBandQueueTypeNV queueType; 
}

struct LatencySurfaceCapabilitiesNV {
	StructureType   sType; 
	void*           pNext; 
	uint            presentModeCount; 
	PresentModeKHR* pPresentModes; 
}

struct PhysicalDeviceMultiviewPerViewRenderAreasFeaturesQCOM {
	StructureType sType; 
	void*         pNext; 
	uint          multiviewPerViewRenderAreas; 
}

struct MultiviewPerViewRenderAreasRenderPassBeginInfoQCOM {
	StructureType sType; 
	void*         pNext; 
	uint          perViewRenderAreaCount; 
	Rect2D*       pPerViewRenderAreas; 
}

struct PhysicalDevicePerStageDescriptorSetFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          perStageDescriptorSet; 
	uint          dynamicPipelineLayout; 
}

struct PhysicalDeviceImageProcessing2FeaturesQCOM {
	StructureType sType; 
	void*         pNext; 
	uint          textureBlockMatch2; 
}

struct PhysicalDeviceImageProcessing2PropertiesQCOM {
	StructureType sType; 
	void*         pNext; 
	Extent2D      maxBlockMatchWindow; 
}

struct SamplerBlockMatchWindowCreateInfoQCOM {
	StructureType                   sType; 
	void*                           pNext; 
	Extent2D                        windowExtent; 
	BlockMatchWindowCompareModeQCOM windowCompareMode; 
}

struct PhysicalDeviceCubicWeightsFeaturesQCOM {
	StructureType sType; 
	void*         pNext; 
	uint          selectableCubicWeights; 
}

struct SamplerCubicWeightsCreateInfoQCOM {
	StructureType          sType; 
	void*                  pNext; 
	CubicFilterWeightsQCOM cubicWeights; 
}

struct BlitImageCubicWeightsInfoQCOM {
	StructureType          sType; 
	void*                  pNext; 
	CubicFilterWeightsQCOM cubicWeights; 
}

struct PhysicalDeviceYcbcrDegammaFeaturesQCOM {
	StructureType sType; 
	void*         pNext; 
	uint          ycbcrDegamma; 
}

struct SamplerYcbcrConversionYcbcrDegammaCreateInfoQCOM {
	StructureType sType; 
	void*         pNext; 
	uint          enableYDegamma; 
	uint          enableCbCrDegamma; 
}

struct PhysicalDeviceCubicClampFeaturesQCOM {
	StructureType sType; 
	void*         pNext; 
	uint          cubicRangeClamp; 
}

struct PhysicalDeviceAttachmentFeedbackLoopDynamicStateFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          attachmentFeedbackLoopDynamicState; 
}

struct PhysicalDeviceLayeredDriverPropertiesMSFT {
	StructureType                  sType; 
	void*                          pNext; 
	LayeredDriverUnderlyingApiMSFT underlyingAPI; 
}

struct PhysicalDeviceDescriptorPoolOverallocationFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          descriptorPoolOverallocation; 
}

struct DisplaySurfaceStereoCreateInfoNV {
	StructureType              sType; 
	void*                      pNext; 
	DisplaySurfaceStereoTypeNV stereoType; 
}

struct DisplayModeStereoPropertiesNV {
	StructureType sType; 
	void*         pNext; 
	uint          hdmi3DSupported; 
}

struct PhysicalDeviceRawAccessChainsFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          shaderRawAccessChains; 
}

struct PhysicalDeviceCommandBufferInheritanceFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          commandBufferInheritance; 
}

struct PhysicalDeviceShaderAtomicFloat16VectorFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          shaderFloat16VectorAtomics; 
}

struct PhysicalDeviceShaderReplicatedCompositesFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          shaderReplicatedComposites; 
}

struct PhysicalDeviceRayTracingValidationFeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          rayTracingValidation; 
}

struct PhysicalDeviceDeviceGeneratedCommandsFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          deviceGeneratedCommands; 
	uint          dynamicGeneratedPipelineLayout; 
}

struct PhysicalDeviceDeviceGeneratedCommandsPropertiesEXT {
	StructureType                     sType; 
	void*                             pNext; 
	uint                              maxIndirectPipelineCount; 
	uint                              maxIndirectShaderObjectCount; 
	uint                              maxIndirectSequenceCount; 
	uint                              maxIndirectCommandsTokenCount; 
	uint                              maxIndirectCommandsTokenOffset; 
	uint                              maxIndirectCommandsIndirectStride; 
	IndirectCommandsInputModeFlagsEXT supportedIndirectCommandsInputModes; 
	ShaderStageFlags                  supportedIndirectCommandsShaderStages; 
	ShaderStageFlags                  supportedIndirectCommandsShaderStagesPipelineBinding; 
	ShaderStageFlags                  supportedIndirectCommandsShaderStagesShaderBinding; 
	uint                              deviceGeneratedCommandsTransformFeedback; 
	uint                              deviceGeneratedCommandsMultiDrawIndirectCount; 
}

struct GeneratedCommandsMemoryRequirementsInfoEXT {
	StructureType             sType; 
	void*                     pNext; 
	IndirectExecutionSetEXT   indirectExecutionSet; 
	IndirectCommandsLayoutEXT indirectCommandsLayout; 
	uint                      maxSequenceCount; 
	uint                      maxDrawCount; 
}

struct IndirectExecutionSetPipelineInfoEXT {
	StructureType sType; 
	void*         pNext; 
	Pipeline      initialPipeline; 
	uint          maxPipelineCount; 
}

struct IndirectExecutionSetShaderLayoutInfoEXT {
	StructureType        sType; 
	void*                pNext; 
	uint                 setLayoutCount; 
	DescriptorSetLayout* pSetLayouts; 
}

struct IndirectExecutionSetShaderInfoEXT {
	StructureType                            sType; 
	void*                                    pNext; 
	uint                                     shaderCount; 
	ShaderEXT*                               pInitialShaders; 
	IndirectExecutionSetShaderLayoutInfoEXT* pSetLayoutInfos; 
	uint                                     maxShaderCount; 
	uint                                     pushConstantRangeCount; 
	PushConstantRange*                       pPushConstantRanges; 
}

union IndirectExecutionSetInfoEXT {
	IndirectExecutionSetPipelineInfoEXT* pPipelineInfo; 
	IndirectExecutionSetShaderInfoEXT*   pShaderInfo; 
}

struct IndirectExecutionSetCreateInfoEXT {
	StructureType                   sType; 
	void*                           pNext; 
	IndirectExecutionSetInfoTypeEXT type; 
	IndirectExecutionSetInfoEXT     info; 
}

struct GeneratedCommandsInfoEXT {
	StructureType             sType; 
	void*                     pNext; 
	ShaderStageFlags          shaderStages; 
	IndirectExecutionSetEXT   indirectExecutionSet; 
	IndirectCommandsLayoutEXT indirectCommandsLayout; 
	DeviceAddress             indirectAddress; 
	DeviceSize                indirectAddressSize; 
	DeviceAddress             preprocessAddress; 
	DeviceSize                preprocessSize; 
	uint                      maxSequenceCount; 
	DeviceAddress             sequenceCountAddress; 
	uint                      maxDrawCount; 
}

struct WriteIndirectExecutionSetPipelineEXT {
	StructureType sType; 
	void*         pNext; 
	uint          index; 
	Pipeline      pipeline; 
}

struct IndirectCommandsPushConstantTokenEXT {
	PushConstantRange updateRange; 
}

struct IndirectCommandsVertexBufferTokenEXT {
	uint vertexBindingUnit; 
}

struct IndirectCommandsIndexBufferTokenEXT {
	IndirectCommandsInputModeFlagsEXT mode; 
}

struct IndirectCommandsExecutionSetTokenEXT {
	IndirectExecutionSetInfoTypeEXT type; 
	ShaderStageFlags                shaderStages; 
}

union IndirectCommandsTokenDataEXT {
	IndirectCommandsPushConstantTokenEXT* pPushConstant; 
	IndirectCommandsVertexBufferTokenEXT* pVertexBuffer; 
	IndirectCommandsIndexBufferTokenEXT*  pIndexBuffer; 
	IndirectCommandsExecutionSetTokenEXT* pExecutionSet; 
}

struct IndirectCommandsLayoutTokenEXT {
	StructureType                sType; 
	void*                        pNext; 
	IndirectCommandsTokenTypeEXT type; 
	IndirectCommandsTokenDataEXT data; 
	uint                         offset; 
}

struct IndirectCommandsLayoutCreateInfoEXT {
	StructureType                       sType; 
	void*                               pNext; 
	IndirectCommandsLayoutUsageFlagsEXT flags; 
	ShaderStageFlags                    shaderStages; 
	uint                                indirectStride; 
	PipelineLayout                      pipelineLayout; 
	uint                                tokenCount; 
	IndirectCommandsLayoutTokenEXT*     pTokens; 
}

struct DrawIndirectCountIndirectCommandEXT {
	DeviceAddress bufferAddress; 
	uint          stride; 
	uint          commandCount; 
}

struct BindVertexBufferIndirectCommandEXT {
	DeviceAddress bufferAddress; 
	uint          size; 
	uint          stride; 
}

struct BindIndexBufferIndirectCommandEXT {
	DeviceAddress bufferAddress; 
	uint          size; 
	IndexType     indexType; 
}

struct GeneratedCommandsPipelineInfoEXT {
	StructureType sType; 
	void*         pNext; 
	Pipeline      pipeline; 
}

struct GeneratedCommandsShaderInfoEXT {
	StructureType sType; 
	void*         pNext; 
	uint          shaderCount; 
	ShaderEXT*    pShaders; 
}

struct WriteIndirectExecutionSetShaderEXT {
	StructureType sType; 
	void*         pNext; 
	uint          index; 
	ShaderEXT     shader; 
}

struct PhysicalDeviceImageAlignmentControlFeaturesMESA {
	StructureType sType; 
	void*         pNext; 
	uint          imageAlignmentControl; 
}

struct PhysicalDeviceImageAlignmentControlPropertiesMESA {
	StructureType sType; 
	void*         pNext; 
	uint          supportedImageAlignmentMask; 
}

struct ImageAlignmentControlCreateInfoMESA {
	StructureType sType; 
	void*         pNext; 
	uint          maximumRequestedAlignment; 
}

struct PhysicalDeviceDepthClampControlFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          depthClampControl; 
}

struct PipelineViewportDepthClampControlCreateInfoEXT {
	StructureType       sType; 
	void*               pNext; 
	DepthClampModeEXT   depthClampMode; 
	DepthClampRangeEXT* pDepthClampRange; 
}

struct PhysicalDeviceHdrVividFeaturesHUAWEI {
	StructureType sType; 
	void*         pNext; 
	uint          hdrVivid; 
}

struct HdrVividDynamicMetadataHUAWEI {
	StructureType sType; 
	void*         pNext; 
	usz           dynamicMetadataSize; 
	void*         pDynamicMetadata; 
}

struct CooperativeMatrixFlexibleDimensionsPropertiesNV {
	StructureType    sType; 
	void*            pNext; 
	uint             mGranularity; 
	uint             nGranularity; 
	uint             kGranularity; 
	ComponentTypeKHR aType; 
	ComponentTypeKHR bType; 
	ComponentTypeKHR cType; 
	ComponentTypeKHR resultType; 
	uint             saturatingAccumulation; 
	ScopeKHR         scope; 
	uint             workgroupInvocations; 
}

struct PhysicalDeviceCooperativeMatrix2FeaturesNV {
	StructureType sType; 
	void*         pNext; 
	uint          cooperativeMatrixWorkgroupScope; 
	uint          cooperativeMatrixFlexibleDimensions; 
	uint          cooperativeMatrixReductions; 
	uint          cooperativeMatrixConversions; 
	uint          cooperativeMatrixPerElementOperations; 
	uint          cooperativeMatrixTensorAddressing; 
	uint          cooperativeMatrixBlockLoads; 
}

struct PhysicalDeviceCooperativeMatrix2PropertiesNV {
	StructureType sType; 
	void*         pNext; 
	uint          cooperativeMatrixWorkgroupScopeMaxWorkgroupSize; 
	uint          cooperativeMatrixFlexibleDimensionsMaxDimension; 
	uint          cooperativeMatrixWorkgroupScopeReservedSharedMemory; 
}

struct PhysicalDeviceVertexAttributeRobustnessFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          vertexAttributeRobustness; 
}

struct AccelerationStructureBuildRangeInfoKHR {
	uint primitiveCount; 
	uint primitiveOffset; 
	uint firstVertex; 
	uint transformOffset; 
}

struct AccelerationStructureGeometryTrianglesDataKHR {
	StructureType               sType; 
	void*                       pNext; 
	Format                      vertexFormat; 
	DeviceOrHostAddressConstKHR vertexData; 
	DeviceSize                  vertexStride; 
	uint                        maxVertex; 
	IndexType                   indexType; 
	DeviceOrHostAddressConstKHR indexData; 
	DeviceOrHostAddressConstKHR transformData; 
}

struct AccelerationStructureGeometryAabbsDataKHR {
	StructureType               sType; 
	void*                       pNext; 
	DeviceOrHostAddressConstKHR data; 
	DeviceSize                  stride; 
}

struct AccelerationStructureGeometryInstancesDataKHR {
	StructureType               sType; 
	void*                       pNext; 
	uint                        arrayOfPointers; 
	DeviceOrHostAddressConstKHR data; 
}

union AccelerationStructureGeometryDataKHR {
	AccelerationStructureGeometryTrianglesDataKHR triangles; 
	AccelerationStructureGeometryAabbsDataKHR     aabbs; 
	AccelerationStructureGeometryInstancesDataKHR instances; 
}

struct AccelerationStructureGeometryKHR {
	StructureType                        sType; 
	void*                                pNext; 
	GeometryTypeKHR                      geometryType; 
	AccelerationStructureGeometryDataKHR geometry; 
	GeometryFlagsKHR                     flags; 
}

struct AccelerationStructureBuildGeometryInfoKHR {
	StructureType                      sType; 
	void*                              pNext; 
	AccelerationStructureTypeKHR       type; 
	BuildAccelerationStructureFlagsKHR flags; 
	BuildAccelerationStructureModeKHR  mode; 
	AccelerationStructureKHR           srcAccelerationStructure; 
	AccelerationStructureKHR           dstAccelerationStructure; 
	uint                               geometryCount; 
	AccelerationStructureGeometryKHR*  pGeometries; 
	AccelerationStructureGeometryKHR** ppGeometries; 
	DeviceOrHostAddressKHR             scratchData; 
}

struct AccelerationStructureCreateInfoKHR {
	StructureType                       sType; 
	void*                               pNext; 
	AccelerationStructureCreateFlagsKHR createFlags; 
	Buffer                              buffer; 
	DeviceSize                          offset; 
	DeviceSize                          size; 
	AccelerationStructureTypeKHR        type; 
	DeviceAddress                       deviceAddress; 
}

struct WriteDescriptorSetAccelerationStructureKHR {
	StructureType             sType; 
	void*                     pNext; 
	uint                      accelerationStructureCount; 
	AccelerationStructureKHR* pAccelerationStructures; 
}

struct PhysicalDeviceAccelerationStructureFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          accelerationStructure; 
	uint          accelerationStructureCaptureReplay; 
	uint          accelerationStructureIndirectBuild; 
	uint          accelerationStructureHostCommands; 
	uint          descriptorBindingAccelerationStructureUpdateAfterBind; 
}

struct PhysicalDeviceAccelerationStructurePropertiesKHR {
	StructureType sType; 
	void*         pNext; 
	ulong         maxGeometryCount; 
	ulong         maxInstanceCount; 
	ulong         maxPrimitiveCount; 
	uint          maxPerStageDescriptorAccelerationStructures; 
	uint          maxPerStageDescriptorUpdateAfterBindAccelerationStructures; 
	uint          maxDescriptorSetAccelerationStructures; 
	uint          maxDescriptorSetUpdateAfterBindAccelerationStructures; 
	uint          minAccelerationStructureScratchOffsetAlignment; 
}

struct AccelerationStructureDeviceAddressInfoKHR {
	StructureType            sType; 
	void*                    pNext; 
	AccelerationStructureKHR accelerationStructure; 
}

struct AccelerationStructureVersionInfoKHR {
	StructureType sType; 
	void*         pNext; 
	char*         pVersionData; 
}

struct CopyAccelerationStructureToMemoryInfoKHR {
	StructureType                    sType; 
	void*                            pNext; 
	AccelerationStructureKHR         src; 
	DeviceOrHostAddressKHR           dst; 
	CopyAccelerationStructureModeKHR mode; 
}

struct CopyMemoryToAccelerationStructureInfoKHR {
	StructureType                    sType; 
	void*                            pNext; 
	DeviceOrHostAddressConstKHR      src; 
	AccelerationStructureKHR         dst; 
	CopyAccelerationStructureModeKHR mode; 
}

struct CopyAccelerationStructureInfoKHR {
	StructureType                    sType; 
	void*                            pNext; 
	AccelerationStructureKHR         src; 
	AccelerationStructureKHR         dst; 
	CopyAccelerationStructureModeKHR mode; 
}

struct AccelerationStructureBuildSizesInfoKHR {
	StructureType sType; 
	void*         pNext; 
	DeviceSize    accelerationStructureSize; 
	DeviceSize    updateScratchSize; 
	DeviceSize    buildScratchSize; 
}

struct RayTracingShaderGroupCreateInfoKHR {
	StructureType                sType; 
	void*                        pNext; 
	RayTracingShaderGroupTypeKHR type; 
	uint                         generalShader; 
	uint                         closestHitShader; 
	uint                         anyHitShader; 
	uint                         intersectionShader; 
	void*                        pShaderGroupCaptureReplayHandle; 
}

struct RayTracingPipelineInterfaceCreateInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          maxPipelineRayPayloadSize; 
	uint          maxPipelineRayHitAttributeSize; 
}

struct RayTracingPipelineCreateInfoKHR {
	StructureType                             sType; 
	void*                                     pNext; 
	PipelineCreateFlags                       flags; 
	uint                                      stageCount; 
	PipelineShaderStageCreateInfo*            pStages; 
	uint                                      groupCount; 
	RayTracingShaderGroupCreateInfoKHR*       pGroups; 
	uint                                      maxPipelineRayRecursionDepth; 
	PipelineLibraryCreateInfoKHR*             pLibraryInfo; 
	RayTracingPipelineInterfaceCreateInfoKHR* pLibraryInterface; 
	PipelineDynamicStateCreateInfo*           pDynamicState; 
	PipelineLayout                            layout; 
	Pipeline                                  basePipelineHandle; 
	int                                       basePipelineIndex; 
}

struct PhysicalDeviceRayTracingPipelineFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          rayTracingPipeline; 
	uint          rayTracingPipelineShaderGroupHandleCaptureReplay; 
	uint          rayTracingPipelineShaderGroupHandleCaptureReplayMixed; 
	uint          rayTracingPipelineTraceRaysIndirect; 
	uint          rayTraversalPrimitiveCulling; 
}

struct PhysicalDeviceRayTracingPipelinePropertiesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          shaderGroupHandleSize; 
	uint          maxRayRecursionDepth; 
	uint          maxShaderGroupStride; 
	uint          shaderGroupBaseAlignment; 
	uint          shaderGroupHandleCaptureReplaySize; 
	uint          maxRayDispatchInvocationCount; 
	uint          shaderGroupHandleAlignment; 
	uint          maxRayHitAttributeSize; 
}

struct StridedDeviceAddressRegionKHR {
	DeviceAddress deviceAddress; 
	DeviceSize    stride; 
	DeviceSize    size; 
}

struct TraceRaysIndirectCommandKHR {
	uint width; 
	uint height; 
	uint depth; 
}

struct PhysicalDeviceRayQueryFeaturesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          rayQuery; 
}

struct PhysicalDeviceMeshShaderFeaturesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          taskShader; 
	uint          meshShader; 
	uint          multiviewMeshShader; 
	uint          primitiveFragmentShadingRateMeshShader; 
	uint          meshShaderQueries; 
}

struct PhysicalDeviceMeshShaderPropertiesEXT {
	StructureType sType; 
	void*         pNext; 
	uint          maxTaskWorkGroupTotalCount; 
	uint[3]       maxTaskWorkGroupCount; 
	uint          maxTaskWorkGroupInvocations; 
	uint[3]       maxTaskWorkGroupSize; 
	uint          maxTaskPayloadSize; 
	uint          maxTaskSharedMemorySize; 
	uint          maxTaskPayloadAndSharedMemorySize; 
	uint          maxMeshWorkGroupTotalCount; 
	uint[3]       maxMeshWorkGroupCount; 
	uint          maxMeshWorkGroupInvocations; 
	uint[3]       maxMeshWorkGroupSize; 
	uint          maxMeshSharedMemorySize; 
	uint          maxMeshPayloadAndSharedMemorySize; 
	uint          maxMeshOutputMemorySize; 
	uint          maxMeshPayloadAndOutputMemorySize; 
	uint          maxMeshOutputComponents; 
	uint          maxMeshOutputVertices; 
	uint          maxMeshOutputPrimitives; 
	uint          maxMeshOutputLayers; 
	uint          maxMeshMultiviewViewCount; 
	uint          meshOutputPerVertexGranularity; 
	uint          meshOutputPerPrimitiveGranularity; 
	uint          maxPreferredTaskWorkGroupInvocations; 
	uint          maxPreferredMeshWorkGroupInvocations; 
	uint          prefersLocalInvocationVertexOutput; 
	uint          prefersLocalInvocationPrimitiveOutput; 
	uint          prefersCompactVertexOutput; 
	uint          prefersCompactPrimitiveOutput; 
}

struct DrawMeshTasksIndirectCommandEXT {
	uint groupCountX; 
	uint groupCountY; 
	uint groupCountZ; 
}

struct Win32SurfaceCreateInfoKHR {
	StructureType              sType; 
	void*                      pNext; 
	Win32SurfaceCreateFlagsKHR flags; 
	Win32_HINSTANCE            hinstance; 
	Win32_HWND                 hwnd; 
}

struct ImportMemoryWin32HandleInfoKHR {
	StructureType                 sType; 
	void*                         pNext; 
	ExternalMemoryHandleTypeFlags handleType; 
	Win32_HANDLE                  handle; 
	Win32_LPCWSTR                 name; 
}

struct ExportMemoryWin32HandleInfoKHR {
	StructureType              sType; 
	void*                      pNext; 
	Win32_SECURITY_ATTRIBUTES* pAttributes; 
	Win32_DWORD                dwAccess; 
	Win32_LPCWSTR              name; 
}

struct MemoryWin32HandlePropertiesKHR {
	StructureType sType; 
	void*         pNext; 
	uint          memoryTypeBits; 
}

struct MemoryGetWin32HandleInfoKHR {
	StructureType                 sType; 
	void*                         pNext; 
	DeviceMemory                  memory; 
	ExternalMemoryHandleTypeFlags handleType; 
}

struct Win32KeyedMutexAcquireReleaseInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          acquireCount; 
	DeviceMemory* pAcquireSyncs; 
	ulong*        pAcquireKeys; 
	uint*         pAcquireTimeouts; 
	uint          releaseCount; 
	DeviceMemory* pReleaseSyncs; 
	ulong*        pReleaseKeys; 
}

struct ImportSemaphoreWin32HandleInfoKHR {
	StructureType                    sType; 
	void*                            pNext; 
	Semaphore                        semaphore; 
	SemaphoreImportFlags             flags; 
	ExternalSemaphoreHandleTypeFlags handleType; 
	Win32_HANDLE                     handle; 
	Win32_LPCWSTR                    name; 
}

struct ExportSemaphoreWin32HandleInfoKHR {
	StructureType              sType; 
	void*                      pNext; 
	Win32_SECURITY_ATTRIBUTES* pAttributes; 
	Win32_DWORD                dwAccess; 
	Win32_LPCWSTR              name; 
}

struct D3D12FenceSubmitInfoKHR {
	StructureType sType; 
	void*         pNext; 
	uint          waitSemaphoreValuesCount; 
	ulong*        pWaitSemaphoreValues; 
	uint          signalSemaphoreValuesCount; 
	ulong*        pSignalSemaphoreValues; 
}

struct SemaphoreGetWin32HandleInfoKHR {
	StructureType                    sType; 
	void*                            pNext; 
	Semaphore                        semaphore; 
	ExternalSemaphoreHandleTypeFlags handleType; 
}

struct ImportFenceWin32HandleInfoKHR {
	StructureType                sType; 
	void*                        pNext; 
	Fence                        fence; 
	FenceImportFlags             flags; 
	ExternalFenceHandleTypeFlags handleType; 
	Win32_HANDLE                 handle; 
	Win32_LPCWSTR                name; 
}

struct ExportFenceWin32HandleInfoKHR {
	StructureType              sType; 
	void*                      pNext; 
	Win32_SECURITY_ATTRIBUTES* pAttributes; 
	Win32_DWORD                dwAccess; 
	Win32_LPCWSTR              name; 
}

struct FenceGetWin32HandleInfoKHR {
	StructureType                sType; 
	void*                        pNext; 
	Fence                        fence; 
	ExternalFenceHandleTypeFlags handleType; 
}

struct ImportMemoryWin32HandleInfoNV {
	StructureType                   sType; 
	void*                           pNext; 
	ExternalMemoryHandleTypeFlagsNV handleType; 
	Win32_HANDLE                    handle; 
}

struct ExportMemoryWin32HandleInfoNV {
	StructureType              sType; 
	void*                      pNext; 
	Win32_SECURITY_ATTRIBUTES* pAttributes; 
	Win32_DWORD                dwAccess; 
}

struct Win32KeyedMutexAcquireReleaseInfoNV {
	StructureType sType; 
	void*         pNext; 
	uint          acquireCount; 
	DeviceMemory* pAcquireSyncs; 
	ulong*        pAcquireKeys; 
	uint*         pAcquireTimeoutMilliseconds; 
	uint          releaseCount; 
	DeviceMemory* pReleaseSyncs; 
	ulong*        pReleaseKeys; 
}

struct SurfaceFullScreenExclusiveInfoEXT {
	StructureType          sType; 
	void*                  pNext; 
	FullScreenExclusiveEXT fullScreenExclusive; 
}

struct SurfaceCapabilitiesFullScreenExclusiveEXT {
	StructureType sType; 
	void*         pNext; 
	uint          fullScreenExclusiveSupported; 
}

struct SurfaceFullScreenExclusiveWin32InfoEXT {
	StructureType  sType; 
	void*          pNext; 
	Win32_HMONITOR hmonitor; 
}

struct MetalSurfaceCreateInfoEXT {
	StructureType              sType; 
	void*                      pNext; 
	MetalSurfaceCreateFlagsEXT flags; 
	CAMetalLayer*              pLayer; 
}

struct ExportMetalObjectCreateInfoEXT {
	StructureType                 sType; 
	void*                         pNext; 
	ExportMetalObjectTypeFlagsEXT exportObjectType; 
}

struct ExportMetalObjectsInfoEXT {
	StructureType sType; 
	void*         pNext; 
}

struct ExportMetalDeviceInfoEXT {
	StructureType sType; 
	void*         pNext; 
	MTLDevice_id  mtlDevice; 
}

struct ExportMetalCommandQueueInfoEXT {
	StructureType      sType; 
	void*              pNext; 
	Queue              queue; 
	MTLCommandQueue_id mtlCommandQueue; 
}

struct ExportMetalBufferInfoEXT {
	StructureType sType; 
	void*         pNext; 
	DeviceMemory  memory; 
	MTLBuffer_id  mtlBuffer; 
}

struct ImportMetalBufferInfoEXT {
	StructureType sType; 
	void*         pNext; 
	MTLBuffer_id  mtlBuffer; 
}

struct ExportMetalTextureInfoEXT {
	StructureType    sType; 
	void*            pNext; 
	Image            image; 
	ImageView        imageView; 
	BufferView       bufferView; 
	ImageAspectFlags plane; 
	MTLTexture_id    mtlTexture; 
}

struct ImportMetalTextureInfoEXT {
	StructureType    sType; 
	void*            pNext; 
	ImageAspectFlags plane; 
	MTLTexture_id    mtlTexture; 
}

struct ExportMetalIOSurfaceInfoEXT {
	StructureType sType; 
	void*         pNext; 
	Image         image; 
	IOSurfaceRef  ioSurface; 
}

struct ImportMetalIOSurfaceInfoEXT {
	StructureType sType; 
	void*         pNext; 
	IOSurfaceRef  ioSurface; 
}

struct ExportMetalSharedEventInfoEXT {
	StructureType     sType; 
	void*             pNext; 
	Semaphore         semaphore; 
	Event             event; 
	MTLSharedEvent_id mtlSharedEvent; 
}

struct ImportMetalSharedEventInfoEXT {
	StructureType     sType; 
	void*             pNext; 
	MTLSharedEvent_id mtlSharedEvent; 
}

struct MacOSSurfaceCreateInfoMVK {
	StructureType              sType; 
	void*                      pNext; 
	MacOSSurfaceCreateFlagsMVK flags; 
	void*                      pView; 
}

struct IOSSurfaceCreateInfoMVK {
	StructureType            sType; 
	void*                    pNext; 
	IOSSurfaceCreateFlagsMVK flags; 
	void*                    pView; 
}

struct WaylandSurfaceCreateInfoKHR {
	StructureType                sType; 
	void*                        pNext; 
	WaylandSurfaceCreateFlagsKHR flags; 
	WLDisplay*                   display; 
	WLSurface*                   surface; 
}

struct XlibSurfaceCreateInfoKHR {
	StructureType             sType; 
	void*                     pNext; 
	XlibSurfaceCreateFlagsKHR flags; 
	XlibDisplay*              dpy; 
	XlibWindow                window; 
}

struct XcbSurfaceCreateInfoKHR {
	StructureType            sType; 
	void*                    pNext; 
	XcbSurfaceCreateFlagsKHR flags; 
	XCBConnection*           connection; 
	XCBWindow                window; 
}

struct VideoAV1ColorConfigFlags {
	uint bitfield; 
}

struct VideoAV1ColorConfig {
	VideoAV1ColorConfigFlags        flags; 
	char                            bitDepth; 
	char                            subsampling_x; 
	char                            subsampling_y; 
	char                            reserved1; 
	VideoAV1ColorPrimaries          color_primaries; 
	VideoAV1TransferCharacteristics transfer_characteristics; 
	VideoAV1MatrixCoefficients      matrix_coefficients; 
	VideoAV1ChromaSamplePosition    chroma_sample_position; 
}

struct VideoAV1TimingInfoFlags {
	uint bitfield; 
}

struct VideoAV1TimingInfo {
	VideoAV1TimingInfoFlags flags; 
	uint                    num_units_in_display_tick; 
	uint                    time_scale; 
	uint                    num_ticks_per_picture_minus_1; 
}

struct VideoAV1LoopFilterFlags {
	uint bitfield; 
}

struct VideoAV1LoopFilter {
	VideoAV1LoopFilterFlags                   flags; 
	char[VIDEO_AV1_MAX_LOOP_FILTER_STRENGTHS] loop_filter_level; 
	char                                      loop_filter_sharpness; 
	char                                      update_ref_delta; 
	ichar[VIDEO_AV1_TOTAL_REFS_PER_FRAME]     loop_filter_ref_deltas; 
	char                                      update_mode_delta; 
	ichar[VIDEO_AV1_LOOP_FILTER_ADJUSTMENTS]  loop_filter_mode_deltas; 
}

struct VideoAV1QuantizationFlags {
	uint bitfield; 
}

struct VideoAV1Quantization {
	VideoAV1QuantizationFlags flags; 
	char                      base_q_idx; 
	ichar                     deltaQYDc; 
	ichar                     deltaQUDc; 
	ichar                     deltaQUAc; 
	ichar                     deltaQVDc; 
	ichar                     deltaQVAc; 
	char                      qm_y; 
	char                      qm_u; 
	char                      qm_v; 
}

struct VideoAV1Segmentation {
	char[VIDEO_AV1_MAX_SEGMENTS]                         featureEnabled; 
	short[VIDEO_AV1_MAX_SEGMENTS][VIDEO_AV1_SEG_LVL_MAX] featureData; 
}

struct VideoAV1TileInfoFlags {
	uint bitfield; 
}

struct VideoAV1TileInfo {
	VideoAV1TileInfoFlags flags; 
	char                  tileCols; 
	char                  tileRows; 
	ushort                context_update_tile_id; 
	char                  tile_size_bytes_minus_1; 
	char[7]               reserved1; 
	ushort*               pMiColStarts; 
	ushort*               pMiRowStarts; 
	ushort*               pWidthInSbsMinus1; 
	ushort*               pHeightInSbsMinus1; 
}

struct VideoAV1CDEF {
	char                                      cdef_damping_minus_3; 
	char                                      cdef_bits; 
	char[VIDEO_AV1_MAX_CDEF_FILTER_STRENGTHS] cdef_y_pri_strength; 
	char[VIDEO_AV1_MAX_CDEF_FILTER_STRENGTHS] cdef_y_sec_strength; 
	char[VIDEO_AV1_MAX_CDEF_FILTER_STRENGTHS] cdef_uv_pri_strength; 
	char[VIDEO_AV1_MAX_CDEF_FILTER_STRENGTHS] cdef_uv_sec_strength; 
}

struct VideoAV1LoopRestoration {
	VideoAV1FrameRestorationType[VIDEO_AV1_MAX_NUM_PLANES] frameRestorationType; 
	ushort[VIDEO_AV1_MAX_NUM_PLANES]                       loopRestorationSize; 
}

struct VideoAV1GlobalMotion {
	char[VIDEO_AV1_NUM_REF_FRAMES]                                gmType; 
	int[VIDEO_AV1_NUM_REF_FRAMES][VIDEO_AV1_GLOBAL_MOTION_PARAMS] gm_params; 
}

struct VideoAV1FilmGrainFlags {
	uint bitfield; 
}

struct VideoAV1FilmGrain {
	VideoAV1FilmGrainFlags              flags; 
	char                                grain_scaling_minus_8; 
	char                                ar_coeff_lag; 
	char                                ar_coeff_shift_minus_6; 
	char                                grain_scale_shift; 
	ushort                              grain_seed; 
	char                                film_grain_params_ref_idx; 
	char                                num_y_points; 
	char[VIDEO_AV1_MAX_NUM_Y_POINTS]    point_y_value; 
	char[VIDEO_AV1_MAX_NUM_Y_POINTS]    point_y_scaling; 
	char                                num_cb_points; 
	char[VIDEO_AV1_MAX_NUM_CB_POINTS]   point_cb_value; 
	char[VIDEO_AV1_MAX_NUM_CB_POINTS]   point_cb_scaling; 
	char                                num_cr_points; 
	char[VIDEO_AV1_MAX_NUM_CR_POINTS]   point_cr_value; 
	char[VIDEO_AV1_MAX_NUM_CR_POINTS]   point_cr_scaling; 
	ichar[VIDEO_AV1_MAX_NUM_POS_LUMA]   ar_coeffs_y_plus_128; 
	ichar[VIDEO_AV1_MAX_NUM_POS_CHROMA] ar_coeffs_cb_plus_128; 
	ichar[VIDEO_AV1_MAX_NUM_POS_CHROMA] ar_coeffs_cr_plus_128; 
	char                                cb_mult; 
	char                                cb_luma_mult; 
	ushort                              cb_offset; 
	char                                cr_mult; 
	char                                cr_luma_mult; 
	ushort                              cr_offset; 
}

struct VideoAV1SequenceHeaderFlags {
	uint bitfield; 
}

struct VideoAV1SequenceHeader {
	VideoAV1SequenceHeaderFlags flags; 
	VideoAV1Profile             seq_profile; 
	char                        frame_width_bits_minus_1; 
	char                        frame_height_bits_minus_1; 
	ushort                      max_frame_width_minus_1; 
	ushort                      max_frame_height_minus_1; 
	char                        delta_frame_id_length_minus_2; 
	char                        additional_frame_id_length_minus_1; 
	char                        order_hint_bits_minus_1; 
	char                        seq_force_integer_mv; 
	char                        seq_force_screen_content_tools; 
	char[5]                     reserved1; 
	VideoAV1ColorConfig*        pColorConfig; 
	VideoAV1TimingInfo*         pTimingInfo; 
}

struct VideoDecodeAV1PictureInfoFlags {
	uint bitfield; 
}

struct VideoDecodeAV1PictureInfo {
	VideoDecodeAV1PictureInfoFlags   flags; 
	VideoAV1FrameType                frame_type; 
	uint                             current_frame_id; 
	char                             orderHint; 
	char                             primary_ref_frame; 
	char                             refresh_frame_flags; 
	char                             reserved1; 
	VideoAV1InterpolationFilter      interpolation_filter; 
	VideoAV1TxMode                   txMode; 
	char                             delta_q_res; 
	char                             delta_lf_res; 
	char[VIDEO_AV1_SKIP_MODE_FRAMES] skipModeFrame; 
	char                             coded_denom; 
	char[3]                          reserved2; 
	char[VIDEO_AV1_NUM_REF_FRAMES]   orderHints; 
	uint[VIDEO_AV1_NUM_REF_FRAMES]   expectedFrameId; 
	VideoAV1TileInfo*                pTileInfo; 
	VideoAV1Quantization*            pQuantization; 
	VideoAV1Segmentation*            pSegmentation; 
	VideoAV1LoopFilter*              pLoopFilter; 
	VideoAV1CDEF*                    pCDEF; 
	VideoAV1LoopRestoration*         pLoopRestoration; 
	VideoAV1GlobalMotion*            pGlobalMotion; 
	VideoAV1FilmGrain*               pFilmGrain; 
}

struct VideoDecodeAV1ReferenceInfoFlags {
	uint bitfield; 
}

struct VideoDecodeAV1ReferenceInfo {
	VideoDecodeAV1ReferenceInfoFlags flags; 
	char                             frame_type; 
	char                             refFrameSignBias; 
	char                             orderHint; 
	char[VIDEO_AV1_NUM_REF_FRAMES]   savedOrderHints; 
}

struct VideoEncodeAV1DecoderModelInfo {
	char buffer_delay_length_minus_1; 
	char buffer_removal_time_length_minus_1; 
	char frame_presentation_time_length_minus_1; 
	char reserved1; 
	uint num_units_in_decoding_tick; 
}

struct VideoEncodeAV1ExtensionHeader {
	char temporal_id; 
	char spatial_id; 
}

struct VideoEncodeAV1OperatingPointInfoFlags {
	uint bitfield; 
}

struct VideoEncodeAV1OperatingPointInfo {
	VideoEncodeAV1OperatingPointInfoFlags flags; 
	ushort                                operating_point_idc; 
	char                                  seq_level_idx; 
	char                                  seq_tier; 
	uint                                  decoder_buffer_delay; 
	uint                                  encoder_buffer_delay; 
	char                                  initial_display_delay_minus_1; 
}

struct VideoEncodeAV1PictureInfoFlags {
	uint bitfield; 
}

struct VideoEncodeAV1PictureInfo {
	VideoEncodeAV1PictureInfoFlags  flags; 
	VideoAV1FrameType               frame_type; 
	uint                            frame_presentation_time; 
	uint                            current_frame_id; 
	char                            order_hint; 
	char                            primary_ref_frame; 
	char                            refresh_frame_flags; 
	char                            coded_denom; 
	ushort                          render_width_minus_1; 
	ushort                          render_height_minus_1; 
	VideoAV1InterpolationFilter     interpolation_filter; 
	VideoAV1TxMode                  txMode; 
	char                            delta_q_res; 
	char                            delta_lf_res; 
	char[VIDEO_AV1_NUM_REF_FRAMES]  ref_order_hint; 
	ichar[VIDEO_AV1_REFS_PER_FRAME] ref_frame_idx; 
	char[3]                         reserved1; 
	uint[VIDEO_AV1_REFS_PER_FRAME]  delta_frame_id_minus_1; 
	VideoAV1TileInfo*               pTileInfo; 
	VideoAV1Quantization*           pQuantization; 
	VideoAV1Segmentation*           pSegmentation; 
	VideoAV1LoopFilter*             pLoopFilter; 
	VideoAV1CDEF*                   pCDEF; 
	VideoAV1LoopRestoration*        pLoopRestoration; 
	VideoAV1GlobalMotion*           pGlobalMotion; 
	VideoEncodeAV1ExtensionHeader*  pExtensionHeader; 
	uint*                           pBufferRemovalTimes; 
}

struct VideoEncodeAV1ReferenceInfoFlags {
	uint bitfield; 
}

struct VideoEncodeAV1ReferenceInfo {
	VideoEncodeAV1ReferenceInfoFlags flags; 
	uint                             refFrameId; 
	VideoAV1FrameType                frame_type; 
	char                             orderHint; 
	char[3]                          reserved1; 
	VideoEncodeAV1ExtensionHeader*   pExtensionHeader; 
}

struct VideoH264SpsVuiFlags {
	uint bitfield; 
}

struct VideoH264HrdParameters {
	char                               cpb_cnt_minus1; 
	char                               bit_rate_scale; 
	char                               cpb_size_scale; 
	char                               reserved1; 
	uint[VIDEO_H264_CPB_CNT_LIST_SIZE] bit_rate_value_minus1; 
	uint[VIDEO_H264_CPB_CNT_LIST_SIZE] cpb_size_value_minus1; 
	char[VIDEO_H264_CPB_CNT_LIST_SIZE] cbr_flag; 
	uint                               initial_cpb_removal_delay_length_minus1; 
	uint                               cpb_removal_delay_length_minus1; 
	uint                               dpb_output_delay_length_minus1; 
	uint                               time_offset_length; 
}

struct VideoH264SequenceParameterSetVui {
	VideoH264SpsVuiFlags    flags; 
	VideoH264AspectRatioIdc aspect_ratio_idc; 
	ushort                  sar_width; 
	ushort                  sar_height; 
	char                    video_format; 
	char                    colour_primaries; 
	char                    transfer_characteristics; 
	char                    matrix_coefficients; 
	uint                    num_units_in_tick; 
	uint                    time_scale; 
	char                    max_num_reorder_frames; 
	char                    max_dec_frame_buffering; 
	char                    chroma_sample_loc_type_top_field; 
	char                    chroma_sample_loc_type_bottom_field; 
	uint                    reserved1; 
	VideoH264HrdParameters* pHrdParameters; 
}

struct VideoH264SpsFlags {
	uint bitfield; 
}

struct VideoH264ScalingLists {
	ushort                                                                                scaling_list_present_mask; 
	ushort                                                                                use_default_scaling_matrix_mask; 
	char[VIDEO_H264_SCALING_LIST_4X4_NUM_LISTS][VIDEO_H264_SCALING_LIST_4X4_NUM_ELEMENTS] scalingList4x4; 
	char[VIDEO_H264_SCALING_LIST_8X8_NUM_LISTS][VIDEO_H264_SCALING_LIST_8X8_NUM_ELEMENTS] scalingList8x8; 
}

struct VideoH264SequenceParameterSet {
	VideoH264SpsFlags                 flags; 
	VideoH264ProfileIdc               profile_idc; 
	VideoH264LevelIdc                 level_idc; 
	VideoH264ChromaFormatIdc          chroma_format_idc; 
	char                              seq_parameter_set_id; 
	char                              bit_depth_luma_minus8; 
	char                              bit_depth_chroma_minus8; 
	char                              log2_max_frame_num_minus4; 
	VideoH264PocType                  pic_order_cnt_type; 
	int                               offset_for_non_ref_pic; 
	int                               offset_for_top_to_bottom_field; 
	char                              log2_max_pic_order_cnt_lsb_minus4; 
	char                              num_ref_frames_in_pic_order_cnt_cycle; 
	char                              max_num_ref_frames; 
	char                              reserved1; 
	uint                              pic_width_in_mbs_minus1; 
	uint                              pic_height_in_map_units_minus1; 
	uint                              frame_crop_left_offset; 
	uint                              frame_crop_right_offset; 
	uint                              frame_crop_top_offset; 
	uint                              frame_crop_bottom_offset; 
	uint                              reserved2; 
	int*                              pOffsetForRefFrame; 
	VideoH264ScalingLists*            pScalingLists; 
	VideoH264SequenceParameterSetVui* pSequenceParameterSetVui; 
}

struct VideoH264PpsFlags {
	uint bitfield; 
}

struct VideoH264PictureParameterSet {
	VideoH264PpsFlags          flags; 
	char                       seq_parameter_set_id; 
	char                       pic_parameter_set_id; 
	char                       num_ref_idx_l0_default_active_minus1; 
	char                       num_ref_idx_l1_default_active_minus1; 
	VideoH264WeightedBipredIdc weighted_bipred_idc; 
	ichar                      pic_init_qp_minus26; 
	ichar                      pic_init_qs_minus26; 
	ichar                      chroma_qp_index_offset; 
	ichar                      second_chroma_qp_index_offset; 
	VideoH264ScalingLists*     pScalingLists; 
}

struct VideoDecodeH264PictureInfoFlags {
	uint bitfield; 
}

struct VideoDecodeH264PictureInfo {
	VideoDecodeH264PictureInfoFlags                    flags; 
	char                                               seq_parameter_set_id; 
	char                                               pic_parameter_set_id; 
	char                                               reserved1; 
	char                                               reserved2; 
	ushort                                             frame_num; 
	ushort                                             idr_pic_id; 
	int[VIDEO_DECODE_H264_FIELD_ORDER_COUNT_LIST_SIZE] picOrderCnt; 
}

struct VideoDecodeH264ReferenceInfoFlags {
	uint bitfield; 
}

struct VideoDecodeH264ReferenceInfo {
	VideoDecodeH264ReferenceInfoFlags                  flags; 
	ushort                                             frameNum; 
	ushort                                             reserved; 
	int[VIDEO_DECODE_H264_FIELD_ORDER_COUNT_LIST_SIZE] picOrderCnt; 
}

struct VideoEncodeH264WeightTableFlags {
	uint luma_weight_l0_flag; 
	uint chroma_weight_l0_flag; 
	uint luma_weight_l1_flag; 
	uint chroma_weight_l1_flag; 
}

struct VideoEncodeH264WeightTable {
	VideoEncodeH264WeightTableFlags                                  flags; 
	char                                                             luma_log2_weight_denom; 
	char                                                             chroma_log2_weight_denom; 
	ichar[VIDEO_H264_MAX_NUM_LIST_REF]                               luma_weight_l0; 
	ichar[VIDEO_H264_MAX_NUM_LIST_REF]                               luma_offset_l0; 
	ichar[VIDEO_H264_MAX_NUM_LIST_REF][VIDEO_H264_MAX_CHROMA_PLANES] chroma_weight_l0; 
	ichar[VIDEO_H264_MAX_NUM_LIST_REF][VIDEO_H264_MAX_CHROMA_PLANES] chroma_offset_l0; 
	ichar[VIDEO_H264_MAX_NUM_LIST_REF]                               luma_weight_l1; 
	ichar[VIDEO_H264_MAX_NUM_LIST_REF]                               luma_offset_l1; 
	ichar[VIDEO_H264_MAX_NUM_LIST_REF][VIDEO_H264_MAX_CHROMA_PLANES] chroma_weight_l1; 
	ichar[VIDEO_H264_MAX_NUM_LIST_REF][VIDEO_H264_MAX_CHROMA_PLANES] chroma_offset_l1; 
}

struct VideoEncodeH264SliceHeaderFlags {
	uint bitfield; 
}

struct VideoEncodeH264PictureInfoFlags {
	uint bitfield; 
}

struct VideoEncodeH264ReferenceInfoFlags {
	uint bitfield; 
}

struct VideoEncodeH264ReferenceListsInfoFlags {
	uint bitfield; 
}

struct VideoEncodeH264RefListModEntry {
	VideoH264ModificationOfPicNumsIdc modification_of_pic_nums_idc; 
	ushort                            abs_diff_pic_num_minus1; 
	ushort                            long_term_pic_num; 
}

struct VideoEncodeH264RefPicMarkingEntry {
	VideoH264MemMgmtControlOp memory_management_control_operation; 
	ushort                    difference_of_pic_nums_minus1; 
	ushort                    long_term_pic_num; 
	ushort                    long_term_frame_idx; 
	ushort                    max_long_term_frame_idx_plus1; 
}

struct VideoEncodeH264ReferenceListsInfo {
	VideoEncodeH264ReferenceListsInfoFlags flags; 
	char                                   num_ref_idx_l0_active_minus1; 
	char                                   num_ref_idx_l1_active_minus1; 
	char[VIDEO_H264_MAX_NUM_LIST_REF]      refPicList0; 
	char[VIDEO_H264_MAX_NUM_LIST_REF]      refPicList1; 
	char                                   refList0ModOpCount; 
	char                                   refList1ModOpCount; 
	char                                   refPicMarkingOpCount; 
	char[7]                                reserved1; 
	VideoEncodeH264RefListModEntry*        pRefList0ModOperations; 
	VideoEncodeH264RefListModEntry*        pRefList1ModOperations; 
	VideoEncodeH264RefPicMarkingEntry*     pRefPicMarkingOperations; 
}

struct VideoEncodeH264PictureInfo {
	VideoEncodeH264PictureInfoFlags    flags; 
	char                               seq_parameter_set_id; 
	char                               pic_parameter_set_id; 
	ushort                             idr_pic_id; 
	VideoH264PictureType               primary_pic_type; 
	uint                               frame_num; 
	int                                picOrderCnt; 
	char                               temporal_id; 
	char[3]                            reserved1; 
	VideoEncodeH264ReferenceListsInfo* pRefLists; 
}

struct VideoEncodeH264ReferenceInfo {
	VideoEncodeH264ReferenceInfoFlags flags; 
	VideoH264PictureType              primary_pic_type; 
	uint                              frameNum; 
	int                               picOrderCnt; 
	ushort                            long_term_pic_num; 
	ushort                            long_term_frame_idx; 
	char                              temporal_id; 
}

struct VideoEncodeH264SliceHeader {
	VideoEncodeH264SliceHeaderFlags     flags; 
	uint                                first_mb_in_slice; 
	VideoH264SliceType                  slice_type; 
	ichar                               slice_alpha_c0_offset_div2; 
	ichar                               slice_beta_offset_div2; 
	ichar                               slice_qp_delta; 
	char                                reserved1; 
	VideoH264CabacInitIdc               cabac_init_idc; 
	VideoH264DisableDeblockingFilterIdc disable_deblocking_filter_idc; 
	VideoEncodeH264WeightTable*         pWeightTable; 
}

struct VideoH265DecPicBufMgr {
	uint[VIDEO_H265_SUBLAYERS_LIST_SIZE] max_latency_increase_plus1; 
	char[VIDEO_H265_SUBLAYERS_LIST_SIZE] max_dec_pic_buffering_minus1; 
	char[VIDEO_H265_SUBLAYERS_LIST_SIZE] max_num_reorder_pics; 
}

struct VideoH265SubLayerHrdParameters {
	uint[VIDEO_H265_CPB_CNT_LIST_SIZE] bit_rate_value_minus1; 
	uint[VIDEO_H265_CPB_CNT_LIST_SIZE] cpb_size_value_minus1; 
	uint[VIDEO_H265_CPB_CNT_LIST_SIZE] cpb_size_du_value_minus1; 
	uint[VIDEO_H265_CPB_CNT_LIST_SIZE] bit_rate_du_value_minus1; 
	uint                               cbr_flag; 
}

struct VideoH265HrdFlags {
	uint bitfield; 
}

struct VideoH265HrdParameters {
	VideoH265HrdFlags                      flags; 
	char                                   tick_divisor_minus2; 
	char                                   du_cpb_removal_delay_increment_length_minus1; 
	char                                   dpb_output_delay_du_length_minus1; 
	char                                   bit_rate_scale; 
	char                                   cpb_size_scale; 
	char                                   cpb_size_du_scale; 
	char                                   initial_cpb_removal_delay_length_minus1; 
	char                                   au_cpb_removal_delay_length_minus1; 
	char                                   dpb_output_delay_length_minus1; 
	char[VIDEO_H265_SUBLAYERS_LIST_SIZE]   cpb_cnt_minus1; 
	ushort[VIDEO_H265_SUBLAYERS_LIST_SIZE] elemental_duration_in_tc_minus1; 
	ushort[3]                              reserved; 
	VideoH265SubLayerHrdParameters*        pSubLayerHrdParametersNal; 
	VideoH265SubLayerHrdParameters*        pSubLayerHrdParametersVcl; 
}

struct VideoH265VpsFlags {
	uint bitfield; 
}

struct VideoH265ProfileTierLevelFlags {
	uint bitfield; 
}

struct VideoH265ProfileTierLevel {
	VideoH265ProfileTierLevelFlags flags; 
	VideoH265ProfileIdc            general_profile_idc; 
	VideoH265LevelIdc              general_level_idc; 
}

struct VideoH265VideoParameterSet {
	VideoH265VpsFlags          flags; 
	char                       vps_video_parameter_set_id; 
	char                       vps_max_sub_layers_minus1; 
	char                       reserved1; 
	char                       reserved2; 
	uint                       vps_num_units_in_tick; 
	uint                       vps_time_scale; 
	uint                       vps_num_ticks_poc_diff_one_minus1; 
	uint                       reserved3; 
	VideoH265DecPicBufMgr*     pDecPicBufMgr; 
	VideoH265HrdParameters*    pHrdParameters; 
	VideoH265ProfileTierLevel* pProfileTierLevel; 
}

struct VideoH265ScalingLists {
	char[VIDEO_H265_SCALING_LIST_4X4_NUM_LISTS][VIDEO_H265_SCALING_LIST_4X4_NUM_ELEMENTS]     scalingList4x4; 
	char[VIDEO_H265_SCALING_LIST_8X8_NUM_LISTS][VIDEO_H265_SCALING_LIST_8X8_NUM_ELEMENTS]     scalingList8x8; 
	char[VIDEO_H265_SCALING_LIST_16X16_NUM_LISTS][VIDEO_H265_SCALING_LIST_16X16_NUM_ELEMENTS] scalingList16x16; 
	char[VIDEO_H265_SCALING_LIST_32X32_NUM_LISTS][VIDEO_H265_SCALING_LIST_32X32_NUM_ELEMENTS] scalingList32x32; 
	char[VIDEO_H265_SCALING_LIST_16X16_NUM_LISTS]                                             scalingListDCCoef16x16; 
	char[VIDEO_H265_SCALING_LIST_32X32_NUM_LISTS]                                             scalingListDCCoef32x32; 
}

struct VideoH265SpsVuiFlags {
	uint bitfield; 
}

struct VideoH265SequenceParameterSetVui {
	VideoH265SpsVuiFlags    flags; 
	VideoH265AspectRatioIdc aspect_ratio_idc; 
	ushort                  sar_width; 
	ushort                  sar_height; 
	char                    video_format; 
	char                    colour_primaries; 
	char                    transfer_characteristics; 
	char                    matrix_coeffs; 
	char                    chroma_sample_loc_type_top_field; 
	char                    chroma_sample_loc_type_bottom_field; 
	char                    reserved1; 
	char                    reserved2; 
	ushort                  def_disp_win_left_offset; 
	ushort                  def_disp_win_right_offset; 
	ushort                  def_disp_win_top_offset; 
	ushort                  def_disp_win_bottom_offset; 
	uint                    vui_num_units_in_tick; 
	uint                    vui_time_scale; 
	uint                    vui_num_ticks_poc_diff_one_minus1; 
	ushort                  min_spatial_segmentation_idc; 
	ushort                  reserved3; 
	char                    max_bytes_per_pic_denom; 
	char                    max_bits_per_min_cu_denom; 
	char                    log2_max_mv_length_horizontal; 
	char                    log2_max_mv_length_vertical; 
	VideoH265HrdParameters* pHrdParameters; 
}

struct VideoH265PredictorPaletteEntries {
	ushort[VIDEO_H265_PREDICTOR_PALETTE_COMPONENTS_LIST_SIZE][VIDEO_H265_PREDICTOR_PALETTE_COMP_ENTRIES_LIST_SIZE] predictorPaletteEntries; 
}

struct VideoH265SpsFlags {
	uint bitfield; 
}

struct VideoH265ShortTermRefPicSetFlags {
	uint bitfield; 
}

struct VideoH265ShortTermRefPicSet {
	VideoH265ShortTermRefPicSetFlags flags; 
	uint                             delta_idx_minus1; 
	ushort                           use_delta_flag; 
	ushort                           abs_delta_rps_minus1; 
	ushort                           used_by_curr_pic_flag; 
	ushort                           used_by_curr_pic_s0_flag; 
	ushort                           used_by_curr_pic_s1_flag; 
	ushort                           reserved1; 
	char                             reserved2; 
	char                             reserved3; 
	char                             num_negative_pics; 
	char                             num_positive_pics; 
	ushort[VIDEO_H265_MAX_DPB_SIZE]  delta_poc_s0_minus1; 
	ushort[VIDEO_H265_MAX_DPB_SIZE]  delta_poc_s1_minus1; 
}

struct VideoH265LongTermRefPicsSps {
	uint                                        used_by_curr_pic_lt_sps_flag; 
	uint[VIDEO_H265_MAX_LONG_TERM_REF_PICS_SPS] lt_ref_pic_poc_lsb_sps; 
}

struct VideoH265SequenceParameterSet {
	VideoH265SpsFlags                 flags; 
	VideoH265ChromaFormatIdc          chroma_format_idc; 
	uint                              pic_width_in_luma_samples; 
	uint                              pic_height_in_luma_samples; 
	char                              sps_video_parameter_set_id; 
	char                              sps_max_sub_layers_minus1; 
	char                              sps_seq_parameter_set_id; 
	char                              bit_depth_luma_minus8; 
	char                              bit_depth_chroma_minus8; 
	char                              log2_max_pic_order_cnt_lsb_minus4; 
	char                              log2_min_luma_coding_block_size_minus3; 
	char                              log2_diff_max_min_luma_coding_block_size; 
	char                              log2_min_luma_transform_block_size_minus2; 
	char                              log2_diff_max_min_luma_transform_block_size; 
	char                              max_transform_hierarchy_depth_inter; 
	char                              max_transform_hierarchy_depth_intra; 
	char                              num_short_term_ref_pic_sets; 
	char                              num_long_term_ref_pics_sps; 
	char                              pcm_sample_bit_depth_luma_minus1; 
	char                              pcm_sample_bit_depth_chroma_minus1; 
	char                              log2_min_pcm_luma_coding_block_size_minus3; 
	char                              log2_diff_max_min_pcm_luma_coding_block_size; 
	char                              reserved1; 
	char                              reserved2; 
	char                              palette_max_size; 
	char                              delta_palette_max_predictor_size; 
	char                              motion_vector_resolution_control_idc; 
	char                              sps_num_palette_predictor_initializers_minus1; 
	uint                              conf_win_left_offset; 
	uint                              conf_win_right_offset; 
	uint                              conf_win_top_offset; 
	uint                              conf_win_bottom_offset; 
	VideoH265ProfileTierLevel*        pProfileTierLevel; 
	VideoH265DecPicBufMgr*            pDecPicBufMgr; 
	VideoH265ScalingLists*            pScalingLists; 
	VideoH265ShortTermRefPicSet*      pShortTermRefPicSet; 
	VideoH265LongTermRefPicsSps*      pLongTermRefPicsSps; 
	VideoH265SequenceParameterSetVui* pSequenceParameterSetVui; 
	VideoH265PredictorPaletteEntries* pPredictorPaletteEntries; 
}

struct VideoH265PpsFlags {
	uint bitfield; 
}

struct VideoH265PictureParameterSet {
	VideoH265PpsFlags                                       flags; 
	char                                                    pps_pic_parameter_set_id; 
	char                                                    pps_seq_parameter_set_id; 
	char                                                    sps_video_parameter_set_id; 
	char                                                    num_extra_slice_header_bits; 
	char                                                    num_ref_idx_l0_default_active_minus1; 
	char                                                    num_ref_idx_l1_default_active_minus1; 
	ichar                                                   init_qp_minus26; 
	char                                                    diff_cu_qp_delta_depth; 
	ichar                                                   pps_cb_qp_offset; 
	ichar                                                   pps_cr_qp_offset; 
	ichar                                                   pps_beta_offset_div2; 
	ichar                                                   pps_tc_offset_div2; 
	char                                                    log2_parallel_merge_level_minus2; 
	char                                                    log2_max_transform_skip_block_size_minus2; 
	char                                                    diff_cu_chroma_qp_offset_depth; 
	char                                                    chroma_qp_offset_list_len_minus1; 
	ichar[VIDEO_H265_CHROMA_QP_OFFSET_LIST_SIZE]            cb_qp_offset_list; 
	ichar[VIDEO_H265_CHROMA_QP_OFFSET_LIST_SIZE]            cr_qp_offset_list; 
	char                                                    log2_sao_offset_scale_luma; 
	char                                                    log2_sao_offset_scale_chroma; 
	ichar                                                   pps_act_y_qp_offset_plus5; 
	ichar                                                   pps_act_cb_qp_offset_plus5; 
	ichar                                                   pps_act_cr_qp_offset_plus3; 
	char                                                    pps_num_palette_predictor_initializers; 
	char                                                    luma_bit_depth_entry_minus8; 
	char                                                    chroma_bit_depth_entry_minus8; 
	char                                                    num_tile_columns_minus1; 
	char                                                    num_tile_rows_minus1; 
	char                                                    reserved1; 
	char                                                    reserved2; 
	ushort[VIDEO_H265_CHROMA_QP_OFFSET_TILE_COLS_LIST_SIZE] column_width_minus1; 
	ushort[VIDEO_H265_CHROMA_QP_OFFSET_TILE_ROWS_LIST_SIZE] row_height_minus1; 
	uint                                                    reserved3; 
	VideoH265ScalingLists*                                  pScalingLists; 
	VideoH265PredictorPaletteEntries*                       pPredictorPaletteEntries; 
}

struct VideoDecodeH265PictureInfoFlags {
	uint bitfield; 
}

struct VideoDecodeH265PictureInfo {
	VideoDecodeH265PictureInfoFlags               flags; 
	char                                          sps_video_parameter_set_id; 
	char                                          pps_seq_parameter_set_id; 
	char                                          pps_pic_parameter_set_id; 
	char                                          numDeltaPocsOfRefRpsIdx; 
	int                                           picOrderCntVal; 
	ushort                                        numBitsForSTRefPicSetInSlice; 
	ushort                                        reserved; 
	char[VIDEO_DECODE_H265_REF_PIC_SET_LIST_SIZE] refPicSetStCurrBefore; 
	char[VIDEO_DECODE_H265_REF_PIC_SET_LIST_SIZE] refPicSetStCurrAfter; 
	char[VIDEO_DECODE_H265_REF_PIC_SET_LIST_SIZE] refPicSetLtCurr; 
}

struct VideoDecodeH265ReferenceInfoFlags {
	uint bitfield; 
}

struct VideoDecodeH265ReferenceInfo {
	VideoDecodeH265ReferenceInfoFlags flags; 
	int                               picOrderCntVal; 
}

struct VideoEncodeH265WeightTableFlags {
	ushort luma_weight_l0_flag; 
	ushort chroma_weight_l0_flag; 
	ushort luma_weight_l1_flag; 
	ushort chroma_weight_l1_flag; 
}

struct VideoEncodeH265WeightTable {
	VideoEncodeH265WeightTableFlags                                  flags; 
	char                                                             luma_log2_weight_denom; 
	ichar                                                            delta_chroma_log2_weight_denom; 
	ichar[VIDEO_H265_MAX_NUM_LIST_REF]                               delta_luma_weight_l0; 
	ichar[VIDEO_H265_MAX_NUM_LIST_REF]                               luma_offset_l0; 
	ichar[VIDEO_H265_MAX_NUM_LIST_REF][VIDEO_H265_MAX_CHROMA_PLANES] delta_chroma_weight_l0; 
	ichar[VIDEO_H265_MAX_NUM_LIST_REF][VIDEO_H265_MAX_CHROMA_PLANES] delta_chroma_offset_l0; 
	ichar[VIDEO_H265_MAX_NUM_LIST_REF]                               delta_luma_weight_l1; 
	ichar[VIDEO_H265_MAX_NUM_LIST_REF]                               luma_offset_l1; 
	ichar[VIDEO_H265_MAX_NUM_LIST_REF][VIDEO_H265_MAX_CHROMA_PLANES] delta_chroma_weight_l1; 
	ichar[VIDEO_H265_MAX_NUM_LIST_REF][VIDEO_H265_MAX_CHROMA_PLANES] delta_chroma_offset_l1; 
}

struct VideoEncodeH265SliceSegmentHeaderFlags {
	uint bitfield; 
}

struct VideoEncodeH265SliceSegmentHeader {
	VideoEncodeH265SliceSegmentHeaderFlags flags; 
	VideoH265SliceType                     slice_type; 
	uint                                   slice_segment_address; 
	char                                   collocated_ref_idx; 
	char                                   maxNumMergeCand; 
	ichar                                  slice_cb_qp_offset; 
	ichar                                  slice_cr_qp_offset; 
	ichar                                  slice_beta_offset_div2; 
	ichar                                  slice_tc_offset_div2; 
	ichar                                  slice_act_y_qp_offset; 
	ichar                                  slice_act_cb_qp_offset; 
	ichar                                  slice_act_cr_qp_offset; 
	ichar                                  slice_qp_delta; 
	ushort                                 reserved1; 
	VideoEncodeH265WeightTable*            pWeightTable; 
}

struct VideoEncodeH265ReferenceListsInfoFlags {
	uint bitfield; 
}

struct VideoEncodeH265ReferenceListsInfo {
	VideoEncodeH265ReferenceListsInfoFlags flags; 
	char                                   num_ref_idx_l0_active_minus1; 
	char                                   num_ref_idx_l1_active_minus1; 
	char[VIDEO_H265_MAX_NUM_LIST_REF]      refPicList0; 
	char[VIDEO_H265_MAX_NUM_LIST_REF]      refPicList1; 
	char[VIDEO_H265_MAX_NUM_LIST_REF]      list_entry_l0; 
	char[VIDEO_H265_MAX_NUM_LIST_REF]      list_entry_l1; 
}

struct VideoEncodeH265PictureInfoFlags {
	uint bitfield; 
}

struct VideoEncodeH265LongTermRefPics {
	char                                        num_long_term_sps; 
	char                                        num_long_term_pics; 
	char[VIDEO_H265_MAX_LONG_TERM_REF_PICS_SPS] lt_idx_sps; 
	char[VIDEO_H265_MAX_LONG_TERM_PICS]         poc_lsb_lt; 
	ushort                                      used_by_curr_pic_lt_flag; 
	char[VIDEO_H265_MAX_DELTA_POC]              delta_poc_msb_present_flag; 
	char[VIDEO_H265_MAX_DELTA_POC]              delta_poc_msb_cycle_lt; 
}

struct VideoEncodeH265PictureInfo {
	VideoEncodeH265PictureInfoFlags    flags; 
	VideoH265PictureType               pic_type; 
	char                               sps_video_parameter_set_id; 
	char                               pps_seq_parameter_set_id; 
	char                               pps_pic_parameter_set_id; 
	char                               short_term_ref_pic_set_idx; 
	int                                picOrderCntVal; 
	char                               temporalId; 
	char[7]                            reserved1; 
	VideoEncodeH265ReferenceListsInfo* pRefLists; 
	VideoH265ShortTermRefPicSet*       pShortTermRefPicSet; 
	VideoEncodeH265LongTermRefPics*    pLongTermRefPics; 
}

struct VideoEncodeH265ReferenceInfoFlags {
	uint bitfield; 
}

struct VideoEncodeH265ReferenceInfo {
	VideoEncodeH265ReferenceInfoFlags flags; 
	VideoH265PictureType              pic_type; 
	int                               picOrderCntVal; 
	char                              temporalId; 
}

// Opaque structs

distinct WLSurface = void*;// @extern("wl_surface"); // Opaque struct defined by Wayland
distinct WLDisplay = void*;// @extern("wl_display"); // Opaque struct defined by Wayland
distinct XCBConnection = void*;// @extern("xcb_connection_t"); // Opaque struct defined by xcb
distinct IOSurfaceRef = void*; // Opaque struct defined by Apple’s CoreGraphics framework

// Aliases
def PhysicalDeviceVariablePointerFeatures                       = PhysicalDeviceVariablePointersFeatures;
def PhysicalDeviceShaderDrawParameterFeatures                   = PhysicalDeviceShaderDrawParametersFeatures;
def PipelineStageFlag2                                          = Flags64;
def AccessFlag2                                                 = Flags64;
def FormatFeatureFlag2                                          = Flags64;
def PipelineCreateFlag2                                         = Flags64;
def BufferUsageFlag2                                            = Flags64;
def RenderingFlagsKHR                                           = RenderingFlags;
def RenderingInfoKHR                                            = RenderingInfo;
def RenderingAttachmentInfoKHR                                  = RenderingAttachmentInfo;
def PipelineRenderingCreateInfoKHR                              = PipelineRenderingCreateInfo;
def PhysicalDeviceDynamicRenderingFeaturesKHR                   = PhysicalDeviceDynamicRenderingFeatures;
def CommandBufferInheritanceRenderingInfoKHR                    = CommandBufferInheritanceRenderingInfo;
def RenderPassMultiviewCreateInfoKHR                            = RenderPassMultiviewCreateInfo;
def PhysicalDeviceMultiviewFeaturesKHR                          = PhysicalDeviceMultiviewFeatures;
def PhysicalDeviceMultiviewPropertiesKHR                        = PhysicalDeviceMultiviewProperties;
def PhysicalDeviceFeatures2KHR                                  = PhysicalDeviceFeatures2;
def PhysicalDeviceProperties2KHR                                = PhysicalDeviceProperties2;
def FormatProperties2KHR                                        = FormatProperties2;
def ImageFormatProperties2KHR                                   = ImageFormatProperties2;
def PhysicalDeviceImageFormatInfo2KHR                           = PhysicalDeviceImageFormatInfo2;
def QueueFamilyProperties2KHR                                   = QueueFamilyProperties2;
def PhysicalDeviceMemoryProperties2KHR                          = PhysicalDeviceMemoryProperties2;
def SparseImageFormatProperties2KHR                             = SparseImageFormatProperties2;
def PhysicalDeviceSparseImageFormatInfo2KHR                     = PhysicalDeviceSparseImageFormatInfo2;
def PeerMemoryFeatureFlagsKHR                                   = PeerMemoryFeatureFlags;
def MemoryAllocateFlagsKHR                                      = MemoryAllocateFlags;
def MemoryAllocateFlagsInfoKHR                                  = MemoryAllocateFlagsInfo;
def DeviceGroupRenderPassBeginInfoKHR                           = DeviceGroupRenderPassBeginInfo;
def DeviceGroupCommandBufferBeginInfoKHR                        = DeviceGroupCommandBufferBeginInfo;
def DeviceGroupSubmitInfoKHR                                    = DeviceGroupSubmitInfo;
def DeviceGroupBindSparseInfoKHR                                = DeviceGroupBindSparseInfo;
def BindBufferMemoryDeviceGroupInfoKHR                          = BindBufferMemoryDeviceGroupInfo;
def BindImageMemoryDeviceGroupInfoKHR                           = BindImageMemoryDeviceGroupInfo;
def CommandPoolTrimFlagsKHR                                     = CommandPoolTrimFlags;
def PhysicalDeviceGroupPropertiesKHR                            = PhysicalDeviceGroupProperties;
def DeviceGroupDeviceCreateInfoKHR                              = DeviceGroupDeviceCreateInfo;
def ExternalMemoryHandleTypeFlagsKHR                            = ExternalMemoryHandleTypeFlags;
def ExternalMemoryFeatureFlagsKHR                               = ExternalMemoryFeatureFlags;
def ExternalMemoryPropertiesKHR                                 = ExternalMemoryProperties;
def PhysicalDeviceExternalImageFormatInfoKHR                    = PhysicalDeviceExternalImageFormatInfo;
def ExternalImageFormatPropertiesKHR                            = ExternalImageFormatProperties;
def PhysicalDeviceExternalBufferInfoKHR                         = PhysicalDeviceExternalBufferInfo;
def ExternalBufferPropertiesKHR                                 = ExternalBufferProperties;
def PhysicalDeviceIDPropertiesKHR                               = PhysicalDeviceIDProperties;
def ExternalMemoryImageCreateInfoKHR                            = ExternalMemoryImageCreateInfo;
def ExternalMemoryBufferCreateInfoKHR                           = ExternalMemoryBufferCreateInfo;
def ExportMemoryAllocateInfoKHR                                 = ExportMemoryAllocateInfo;
def ExternalSemaphoreHandleTypeFlagsKHR                         = ExternalSemaphoreHandleTypeFlags;
def ExternalSemaphoreFeatureFlagsKHR                            = ExternalSemaphoreFeatureFlags;
def PhysicalDeviceExternalSemaphoreInfoKHR                      = PhysicalDeviceExternalSemaphoreInfo;
def ExternalSemaphorePropertiesKHR                              = ExternalSemaphoreProperties;
def SemaphoreImportFlagsKHR                                     = SemaphoreImportFlags;
def ExportSemaphoreCreateInfoKHR                                = ExportSemaphoreCreateInfo;
def PhysicalDevicePushDescriptorPropertiesKHR                   = PhysicalDevicePushDescriptorProperties;
def PhysicalDeviceShaderFloat16Int8FeaturesKHR                  = PhysicalDeviceShaderFloat16Int8Features;
def PhysicalDeviceFloat16Int8FeaturesKHR                        = PhysicalDeviceShaderFloat16Int8Features;
def PhysicalDevice16BitStorageFeaturesKHR                       = PhysicalDevice16BitStorageFeatures;
def DescriptorUpdateTemplateKHR                                 = DescriptorUpdateTemplate;
def DescriptorUpdateTemplateTypeKHR                             = DescriptorUpdateTemplateType;
def DescriptorUpdateTemplateCreateFlagsKHR                      = DescriptorUpdateTemplateCreateFlags;
def DescriptorUpdateTemplateEntryKHR                            = DescriptorUpdateTemplateEntry;
def DescriptorUpdateTemplateCreateInfoKHR                       = DescriptorUpdateTemplateCreateInfo;
def PhysicalDeviceImagelessFramebufferFeaturesKHR               = PhysicalDeviceImagelessFramebufferFeatures;
def FramebufferAttachmentsCreateInfoKHR                         = FramebufferAttachmentsCreateInfo;
def FramebufferAttachmentImageInfoKHR                           = FramebufferAttachmentImageInfo;
def RenderPassAttachmentBeginInfoKHR                            = RenderPassAttachmentBeginInfo;
def RenderPassCreateInfo2KHR                                    = RenderPassCreateInfo2;
def AttachmentDescription2KHR                                   = AttachmentDescription2;
def AttachmentReference2KHR                                     = AttachmentReference2;
def SubpassDescription2KHR                                      = SubpassDescription2;
def SubpassDependency2KHR                                       = SubpassDependency2;
def SubpassBeginInfoKHR                                         = SubpassBeginInfo;
def SubpassEndInfoKHR                                           = SubpassEndInfo;
def ExternalFenceHandleTypeFlagsKHR                             = ExternalFenceHandleTypeFlags;
def ExternalFenceFeatureFlagsKHR                                = ExternalFenceFeatureFlags;
def PhysicalDeviceExternalFenceInfoKHR                          = PhysicalDeviceExternalFenceInfo;
def ExternalFencePropertiesKHR                                  = ExternalFenceProperties;
def FenceImportFlagsKHR                                         = FenceImportFlags;
def ExportFenceCreateInfoKHR                                    = ExportFenceCreateInfo;
def PointClippingBehaviorKHR                                    = PointClippingBehavior;
def TessellationDomainOriginKHR                                 = TessellationDomainOrigin;
def PhysicalDevicePointClippingPropertiesKHR                    = PhysicalDevicePointClippingProperties;
def RenderPassInputAttachmentAspectCreateInfoKHR                = RenderPassInputAttachmentAspectCreateInfo;
def InputAttachmentAspectReferenceKHR                           = InputAttachmentAspectReference;
def ImageViewUsageCreateInfoKHR                                 = ImageViewUsageCreateInfo;
def PipelineTessellationDomainOriginStateCreateInfoKHR          = PipelineTessellationDomainOriginStateCreateInfo;
def PhysicalDeviceVariablePointerFeaturesKHR                    = PhysicalDeviceVariablePointersFeatures;
def PhysicalDeviceVariablePointersFeaturesKHR                   = PhysicalDeviceVariablePointersFeatures;
def MemoryDedicatedRequirementsKHR                              = MemoryDedicatedRequirements;
def MemoryDedicatedAllocateInfoKHR                              = MemoryDedicatedAllocateInfo;
def BufferMemoryRequirementsInfo2KHR                            = BufferMemoryRequirementsInfo2;
def ImageMemoryRequirementsInfo2KHR                             = ImageMemoryRequirementsInfo2;
def ImageSparseMemoryRequirementsInfo2KHR                       = ImageSparseMemoryRequirementsInfo2;
def MemoryRequirements2KHR                                      = MemoryRequirements2;
def SparseImageMemoryRequirements2KHR                           = SparseImageMemoryRequirements2;
def ImageFormatListCreateInfoKHR                                = ImageFormatListCreateInfo;
def SamplerYcbcrConversionKHR                                   = SamplerYcbcrConversion;
def SamplerYcbcrModelConversionKHR                              = SamplerYcbcrModelConversion;
def SamplerYcbcrRangeKHR                                        = SamplerYcbcrRange;
def ChromaLocationKHR                                           = ChromaLocation;
def SamplerYcbcrConversionCreateInfoKHR                         = SamplerYcbcrConversionCreateInfo;
def SamplerYcbcrConversionInfoKHR                               = SamplerYcbcrConversionInfo;
def BindImagePlaneMemoryInfoKHR                                 = BindImagePlaneMemoryInfo;
def ImagePlaneMemoryRequirementsInfoKHR                         = ImagePlaneMemoryRequirementsInfo;
def PhysicalDeviceSamplerYcbcrConversionFeaturesKHR             = PhysicalDeviceSamplerYcbcrConversionFeatures;
def SamplerYcbcrConversionImageFormatPropertiesKHR              = SamplerYcbcrConversionImageFormatProperties;
def BindBufferMemoryInfoKHR                                     = BindBufferMemoryInfo;
def BindImageMemoryInfoKHR                                      = BindImageMemoryInfo;
def PhysicalDeviceMaintenance3PropertiesKHR                     = PhysicalDeviceMaintenance3Properties;
def DescriptorSetLayoutSupportKHR                               = DescriptorSetLayoutSupport;
def PhysicalDeviceShaderSubgroupExtendedTypesFeaturesKHR        = PhysicalDeviceShaderSubgroupExtendedTypesFeatures;
def PhysicalDevice8BitStorageFeaturesKHR                        = PhysicalDevice8BitStorageFeatures;
def PhysicalDeviceShaderAtomicInt64FeaturesKHR                  = PhysicalDeviceShaderAtomicInt64Features;
def QueueGlobalPriorityKHR                                      = QueueGlobalPriority;
def DeviceQueueGlobalPriorityCreateInfoKHR                      = DeviceQueueGlobalPriorityCreateInfo;
def PhysicalDeviceGlobalPriorityQueryFeaturesKHR                = PhysicalDeviceGlobalPriorityQueryFeatures;
def QueueFamilyGlobalPriorityPropertiesKHR                      = QueueFamilyGlobalPriorityProperties;
def DriverIdKHR                                                 = DriverId;
def ConformanceVersionKHR                                       = ConformanceVersion;
def PhysicalDeviceDriverPropertiesKHR                           = PhysicalDeviceDriverProperties;
def ShaderFloatControlsIndependenceKHR                          = ShaderFloatControlsIndependence;
def PhysicalDeviceFloatControlsPropertiesKHR                    = PhysicalDeviceFloatControlsProperties;
def ResolveModeFlagsKHR                                         = ResolveModeFlags;
def SubpassDescriptionDepthStencilResolveKHR                    = SubpassDescriptionDepthStencilResolve;
def PhysicalDeviceDepthStencilResolvePropertiesKHR              = PhysicalDeviceDepthStencilResolveProperties;
def SemaphoreTypeKHR                                            = SemaphoreType;
def SemaphoreWaitFlagsKHR                                       = SemaphoreWaitFlags;
def PhysicalDeviceTimelineSemaphoreFeaturesKHR                  = PhysicalDeviceTimelineSemaphoreFeatures;
def PhysicalDeviceTimelineSemaphorePropertiesKHR                = PhysicalDeviceTimelineSemaphoreProperties;
def SemaphoreTypeCreateInfoKHR                                  = SemaphoreTypeCreateInfo;
def TimelineSemaphoreSubmitInfoKHR                              = TimelineSemaphoreSubmitInfo;
def SemaphoreWaitInfoKHR                                        = SemaphoreWaitInfo;
def SemaphoreSignalInfoKHR                                      = SemaphoreSignalInfo;
def PhysicalDeviceVulkanMemoryModelFeaturesKHR                  = PhysicalDeviceVulkanMemoryModelFeatures;
def PhysicalDeviceShaderTerminateInvocationFeaturesKHR          = PhysicalDeviceShaderTerminateInvocationFeatures;
def PhysicalDeviceDynamicRenderingLocalReadFeaturesKHR          = PhysicalDeviceDynamicRenderingLocalReadFeatures;
def RenderingAttachmentLocationInfoKHR                          = RenderingAttachmentLocationInfo;
def RenderingInputAttachmentIndexInfoKHR                        = RenderingInputAttachmentIndexInfo;
def PhysicalDeviceSeparateDepthStencilLayoutsFeaturesKHR        = PhysicalDeviceSeparateDepthStencilLayoutsFeatures;
def AttachmentReferenceStencilLayoutKHR                         = AttachmentReferenceStencilLayout;
def AttachmentDescriptionStencilLayoutKHR                       = AttachmentDescriptionStencilLayout;
def PhysicalDeviceUniformBufferStandardLayoutFeaturesKHR        = PhysicalDeviceUniformBufferStandardLayoutFeatures;
def PhysicalDeviceBufferDeviceAddressFeaturesKHR                = PhysicalDeviceBufferDeviceAddressFeatures;
def BufferDeviceAddressInfoKHR                                  = BufferDeviceAddressInfo;
def BufferOpaqueCaptureAddressCreateInfoKHR                     = BufferOpaqueCaptureAddressCreateInfo;
def MemoryOpaqueCaptureAddressAllocateInfoKHR                   = MemoryOpaqueCaptureAddressAllocateInfo;
def DeviceMemoryOpaqueCaptureAddressInfoKHR                     = DeviceMemoryOpaqueCaptureAddressInfo;
def MemoryUnmapFlagsKHR                                         = MemoryUnmapFlags;
def MemoryMapInfoKHR                                            = MemoryMapInfo;
def MemoryUnmapInfoKHR                                          = MemoryUnmapInfo;
def PhysicalDeviceShaderIntegerDotProductFeaturesKHR            = PhysicalDeviceShaderIntegerDotProductFeatures;
def PhysicalDeviceShaderIntegerDotProductPropertiesKHR          = PhysicalDeviceShaderIntegerDotProductProperties;
def PipelineStageFlags2KHR                                      = PipelineStageFlags2;
def AccessFlags2KHR                                             = AccessFlags2;
def SubmitFlagsKHR                                              = SubmitFlags;
def MemoryBarrier2KHR                                           = MemoryBarrier2;
def BufferMemoryBarrier2KHR                                     = BufferMemoryBarrier2;
def ImageMemoryBarrier2KHR                                      = ImageMemoryBarrier2;
def DependencyInfoKHR                                           = DependencyInfo;
def SubmitInfo2KHR                                              = SubmitInfo2;
def SemaphoreSubmitInfoKHR                                      = SemaphoreSubmitInfo;
def CommandBufferSubmitInfoKHR                                  = CommandBufferSubmitInfo;
def PhysicalDeviceSynchronization2FeaturesKHR                   = PhysicalDeviceSynchronization2Features;
def PhysicalDeviceZeroInitializeWorkgroupMemoryFeaturesKHR      = PhysicalDeviceZeroInitializeWorkgroupMemoryFeatures;
def CopyBufferInfo2KHR                                          = CopyBufferInfo2;
def CopyImageInfo2KHR                                           = CopyImageInfo2;
def CopyBufferToImageInfo2KHR                                   = CopyBufferToImageInfo2;
def CopyImageToBufferInfo2KHR                                   = CopyImageToBufferInfo2;
def BlitImageInfo2KHR                                           = BlitImageInfo2;
def ResolveImageInfo2KHR                                        = ResolveImageInfo2;
def BufferCopy2KHR                                              = BufferCopy2;
def ImageCopy2KHR                                               = ImageCopy2;
def ImageBlit2KHR                                               = ImageBlit2;
def BufferImageCopy2KHR                                         = BufferImageCopy2;
def ImageResolve2KHR                                            = ImageResolve2;
def FormatFeatureFlags2KHR                                      = FormatFeatureFlags2;
def FormatProperties3KHR                                        = FormatProperties3;
def PhysicalDeviceMaintenance4FeaturesKHR                       = PhysicalDeviceMaintenance4Features;
def PhysicalDeviceMaintenance4PropertiesKHR                     = PhysicalDeviceMaintenance4Properties;
def DeviceBufferMemoryRequirementsKHR                           = DeviceBufferMemoryRequirements;
def DeviceImageMemoryRequirementsKHR                            = DeviceImageMemoryRequirements;
def PhysicalDeviceShaderSubgroupRotateFeaturesKHR               = PhysicalDeviceShaderSubgroupRotateFeatures;
def PipelineCreateFlags2KHR                                     = PipelineCreateFlags2;
def BufferUsageFlags2KHR                                        = BufferUsageFlags2;
def PhysicalDeviceMaintenance5FeaturesKHR                       = PhysicalDeviceMaintenance5Features;
def PhysicalDeviceMaintenance5PropertiesKHR                     = PhysicalDeviceMaintenance5Properties;
def RenderingAreaInfoKHR                                        = RenderingAreaInfo;
def DeviceImageSubresourceInfoKHR                               = DeviceImageSubresourceInfo;
def ImageSubresource2KHR                                        = ImageSubresource2;
def SubresourceLayout2KHR                                       = SubresourceLayout2;
def PipelineCreateFlags2CreateInfoKHR                           = PipelineCreateFlags2CreateInfo;
def BufferUsageFlags2CreateInfoKHR                              = BufferUsageFlags2CreateInfo;
def PhysicalDeviceVertexAttributeDivisorPropertiesKHR           = PhysicalDeviceVertexAttributeDivisorProperties;
def VertexInputBindingDivisorDescriptionKHR                     = VertexInputBindingDivisorDescription;
def PipelineVertexInputDivisorStateCreateInfoKHR                = PipelineVertexInputDivisorStateCreateInfo;
def PhysicalDeviceVertexAttributeDivisorFeaturesKHR             = PhysicalDeviceVertexAttributeDivisorFeatures;
def PhysicalDeviceShaderFloatControls2FeaturesKHR               = PhysicalDeviceShaderFloatControls2Features;
def PhysicalDeviceIndexTypeUint8FeaturesKHR                     = PhysicalDeviceIndexTypeUint8Features;
def LineRasterizationModeKHR                                    = LineRasterizationMode;
def PhysicalDeviceLineRasterizationFeaturesKHR                  = PhysicalDeviceLineRasterizationFeatures;
def PhysicalDeviceLineRasterizationPropertiesKHR                = PhysicalDeviceLineRasterizationProperties;
def PipelineRasterizationLineStateCreateInfoKHR                 = PipelineRasterizationLineStateCreateInfo;
def PhysicalDeviceShaderExpectAssumeFeaturesKHR                 = PhysicalDeviceShaderExpectAssumeFeatures;
def PhysicalDeviceMaintenance6FeaturesKHR                       = PhysicalDeviceMaintenance6Features;
def PhysicalDeviceMaintenance6PropertiesKHR                     = PhysicalDeviceMaintenance6Properties;
def BindMemoryStatusKHR                                         = BindMemoryStatus;
def BindDescriptorSetsInfoKHR                                   = BindDescriptorSetsInfo;
def PushConstantsInfoKHR                                        = PushConstantsInfo;
def PushDescriptorSetInfoKHR                                    = PushDescriptorSetInfo;
def PushDescriptorSetWithTemplateInfoKHR                        = PushDescriptorSetWithTemplateInfo;
def PhysicalDeviceTextureCompressionASTCHDRFeaturesEXT          = PhysicalDeviceTextureCompressionASTCHDRFeatures;
def PipelineRobustnessBufferBehaviorEXT                         = PipelineRobustnessBufferBehavior;
def PipelineRobustnessImageBehaviorEXT                          = PipelineRobustnessImageBehavior;
def PhysicalDevicePipelineRobustnessFeaturesEXT                 = PhysicalDevicePipelineRobustnessFeatures;
def PhysicalDevicePipelineRobustnessPropertiesEXT               = PhysicalDevicePipelineRobustnessProperties;
def PipelineRobustnessCreateInfoEXT                             = PipelineRobustnessCreateInfo;
def SamplerReductionModeEXT                                     = SamplerReductionMode;
def SamplerReductionModeCreateInfoEXT                           = SamplerReductionModeCreateInfo;
def PhysicalDeviceSamplerFilterMinmaxPropertiesEXT              = PhysicalDeviceSamplerFilterMinmaxProperties;
def PhysicalDeviceInlineUniformBlockFeaturesEXT                 = PhysicalDeviceInlineUniformBlockFeatures;
def PhysicalDeviceInlineUniformBlockPropertiesEXT               = PhysicalDeviceInlineUniformBlockProperties;
def WriteDescriptorSetInlineUniformBlockEXT                     = WriteDescriptorSetInlineUniformBlock;
def DescriptorPoolInlineUniformBlockCreateInfoEXT               = DescriptorPoolInlineUniformBlockCreateInfo;
def AttachmentSampleCountInfoNV                                 = AttachmentSampleCountInfoAMD;
def DescriptorBindingFlagsEXT                                   = DescriptorBindingFlags;
def DescriptorSetLayoutBindingFlagsCreateInfoEXT                = DescriptorSetLayoutBindingFlagsCreateInfo;
def PhysicalDeviceDescriptorIndexingFeaturesEXT                 = PhysicalDeviceDescriptorIndexingFeatures;
def PhysicalDeviceDescriptorIndexingPropertiesEXT               = PhysicalDeviceDescriptorIndexingProperties;
def DescriptorSetVariableDescriptorCountAllocateInfoEXT         = DescriptorSetVariableDescriptorCountAllocateInfo;
def DescriptorSetVariableDescriptorCountLayoutSupportEXT        = DescriptorSetVariableDescriptorCountLayoutSupport;
def RayTracingShaderGroupTypeNV                                 = RayTracingShaderGroupTypeKHR;
def GeometryTypeNV                                              = GeometryTypeKHR;
def AccelerationStructureTypeNV                                 = AccelerationStructureTypeKHR;
def CopyAccelerationStructureModeNV                             = CopyAccelerationStructureModeKHR;
def GeometryFlagsNV                                             = GeometryFlagsKHR;
def GeometryInstanceFlagsNV                                     = GeometryInstanceFlagsKHR;
def BuildAccelerationStructureFlagsNV                           = BuildAccelerationStructureFlagsKHR;
def TransformMatrixNV                                           = TransformMatrixKHR;
def AabbPositionsNV                                             = AabbPositionsKHR;
def AccelerationStructureInstanceNV                             = AccelerationStructureInstanceKHR;
def QueueGlobalPriorityEXT                                      = QueueGlobalPriority;
def DeviceQueueGlobalPriorityCreateInfoEXT                      = DeviceQueueGlobalPriorityCreateInfo;
def TimeDomainEXT                                               = TimeDomainKHR;
def CalibratedTimestampInfoEXT                                  = CalibratedTimestampInfoKHR;
def VertexInputBindingDivisorDescriptionEXT                     = VertexInputBindingDivisorDescription;
def PipelineVertexInputDivisorStateCreateInfoEXT                = PipelineVertexInputDivisorStateCreateInfo;
def PhysicalDeviceVertexAttributeDivisorFeaturesEXT             = PhysicalDeviceVertexAttributeDivisorFeatures;
def PipelineCreationFeedbackFlagsEXT                            = PipelineCreationFeedbackFlags;
def PipelineCreationFeedbackCreateInfoEXT                       = PipelineCreationFeedbackCreateInfo;
def PipelineCreationFeedbackEXT                                 = PipelineCreationFeedback;
def PhysicalDeviceComputeShaderDerivativesFeaturesNV            = PhysicalDeviceComputeShaderDerivativesFeaturesKHR;
def PhysicalDeviceFragmentShaderBarycentricFeaturesNV           = PhysicalDeviceFragmentShaderBarycentricFeaturesKHR;
def QueryPoolCreateInfoINTEL                                    = QueryPoolPerformanceQueryCreateInfoINTEL;
def PhysicalDeviceScalarBlockLayoutFeaturesEXT                  = PhysicalDeviceScalarBlockLayoutFeatures;
def PhysicalDeviceSubgroupSizeControlFeaturesEXT                = PhysicalDeviceSubgroupSizeControlFeatures;
def PhysicalDeviceSubgroupSizeControlPropertiesEXT              = PhysicalDeviceSubgroupSizeControlProperties;
def PipelineShaderStageRequiredSubgroupSizeCreateInfoEXT        = PipelineShaderStageRequiredSubgroupSizeCreateInfo;
def PhysicalDeviceBufferAddressFeaturesEXT                      = PhysicalDeviceBufferDeviceAddressFeaturesEXT;
def BufferDeviceAddressInfoEXT                                  = BufferDeviceAddressInfo;
def ToolPurposeFlagsEXT                                         = ToolPurposeFlags;
def PhysicalDeviceToolPropertiesEXT                             = PhysicalDeviceToolProperties;
def ImageStencilUsageCreateInfoEXT                              = ImageStencilUsageCreateInfo;
def ComponentTypeNV                                             = ComponentTypeKHR;
def ScopeNV                                                     = ScopeKHR;
def LineRasterizationModeEXT                                    = LineRasterizationMode;
def PhysicalDeviceLineRasterizationFeaturesEXT                  = PhysicalDeviceLineRasterizationFeatures;
def PhysicalDeviceLineRasterizationPropertiesEXT                = PhysicalDeviceLineRasterizationProperties;
def PipelineRasterizationLineStateCreateInfoEXT                 = PipelineRasterizationLineStateCreateInfo;
def PhysicalDeviceHostQueryResetFeaturesEXT                     = PhysicalDeviceHostQueryResetFeatures;
def PhysicalDeviceIndexTypeUint8FeaturesEXT                     = PhysicalDeviceIndexTypeUint8Features;
def HostImageCopyFlagsEXT                                       = HostImageCopyFlags;
def PhysicalDeviceHostImageCopyFeaturesEXT                      = PhysicalDeviceHostImageCopyFeatures;
def PhysicalDeviceHostImageCopyPropertiesEXT                    = PhysicalDeviceHostImageCopyProperties;
def MemoryToImageCopyEXT                                        = MemoryToImageCopy;
def ImageToMemoryCopyEXT                                        = ImageToMemoryCopy;
def CopyMemoryToImageInfoEXT                                    = CopyMemoryToImageInfo;
def CopyImageToMemoryInfoEXT                                    = CopyImageToMemoryInfo;
def CopyImageToImageInfoEXT                                     = CopyImageToImageInfo;
def HostImageLayoutTransitionInfoEXT                            = HostImageLayoutTransitionInfo;
def SubresourceHostMemcpySizeEXT                                = SubresourceHostMemcpySize;
def HostImageCopyDevicePerformanceQueryEXT                      = HostImageCopyDevicePerformanceQuery;
def SubresourceLayout2EXT                                       = SubresourceLayout2;
def ImageSubresource2EXT                                        = ImageSubresource2;
def PhysicalDeviceShaderDemoteToHelperInvocationFeaturesEXT     = PhysicalDeviceShaderDemoteToHelperInvocationFeatures;
def PhysicalDeviceTexelBufferAlignmentPropertiesEXT             = PhysicalDeviceTexelBufferAlignmentProperties;
def PrivateDataSlotEXT                                          = PrivateDataSlot;
def PrivateDataSlotCreateFlagsEXT                               = PrivateDataSlotCreateFlags;
def PhysicalDevicePrivateDataFeaturesEXT                        = PhysicalDevicePrivateDataFeatures;
def DevicePrivateDataCreateInfoEXT                              = DevicePrivateDataCreateInfo;
def PrivateDataSlotCreateInfoEXT                                = PrivateDataSlotCreateInfo;
def PhysicalDevicePipelineCreationCacheControlFeaturesEXT       = PhysicalDevicePipelineCreationCacheControlFeatures;
def PhysicalDeviceImageRobustnessFeaturesEXT                    = PhysicalDeviceImageRobustnessFeatures;
def PhysicalDeviceRasterizationOrderAttachmentAccessFeaturesARM = PhysicalDeviceRasterizationOrderAttachmentAccessFeaturesEXT;
def PhysicalDeviceMutableDescriptorTypeFeaturesVALVE            = PhysicalDeviceMutableDescriptorTypeFeaturesEXT;
def MutableDescriptorTypeListVALVE                              = MutableDescriptorTypeListEXT;
def MutableDescriptorTypeCreateInfoVALVE                        = MutableDescriptorTypeCreateInfoEXT;
def PipelineInfoEXT                                             = PipelineInfoKHR;
def PhysicalDeviceGlobalPriorityQueryFeaturesEXT                = PhysicalDeviceGlobalPriorityQueryFeatures;
def QueueFamilyGlobalPriorityPropertiesEXT                      = QueueFamilyGlobalPriorityProperties;
def PhysicalDeviceSchedulingControlsFlagsARM                    = Flags64;
def PhysicalDeviceSchedulingControlsFlagARM                     = Flags64;
def MemoryDecompressionMethodFlagNV                             = Flags64;
def MemoryDecompressionMethodFlagsNV                            = Flags64;
def PhysicalDevicePipelineProtectedAccessFeaturesEXT            = PhysicalDevicePipelineProtectedAccessFeatures;
def ShaderRequiredSubgroupSizeCreateInfoEXT                     = PipelineShaderStageRequiredSubgroupSizeCreateInfo;


