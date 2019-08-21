// generated from ros1_bridge/resource/get_factory.cpp.em

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
@#  - ros2_package_names (list of str)
@#    ROS 2 package names
@###############################################
@
@{
from yaml_printer import camel_case_to_lower_case_underscore
}@
#include "building_interface.hpp"
//#include "yaml-helper.cpp"
@[for ros2_package_name in sorted(ros2_package_names)]@
#include "@(ros2_package_name)_building_interface.hpp"
@[end for]@

std::shared_ptr<YamlNodeBase> get_yaml_node(std::string msg_type)
{
  @[if not ros2_package_names]@
    (void)ros1_type_name;
    (void)ros2_type_name;
  @[else]@
    std::shared_ptr<YamlNodeBase> node;
  @[end if]@
  @[for ros2_package_name in sorted(ros2_package_names)]@
    node = get_@(ros2_package_name)_yaml_node(msg_type);
  if (node) {
    return node;
  }
  @[end for]@
  throw std::runtime_error("No template specialization for msg type");
}
