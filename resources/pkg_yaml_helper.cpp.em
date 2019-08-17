// generated from ros1_bridge/resource/pkg_yaml_helper.cpp.em

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
@{
from yaml_printer import camel_case_to_lower_case_underscore
}@
#include "yaml-cpp/yaml.h"
// include ROS 2 messages
@[for mapping in mappings]@
#include <@(mapping.ros2_msg.package_name)/msg/@(camel_case_to_lower_case_underscore(mapping.ros2_msg.message_name)).hpp>
@[end for]@

namespace YAML {
@[for mapping in mappings]@
  template<>
  struct convert<@(mapping.ros2_msg.package_name)::msg::@(mapping.ros2_msg.message_name)> 
  {
    static Node encode(const @(mapping.ros2_msg.package_name)::msg::@(mapping.ros2_msg.message_name) &rhs) { 
    Node @(mapping.ros2_msg.message_name);
    @[for field in mapping.fields] Node @(field.name);
    @[end for]@
    @[for field in mapping.fields]@ 
    @(field.name)["@(field.name)"] = rhs.@(field.name);
    @[end for]@
    @{x = 0}
    @[for field in mapping.fields]@ @(mapping.ros2_msg.message_name)[@(x)] = @(field.name);
    @{x = x + 1}
    @[end for]@ return @(mapping.ros2_msg.message_name);
    }

    static bool decode(const Node& node, @(mapping.ros2_msg.package_name)::msg::@(mapping.ros2_msg.message_name) &rhs) 
    {
      
    }
  };
  @[end for]@
}