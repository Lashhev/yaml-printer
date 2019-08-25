#ifndef YAMLNODE_HPP_
#define YAMLNODE_HPP_

#include <iostream>
#include <chrono>
#include "rclcpp/rclcpp.hpp"
#include "sstream"
#include <memory>
//#include <yaml-cpp/yaml.h>
#include "yaml-helper.cpp"
#include "csv.hpp"

using std::placeholders::_1;
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
        YamlNode();
    private:
    void topic_callback_(const std::shared_ptr<MessageT> msg);
};
template <class MessageT>
void YamlNode<MessageT>::topic_callback_(const std::shared_ptr<MessageT> msg)
{
  YAML::Node ros_msg;
  std::stringstream output;
  ros_msg = *msg.get();
  output << ros_msg;
  // output << *msg.get();
  RCLCPP_INFO(yaml_node_->get_logger(),"\n%s", output.str().c_str());
}
template <class MessageT>
YamlNode<MessageT>::YamlNode()
{
  yaml_node_ = rclcpp::Node::make_shared("yaml_printer");
  subscription_ = yaml_node_->create_subscription<MessageT>
      ("topic", std::bind(&YamlNode<MessageT>::topic_callback_, this, _1));
  rclcpp::spin(yaml_node_);
  rclcpp::shutdown();
  subscription_ = nullptr;
  yaml_node_ = nullptr;
}

#endif