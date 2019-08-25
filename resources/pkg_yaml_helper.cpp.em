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
  #include <ros2_msgs.hpp>
  #include "yaml-cpp/yaml.h"
namespace YAML {
  template<typename T, std::size_t N> 
  struct convert<std::array<T, N>> 
  { 
    static Node encode(const std::array<T, N> &rhs) { 
    Node array; 
    std::vector<T> v; 
    v.assign(rhs.data(), rhs.data() + N); 
    array = v; 
    return array; 
    } 
    static bool decode(const Node& node, std::array<T, N> &rhs) 
    { 
      return false; 
    } 
  };

  template<typename T, std::size_t N>
  struct convert<rosidl_generator_cpp::BoundedVector<T, N> > 
  {
    static Node encode(const rosidl_generator_cpp::BoundedVector<T, N >  &rhs) { 
    Node SolidPrimitive;
    std::vector<T> v;
    for(auto i:rhs)
      v.push_back(i);
    SolidPrimitive = v;
    return SolidPrimitive;
    }

    static bool decode(const Node& node, rosidl_generator_cpp::BoundedVector<T, N>  &rhs) 
    {
      
      return false;
    }
  };
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
      return false;
    }
  };
  @[end for]@

}