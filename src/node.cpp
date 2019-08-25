#include "building_interface.hpp"
//#include "yaml-helper.cpp"
int main(int argc, char * argv[])
{
  if(argc < 2 && argc > 2)
    return 0;
  rclcpp::init(argc, argv);
  std::string msg_name = argv[1];
  std::shared_ptr<YamlNodeBase> topic_node = get_yaml_node(msg_name);
  return 0;
}
    