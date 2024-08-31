cmake_minimum_required(VERSION 3.0...3.25)
project(WebGPU VERSION 1.0 LANGUAGES CXX C)

find_package(Dawn PATHS lib64/cmake REQUIRED)
add_executable(App src/main.cpp)

target_include_directories(App PRIVATE include)
target_link_libraries(App PRIVATE dawn::webgpu_dawn)

set_target_properties(App PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON      # Configuration fails if C++17 is not available
    CXX_EXTENSIONS OFF
    COMPILE_WARNINGS_AS_ERRORS ON
)

if (MSVC)
    target_compile_options(App PRIVATE /W4)
else()
    target_compile_options(App PRIVATE -Wall -Wextra -pedantic)
endif()

# for MacOS
if (XCODE)
    set_target_properties(App PROPERTIES
        XCODE_GENERATE_SCHEME ON
        XCODE_SCHEME_ENABLE_GPU_FRAME_CAPTURE_MODE "Metal"
    )
endif()

# target_copy_webgpu_binaries(App) # Needed only when using pre-compiled binaries
