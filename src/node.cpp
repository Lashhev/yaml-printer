#include "building_interface.hpp"

int main(int argc, char * argv[])
{
  std::string msg_name = "sensor_msgs/Joy";
  std::shared_ptr<YamlNodeBase> topic_node = get_yaml_node(msg_name);
  return 0;
}
    