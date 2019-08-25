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
#include "csv.hpp"

template<typename T>
std::ostream & operator<< (std::ostream &out, std::vector<T> const &t)
{
    for(std::size_t i = 0; i < t.size() - 1; i++)
    {
        out << t[i] << ", ";
    }
    out << t.back();
    return out;
}

template<typename T, std::size_t N>
std::ostream & operator<< (std::ostream &out, std::array<T, N> const &t)
{
    for(std::size_t i = 0; i < N - 1; i++)
    {
        out << t[i] << ", ";
    }
    out << t.back();
    return out;
}

template<typename T, std::size_t N>
std::ostream & operator<< (std::ostream &out, rosidl_generator_cpp::BoundedVector<T, N> const &t)
{
    for(std::size_t i = 0; i < N - 1; i++)
    {
        out << t[i] << ", ";
    }
    out << t.back();
    return out;
}
@[for mapping in mappings]@
std::ostream & operator<< (std::ostream &out, @(mapping.ros2_msg.package_name)::msg::@(mapping.ros2_msg.message_name) const &t)
{
    @[if len(mapping.fields) > 0 ]@ 
       @{ x = mapping.fields.pop()}
    out@[for field in mapping.fields] << t.@(field.name) << ", " @[end for]@ << t.@(x.name);
    @[end if]@
    return out;
}
@[end for]@

