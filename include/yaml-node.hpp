#ifndef YAMLNODE_HPP_
#define YAMLNODE_HPP_

#include <iostream>
#include <chrono>
#include "rclcpp/rclcpp.hpp"
#include "sstream"
#include <memory>
#include <yaml-cpp/yaml.h>
class YamlNodeBase
{
    public:
        YamlNodeBase()
        {

        }

    protected:
    rclcpp::Node::SharedPtr yaml_node_;
    rclcpp::SubscriptionBase::SharedPtr subscription_;
};

template<class MessageT>
class YamlNode: public YamlNodeBase
{
    public:
        YamlNode(int argc, char * argv[])
        {
            
        }

    private:
    void topic_callback_(const std::shared_ptr<MessageT> msg);
};

#endif