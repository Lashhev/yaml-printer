import os
import sys
import argparse

yaml_printer_root = os.path.join(os.path.dirname(__file__), '..')
sys.path.insert(0, os.path.abspath(yaml_printer_root))

from yaml_printer import *

def main(argv=sys.argv[1:]):
    parser = argparse.ArgumentParser(
        description='Generate C++ template specializations for all ROS message types.',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument(
        '--output-path',
        required=True,
        help='The basepath of the generated C++ files')
    parser.add_argument(
        '--template-dir',
        required=True,
        help='The location of the template files')
    args = parser.parse_args(argv)

    try:
        return generate_cpp(
            args.output_path,
            args.template_dir,
        )
    except RuntimeError as e:
        print(str(e), file=sys.stderr)
        return 1


if __name__ == '__main__':
    sys.exit(main())
