// generated from ros1_bridge/resource/ros2_msgs.hpp.em

@###############################################
@#
@# Template specialization for YAML::Node
@#
@# EmPy template for generating pkg_yaml_helper.cpp
@#
@###############################################
@# Start of Template
@#
@# Context:
@#  - mappings (list of yaml_printer.Mapping)
@#    Mapping between messages as well as their fields
@###############################################
@
#ifndef ROS2_MSGS_HPP_
#define ROS2_MSGS_HPP_
@{
from yaml_printer import camel_case_to_lower_case_underscore
}@
@[for mapping in mappings]@
#include <@(mapping.ros2_msg.package_name)/msg/@(camel_case_to_lower_case_underscore(mapping.ros2_msg.message_name)).hpp>
@[end for]@
#endif