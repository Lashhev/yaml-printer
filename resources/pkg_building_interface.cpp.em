// generated from ros1_bridge/resource/pkg_building_interface.hpp.em

@###############################################
@#
@# Factory for creating publisher / subscribers
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
@#  - ros2_msgs (list of ros1_bridge.Message)
@#    ROS 2 messages
@###############################################

@{
from yaml_printer import camel_case_to_lower_case_underscore
}@
#include <cstddef>
#include "@(ros2_package_name)_building_interface.hpp"

std::shared_ptr<YamlNodeBase> get_@(ros2_package_name)_yaml_node(std::string msg_type)
{
  @[for mapping in mappings]@
  if(
  msg_type == "@(mapping.ros2_msg.package_name)/@(mapping.ros2_msg.message_name)")
  {
    return std::make_shared<YamlNode<@(mapping.ros2_msg.package_name)::msg::@(mapping.ros2_msg.message_name)>>();
  }
  @[end for]@
  return nullptr;
}
