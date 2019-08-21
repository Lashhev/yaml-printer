cmake_minimum_required(VERSION 3.5)
project(yaml-printer)

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic -Wunused-parameter)
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wno-long-long -pedantic -Wunused-parameter")

find_package(ament_cmake REQUIRED)
find_package(class_loader REQUIRED)
find_package(rclcpp REQUIRED)
find_package(yaml-cpp REQUIRED)

set(generated_path "${CMAKE_BINARY_DIR}/generated")
set(generated_files "${generated_path}/building_interface.cpp")
set(yaml_helper_file "${generated_path}/yaml-helper.cpp")
# generate per package compilation units to keep the memory usage low
ament_index_get_resources(ros2_message_packages "rosidl_interfaces")
foreach(message_package ${ros2_message_packages})
  find_package(${message_package} QUIET REQUIRED)
  message(STATUS "Found ${message_package}: ${${message_package}_VERSION} (${${message_package}_DIR})")
  list(APPEND generated_files "${generated_path}/${message_package}_building_interface.cpp")
endforeach()
#message(WARNING "Found ${generated_files}")
add_custom_command(
  OUTPUT ${generated_files}
  COMMAND ${PYTHON_EXECUTABLE} bin/get_rospack.py
    --output-path "${generated_path}" --template-dir resources
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
message(STATUS "Found ${generated_files}")
if(NOT WIN32)
  # ignore warning in ROS 1 message headers
  set_source_files_properties(${generated_files}
  PROPERTIES COMPILE_FLAGS "-Wno-unused-parameter")
endif()

include_directories(include)
include_directories(${YAML_CPP_INCLUDE_DIR})
include_directories(${generated_path})

add_library(${PROJECT_NAME} SHARED        
  ${generated_files})
target_compile_definitions(${PROJECT_NAME}
  PRIVATE "${PROJECT_NAME}_DLL")
target_link_libraries(${PROJECT_NAME})
ament_target_dependencies(${PROJECT_NAME} rclcpp ${ros2_message_packages} class_loader)

add_library(yaml_helper SHARED        
${yaml_helper_file})
target_compile_definitions(yaml_helper
  PRIVATE "YAML_HELPER_DLL")
target_link_libraries(yaml_helper ${YAML_CPP_LIBRARIES})
ament_target_dependencies(yaml_helper rclcpp ${ros2_message_packages} class_loader)
# This package installs libraries without exporting them.
# Export the library path to ensure that the installed libraries are available.
if(NOT WIN32)
  ament_environment_hooks(
    "${ament_cmake_package_templates_ENVIRONMENT_HOOK_LIBRARY_PATH}"
    )
endif()

add_executable(${PROJECT_NAME}_node src/node.cpp)
target_link_libraries(${PROJECT_NAME}_node yaml_helper ${PROJECT_NAME} ${YAML_CPP_LIBRARIES})
ament_target_dependencies(${PROJECT_NAME}_node yaml_helper ${PROJECT_NAME} rclcpp class_loader)

install(TARGETS
  ${PROJECT_NAME}
   yaml_helper
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin)

install(TARGETS
  ${PROJECT_NAME}_node
  DESTINATION lib/${PROJECT_NAME})

ament_package()