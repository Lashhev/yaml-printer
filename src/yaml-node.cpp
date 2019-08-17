#include "yaml-node.hpp"

using std::placeholders::_1;

template <class MessageT>
void YamlNode<MessageT>::topic_callback_(const std::shared_ptr<MessageT> msg)
{
  YAML::Node ros_msg;
  std::stringstream output;
  ros_msg = *msg.get();
  output << ros_msg;

  RCLCPP_INFO(yaml_node_->get_logger(),"\n%s", output.str().c_str());
}
template <class MessageT>
YamlNode<MessageT>::YamlNode(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  yaml_node_ = rclcpp::Node::make_shared("yaml_printer");
  subscription_ = yaml_node_->create_subscription<MessageT>
      ("topic", std::bind(&YamlNode<MessageT>::topic_callback_, this, _1));
  rclcpp::spin(yaml_node_);
  rclcpp::shutdown();
  subscription_ = nullptr;
  yaml_node_ = nullptr;
}


