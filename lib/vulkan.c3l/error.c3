module vk;

fault VulkanError {
	NOT_READY                                          ,
	TIMEOUT                                            ,
	EVENT_SET                                          ,
	EVENT_RESET                                        ,
	INCOMPLETE                                         ,
	ERROR_OUT_OF_HOST_MEMORY                           ,
	ERROR_OUT_OF_DEVICE_MEMORY                         ,
	ERROR_INITIALIZATION_FAILED                        ,
	ERROR_DEVICE_LOST                                  ,
	ERROR_MEMORY_MAP_FAILED                            ,
	ERROR_LAYER_NOT_PRESENT                            ,
	ERROR_EXTENSION_NOT_PRESENT                        ,
	ERROR_FEATURE_NOT_PRESENT                          ,
	ERROR_INCOMPATIBLE_DRIVER                          ,
	ERROR_TOO_MANY_OBJECTS                             ,
	ERROR_FORMAT_NOT_SUPPORTED                         ,
	ERROR_FRAGMENTED_POOL                              ,
	ERROR_UNKNOWN                                      ,
	ERROR_OUT_OF_POOL_MEMORY                           ,
	ERROR_INVALID_EXTERNAL_HANDLE                      ,
	ERROR_FRAGMENTATION                                ,
	ERROR_INVALID_OPAQUE_CAPTURE_ADDRESS               ,
	PIPELINE_COMPILE_REQUIRED                          ,
	ERROR_NOT_PERMITTED                                ,
	ERROR_SURFACE_LOST_KHR                             ,
	ERROR_NATIVE_WINDOW_IN_USE_KHR                     ,
	SUBOPTIMAL_KHR                                     ,
	ERROR_OUT_OF_DATE_KHR                              ,
	ERROR_INCOMPATIBLE_DISPLAY_KHR                     ,
	ERROR_VALIDATION_FAILED_EXT                        ,
	ERROR_INVALID_SHADER_NV                            ,
	ERROR_IMAGE_USAGE_NOT_SUPPORTED_KHR                ,
	ERROR_VIDEO_PICTURE_LAYOUT_NOT_SUPPORTED_KHR       ,
	ERROR_VIDEO_PROFILE_OPERATION_NOT_SUPPORTED_KHR    ,
	ERROR_VIDEO_PROFILE_FORMAT_NOT_SUPPORTED_KHR       ,
	ERROR_VIDEO_PROFILE_CODEC_NOT_SUPPORTED_KHR        ,
	ERROR_VIDEO_STD_VERSION_NOT_SUPPORTED_KHR          ,
	ERROR_INVALID_DRM_FORMAT_MODIFIER_PLANE_LAYOUT_EXT ,
	ERROR_FULL_SCREEN_EXCLUSIVE_MODE_LOST_EXT          ,
	THREAD_IDLE_KHR                                    ,
	THREAD_DONE_KHR                                    ,
	OPERATION_DEFERRED_KHR                             ,
	OPERATION_NOT_DEFERRED_KHR                         ,
	ERROR_INVALID_VIDEO_STD_PARAMETERS_KHR             ,
	ERROR_COMPRESSION_EXHAUSTED_EXT                    ,
	INCOMPATIBLE_SHADER_BINARY_EXT                     ,
	PIPELINE_BINARY_MISSING_KHR                        ,
	ERROR_NOT_ENOUGH_SPACE_KHR                         ,
}

fault BindingError {
    ERROR_UNHANDLED,
}

// module vk @private;

fn void! check(vk::Result result) @inline {
    switch (result) {
        case SUCCESS: return;
        case NOT_READY: return VulkanError.NOT_READY?;
        case TIMEOUT: return VulkanError.TIMEOUT?;
        case EVENT_SET: return VulkanError.EVENT_SET?;
        case EVENT_RESET: return VulkanError.EVENT_RESET?;
        case INCOMPLETE: return VulkanError.INCOMPLETE?;
        case ERROR_OUT_OF_HOST_MEMORY: return VulkanError.ERROR_OUT_OF_HOST_MEMORY?;
        case ERROR_OUT_OF_DEVICE_MEMORY: return VulkanError.ERROR_OUT_OF_DEVICE_MEMORY?;
        case ERROR_INITIALIZATION_FAILED: return VulkanError.ERROR_INITIALIZATION_FAILED?;
        case ERROR_DEVICE_LOST: return VulkanError.ERROR_DEVICE_LOST?;
        case ERROR_MEMORY_MAP_FAILED: return VulkanError.ERROR_MEMORY_MAP_FAILED?;
        case ERROR_LAYER_NOT_PRESENT: return VulkanError.ERROR_LAYER_NOT_PRESENT?;
        case ERROR_EXTENSION_NOT_PRESENT: return VulkanError.ERROR_EXTENSION_NOT_PRESENT?;
        case ERROR_FEATURE_NOT_PRESENT: return VulkanError.ERROR_FEATURE_NOT_PRESENT?;
        case ERROR_INCOMPATIBLE_DRIVER: return VulkanError.ERROR_INCOMPATIBLE_DRIVER?;
        case ERROR_TOO_MANY_OBJECTS: return VulkanError.ERROR_TOO_MANY_OBJECTS?;
        case ERROR_FORMAT_NOT_SUPPORTED: return VulkanError.ERROR_FORMAT_NOT_SUPPORTED?;
        case ERROR_FRAGMENTED_POOL: return VulkanError.ERROR_FRAGMENTED_POOL?;
        case ERROR_UNKNOWN: return VulkanError.ERROR_UNKNOWN?;
        case ERROR_OUT_OF_POOL_MEMORY: return VulkanError.ERROR_OUT_OF_POOL_MEMORY?;
        case ERROR_INVALID_EXTERNAL_HANDLE: return VulkanError.ERROR_INVALID_EXTERNAL_HANDLE?;
        case ERROR_FRAGMENTATION: return VulkanError.ERROR_FRAGMENTATION?;
        case ERROR_INVALID_OPAQUE_CAPTURE_ADDRESS: return VulkanError.ERROR_INVALID_OPAQUE_CAPTURE_ADDRESS?;
        case PIPELINE_COMPILE_REQUIRED: return VulkanError.PIPELINE_COMPILE_REQUIRED?;
        case ERROR_NOT_PERMITTED: return VulkanError.ERROR_NOT_PERMITTED?;
        case ERROR_SURFACE_LOST_KHR: return VulkanError.ERROR_SURFACE_LOST_KHR?;
        case ERROR_NATIVE_WINDOW_IN_USE_KHR: return VulkanError.ERROR_NATIVE_WINDOW_IN_USE_KHR?;
        case SUBOPTIMAL_KHR: return VulkanError.SUBOPTIMAL_KHR?;
        case ERROR_OUT_OF_DATE_KHR: return VulkanError.ERROR_OUT_OF_DATE_KHR?;
        case ERROR_INCOMPATIBLE_DISPLAY_KHR: return VulkanError.ERROR_INCOMPATIBLE_DISPLAY_KHR?;
        case ERROR_VALIDATION_FAILED_EXT: return VulkanError.ERROR_VALIDATION_FAILED_EXT?;
        case ERROR_INVALID_SHADER_NV: return VulkanError.ERROR_INVALID_SHADER_NV?;
        case ERROR_IMAGE_USAGE_NOT_SUPPORTED_KHR: return VulkanError.ERROR_IMAGE_USAGE_NOT_SUPPORTED_KHR?;
        case ERROR_VIDEO_PICTURE_LAYOUT_NOT_SUPPORTED_KHR: return VulkanError.ERROR_VIDEO_PICTURE_LAYOUT_NOT_SUPPORTED_KHR?;
        case ERROR_VIDEO_PROFILE_OPERATION_NOT_SUPPORTED_KHR: return VulkanError.ERROR_VIDEO_PROFILE_OPERATION_NOT_SUPPORTED_KHR?;
        case ERROR_VIDEO_PROFILE_FORMAT_NOT_SUPPORTED_KHR: return VulkanError.ERROR_VIDEO_PROFILE_FORMAT_NOT_SUPPORTED_KHR?;
        case ERROR_VIDEO_PROFILE_CODEC_NOT_SUPPORTED_KHR: return VulkanError.ERROR_VIDEO_PROFILE_CODEC_NOT_SUPPORTED_KHR?;
        case ERROR_VIDEO_STD_VERSION_NOT_SUPPORTED_KHR: return VulkanError.ERROR_VIDEO_STD_VERSION_NOT_SUPPORTED_KHR?;
        case ERROR_INVALID_DRM_FORMAT_MODIFIER_PLANE_LAYOUT_EXT: return VulkanError.ERROR_INVALID_DRM_FORMAT_MODIFIER_PLANE_LAYOUT_EXT?;
        case ERROR_FULL_SCREEN_EXCLUSIVE_MODE_LOST_EXT: return VulkanError.ERROR_FULL_SCREEN_EXCLUSIVE_MODE_LOST_EXT?;
        case THREAD_IDLE_KHR: return VulkanError.THREAD_IDLE_KHR?;
        case THREAD_DONE_KHR: return VulkanError.THREAD_DONE_KHR?;
        case OPERATION_DEFERRED_KHR: return VulkanError.OPERATION_DEFERRED_KHR?;
        case OPERATION_NOT_DEFERRED_KHR: return VulkanError.OPERATION_NOT_DEFERRED_KHR?;
        case ERROR_INVALID_VIDEO_STD_PARAMETERS_KHR: return VulkanError.ERROR_INVALID_VIDEO_STD_PARAMETERS_KHR?;
        case ERROR_COMPRESSION_EXHAUSTED_EXT: return VulkanError.ERROR_COMPRESSION_EXHAUSTED_EXT?;
        case INCOMPATIBLE_SHADER_BINARY_EXT: return VulkanError.INCOMPATIBLE_SHADER_BINARY_EXT?;
        case PIPELINE_BINARY_MISSING_KHR: return VulkanError.PIPELINE_BINARY_MISSING_KHR?;
        case ERROR_NOT_ENOUGH_SPACE_KHR: return VulkanError.ERROR_NOT_ENOUGH_SPACE_KHR?;
        default: return BindingError.ERROR_UNHANDLED?;
    }
}
