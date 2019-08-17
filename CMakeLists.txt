cmake_minimum_required(VERSION 3.5)
project(yaml-printer)

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(ament_cmake REQUIRED)
find_package(class_loader REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)
find_package(geometry_msgs REQUIRED)
find_package(yaml-cpp REQUIRED)

set(generated_path "${CMAKE_BINARY_DIR}/generated")
set(generated_files "${generated_path}/building_interface.cpp")

# generate per package compilation units to keep the memory usage low
ament_index_get_resources(ros2_message_packages "rosidl_interfaces")
foreach(message_package ${ros2_message_packages})
  find_package(${message_package} QUIET REQUIRED)
  message(STATUS "Found ${message_package}: ${${message_package}_VERSION} (${${message_package}_DIR})")
  if(NOT "${message_package}" STREQUAL "builtin_interfaces")
    list(APPEND generated_files "${generated_path}/${message_package}_yaml-helper.cpp")
    list(APPEND generated_files "${generated_path}/${message_package}_building_interface.cpp")
  endif()
endforeach()

add_custom_command(
  OUTPUT ${generated_files}
  COMMAND ${PYTHON_EXECUTABLE} bin/get_rospack.py
    --output-path "${generated_path}" --template-dir resources
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

if(NOT WIN32)
  # ignore warning in ROS 1 message headers
  set_source_files_properties(${generated_files}
  PROPERTIES COMPILE_FLAGS "-Wno-unused-parameter")
endif()

include_directories(include)
include_directories(${YAML_CPP_INCLUDE_DIR})
include_directories(${generated_files})

add_library(lib${PROJECT_NAME} SHARED        
  ${generated_files})
target_compile_definitions(lib${PROJECT_NAME}
  PRIVATE "${PROJECT_NAME}_DLL")
target_link_libraries(lib${PROJECT_NAME} ${YAML_CPP_LIBRARIES})
ament_target_dependencies(lib${PROJECT_NAME} rclcpp ${ros2_message_packages} class_loader)

# This package installs libraries without exporting them.
# Export the library path to ensure that the installed libraries are available.
if(NOT WIN32)
  ament_environment_hooks(
    "${ament_cmake_package_templates_ENVIRONMENT_HOOK_LIBRARY_PATH}"
    )
endif()

add_executable(${PROJECT_NAME}_node src/node.cpp)
target_link_libraries(${PROJECT_NAME}_node lib${PROJECT_NAME})
ament_target_dependencies(${PROJECT_NAME}_node lib${PROJECT_NAME} rclcpp geometry_msgs class_loader)

install(TARGETS
  lib${PROJECT_NAME}
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin)

install(TARGETS
  ${PROJECT_NAME}_node
  DESTINATION lib/${PROJECT_NAME})

ament_package()