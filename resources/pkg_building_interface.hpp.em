// generated from ros1_bridge/resource/pkg_building_interface.cpp.em

@###############################################
@#
@# Factory for creating ros2topiccpp nodes
@# based on message names
@#
@# EmPy template for generating building_interface.cpp
@#
@###############################################
@# Start of Template
@#
@# Context:
@#  - ros2_package_name (str)
@#    The ROS 2 package name of this file
@#  - mappings (list of ros1_bridge.Mapping)
@#    Mapping between messages as well as their fields
@###############################################
@{
from yaml_printer import camel_case_to_lower_case_underscore
}@
#include "yaml-node.hpp"
@[for mapping in mappings]@
#include <@(mapping.ros2_msg.package_name)/msg/@(camel_case_to_lower_case_underscore(mapping.ros2_msg.message_name)).hpp>
@[end for]@
std::shared_ptr<YamlNodeBase> get_@(ros2_package_name)_yaml_node(std::string msg_type);

