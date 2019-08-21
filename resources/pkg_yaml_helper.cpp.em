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
#define CONVERT_SIZED_ARRAY(type, size) \
template<> \
  struct convert<std::array<type, size>> \
  { \
    static Node encode(const std::array<type, size> &rhs) { \
    Node array; \
    std::vector<type> v; \
    v.assign(rhs.data(), rhs.data() + size); \
    array = v; \
    return array; \
    } \
    static bool decode(const Node& node, std::array<type, size> &rhs) \
    { \
      return false; \
    } \
  };
  
#include "yaml-cpp/yaml.h"
@[for mapping in mappings]@
#include <@(mapping.ros2_msg.package_name)/msg/@(camel_case_to_lower_case_underscore(mapping.ros2_msg.message_name)).hpp>
@[end for]@
namespace YAML {
CONVERT_SIZED_ARRAY(uint8_t, 16);
CONVERT_SIZED_ARRAY(double, 36);
CONVERT_SIZED_ARRAY(double, 9);;
CONVERT_SIZED_ARRAY(double, 12);
CONVERT_SIZED_ARRAY(uint32_t, 3);
CONVERT_SIZED_ARRAY(double, 4);
CONVERT_SIZED_ARRAY(double, 3);
  template<>
  struct convert<rosidl_generator_cpp::BoundedVector<double, 3, std::allocator<double> > > 
  {
    static Node encode(const rosidl_generator_cpp::BoundedVector<double, 3, std::allocator<double> >  &rhs) { 
    Node SolidPrimitive;
    double f[3] = {1,2,43};//static_cast<double*>(rhs.data());
    std::vector<double> v;
    v.assign(f, f + 3);
    SolidPrimitive = v;
    return SolidPrimitive;
    }

    static bool decode(const Node& node, rosidl_generator_cpp::BoundedVector<double, 3, std::allocator<double> >  &rhs) 
    {
      
      return false;
    }
  };
//CONVERT_SIZED_ARRAY(rosidl_generator_cpp::BoundedVector<double, 3, std::allocator<double> >, 3);
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