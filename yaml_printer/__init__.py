from collections import OrderedDict
import os
import re
import sys
from catkin_pkg.package import parse_package
import ament_index_python

from rosidl_cmake import expand_template
import rosidl_parser

import yaml

def generate_cpp(output_path, template_dir):
    msgs = generate_messages()
    for pack in msgs['ros2_package_names_msg']:
        msg_list = {'mappings': [ m for m in msgs['mappings'] if (m.ros2_msg.package_name == pack and m.fields is not None)]}
        data_for_template = {'mappings': msg_list['mappings'], 'ros2_package_name':pack}
        template_file = os.path.join(template_dir, 'pkg_building_interface.cpp.em')
        output_file = os.path.join(output_path, '%s_building_interface.cpp' % pack)
        try:
            expand_template(template_file, data_for_template, output_file)
        except RuntimeError as e:
                print(str(e), file=sys.stderr)
        data_for_template = {'mappings': msg_list['mappings'], 'ros2_package_name':pack}
        template_file = os.path.join(template_dir, 'pkg_building_interface.hpp.em')
        output_file = os.path.join(output_path, '%s_building_interface.hpp' % pack)
        try:
            expand_template(template_file, data_for_template, output_file)
        except RuntimeError as e:
                print(str(e), file=sys.stderr)
    template_file = os.path.join(template_dir, 'building_interface.cpp.em')
    output_file = os.path.join(output_path, 'building_interface.cpp')
    data_for_template = {'ros2_package_names': msgs['ros2_package_names_msg']}
    try:
        expand_template(template_file, data_for_template, output_file)
    except RuntimeError as e:
        print(str(e), file=sys.stderr)
    template_file = os.path.join(template_dir, 'pkg_yaml_helper.cpp.em')
    output_file = os.path.join(output_path, 'yaml-helper.cpp')
    data_for_template = {'mappings': msgs['mappings']}
    try:
        expand_template(template_file, data_for_template, output_file)
    except RuntimeError as e:
        print(str(e), file=sys.stderr)
    template_file = os.path.join(template_dir, 'csv.hpp.em')
    output_file = os.path.join(output_path, 'csv.hpp')
    data_for_template = {'mappings': msgs['mappings']}
    try:
        expand_template(template_file, data_for_template, output_file)
    except RuntimeError as e:
        print(str(e), file=sys.stderr)
    template_file = os.path.join(template_dir, 'csv.cpp.em')
    output_file = os.path.join(output_path, 'csv.cpp')
    data_for_template = {'mappings': msgs['mappings']}
    try:
        expand_template(template_file, data_for_template, output_file)
    except RuntimeError as e:
        print(str(e), file=sys.stderr)
    template_file = os.path.join(template_dir, 'ros2_msgs.hpp.em')
    output_file = os.path.join(output_path, 'ros2_msgs.hpp')
    data_for_template = {'mappings': msgs['mappings']}
    try:
        expand_template(template_file, data_for_template, output_file)
    except RuntimeError as e:
        print(str(e), file=sys.stderr)
def generate_messages():
    pkgs, msgs = get_ros2_messages()
    mappings = []
    for ros2_msg in msgs:
        mapping = determine_field_mapping(ros2_msg)
        if mapping:
            mappings.append(mapping)

    # order mappings topologically to allow template specialization
    ordered_mappings = []
    while mappings:
        # pick first mapping without unsatisfied dependencies
        for m in mappings:
            if not m.depends_on_ros2_messages:
                break
        else:
            break
        # move mapping to ordered list
        mappings.remove(m)
        ordered_mappings.append(m)
        ros2_msg = m.ros2_msg
        # update unsatisfied dependencies of remaining mappings
        for m in mappings:
            if ros2_msg in m.depends_on_ros2_messages:
                m.depends_on_ros2_messages.remove(ros2_msg)

    if mappings:
        print('%d mappings can not be generated due to missing dependencies:' % len(mappings),
              file=sys.stderr)
        for m in mappings:
            print('- %s:' %
                  ('%s/%s' % (m.ros2_msg.package_name, m.ros2_msg.message_name)), file=sys.stderr)
            for d in m.depends_on_ros2_messages:
                print('  -', '%s/%s' % (d.package_name, d.message_name), file=sys.stderr)
        print(file=sys.stderr)

    return {
        'ros2_msgs': [m.ros2_msg for m in ordered_mappings],
        'mappings': ordered_mappings,
        'ros2_package_names_msg': pkgs
    }

def get_ros2_messages():
    msgs = []
    pkgs = []
    # get messages from packages
    resource_type = 'rosidl_interfaces'
    resources = ament_index_python.get_resources(resource_type)
    for package_name, prefix_path in resources.items():
        pkgs.append(package_name)
        resource, _ = ament_index_python.get_resource(resource_type, package_name)
        interfaces = resource.splitlines()
        message_names = {
            i[4:-4]
            for i in interfaces
            if i.startswith('msg/') and i[-4:] in ('.idl', '.msg')}
        for message_name in sorted(message_names):
            msgs.append(Message(package_name, message_name, prefix_path))
    return pkgs, msgs

def load_ros2_message(ros2_msg):
    message_path = os.path.join(
        ros2_msg.prefix_path, 'share', ros2_msg.package_name, 'msg',
        ros2_msg.message_name + '.msg')
    try:
        spec = rosidl_parser.parse_message_file(ros2_msg.package_name, message_path)
    except rosidl_parser.InvalidSpecification:
        return None
    return spec

def determine_field_mapping(ros2_msg):
    ros2_spec = load_ros2_message(ros2_msg)
    if not ros2_spec:
        return None

    mapping = Mapping(ros2_msg)
    if ros2_spec.fields is not None:
        for field in ros2_spec.fields:
            mapping.add_field(field)
        return mapping

class Message:
    __slots__ = [
        'package_name',
        'message_name',
        'prefix_path'
    ]

    def __init__(self, package_name, message_name, prefix_path=None):
        self.package_name = package_name
        self.message_name = message_name
        self.prefix_path = prefix_path

    def __eq__(self, other):
        return self.package_name == other.package_name and \
            self.message_name == other.message_name

    def __hash__(self):
        return hash('%s/%s' % (self.package_name, self.message_name))

    def __str__(self):
        return self.package_name + '/' + self.message_name

    def __repr__(self):
        return self.__str__()

class Mapping:
    __slots__ = [
        'ros2_msg',
        'fields',
        'depends_on_ros2_messages'
    ]

    def __init__(self, ros2_msg):
        self.ros2_msg = ros2_msg
        self.fields = []
        self.depends_on_ros2_messages = set()

    def add_field(self, ros2_field):
        self.fields.append(ros2_field)
        if ros2_field.type.pkg_name and ros2_field.type.pkg_name != 'builtin_interfaces':
            self.depends_on_ros2_messages.add(
                Message(ros2_field.type.pkg_name, ros2_field.type.type))
                
    # def is_field_mapping(self):
    #     return self.fields is not None

def camel_case_to_lower_case_underscore(value):
    # insert an underscore before any upper case letter
    # which is not followed by another upper case letter
    value = re.sub('(.)([A-Z][a-z]+)', '\\1_\\2', value)
    # insert an underscore before any upper case letter
    # which is preseded by a lower case letter or number
    value = re.sub('([a-z0-9])([A-Z])', '\\1_\\2', value)
    return value.lower()