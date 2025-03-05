import os
from launch import LaunchDescription
from launch_ros.actions import Node
from launch.actions import ExecuteProcess
from ament_index_python.packages import get_package_share_directory

def generate_launch_description():
    # Get the path to the sub_pub package
    sub_pub_dir = get_package_share_directory('sub_pub')

    # Corrected path to zenoh.config inside the sub_pub package
    zenoh_config_path = os.path.join(sub_pub_dir, 'config', 'zenoh_pub.config.json5')

    return LaunchDescription([
        # Launch Zenoh bridge as an external process
        ExecuteProcess(
            cmd=[
                'zenoh-bridge-ros2dds',
                '-c', zenoh_config_path
            ],
            name='zenoh_bridge',
            output='screen'
        ),
        # Launch the publisher node
        Node(
            package='sub_pub',
            executable='publisher',
            name='publisher',
            output='screen'
        )
    ])
