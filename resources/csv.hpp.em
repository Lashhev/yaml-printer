// generated from ros1_bridge/resource/csv.cpp.em

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
#include <ros2_msgs.hpp>
#include <stdlib.h>
#include <iostream>
#include <vector>
#include <string>
#include <iterator>

template<typename T>
std::ostream & operator<< (std::ostream &out, std::vector<T> const &t);

template<typename T, std::size_t N>
std::ostream & operator<< (std::ostream &out, std::array<T, N> const &t);

template<typename T, std::size_t N>
std::ostream & operator<< (std::ostream &out, rosidl_generator_cpp::BoundedVector<T, N> const &t);
@[for mapping in mappings]@
std::ostream & operator<< (std::ostream &out, @(mapping.ros2_msg.package_name)::msg::@(mapping.ros2_msg.message_name) const &t);
@[end for]@

