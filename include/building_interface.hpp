#ifndef BUILDING_INTERFACE_HPP_
#define BUILDING_INTERFACE_HPP_
#include "yaml-node.hpp"

std::shared_ptr<YamlNodeBase> get_yaml_node(std::string msg_type);

#endif