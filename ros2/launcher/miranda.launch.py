"""Start Miranda's ROS nodes using the adjacent robot configuration."""

from pathlib import Path
import xml.etree.ElementTree as ET

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, IncludeLaunchDescription, OpaqueFunction
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node
from launch_ros.parameter_descriptions import ParameterValue


ROOT = Path(__file__).resolve().parents[2]
CONTROLLER_PACKAGE = 'advrf_ros2_motors_controller'


def load_robot_description(urdf_path, joint_config, namespace):
    """Check joint names before passing the model to robot_state_publisher."""
    from advrf_ros2_motors_controller.panel_config import load_joints

    description = Path(urdf_path).expanduser().read_text()
    robot = ET.fromstring(description)

    model_joints = {
        joint.get('name')
        for joint in robot.findall('joint')
        if joint.get('type') != 'fixed'
    }
    missing = [
        name
        for name, _, _ in load_joints(joint_config, namespace)
        if name not in model_joints
    ]

    if missing:
        raise ValueError(f'Configured joints missing from URDF: {missing}')

    return description


def include_launch(path, arguments):
    return IncludeLaunchDescription(
        PythonLaunchDescriptionSource(str(path)),
        launch_arguments=arguments.items(),
    )


def setup(context):
    def value(name):
        return LaunchConfiguration(name).perform(context)

    def enabled(name):
        return value(name).lower() == 'true'

    namespace = value('namespace')
    joint_config = value('joint_config')
    launch_dir = Path(get_package_share_directory(CONTROLLER_PACKAGE)) / 'launch'

    controller_config = {
        'namespace': namespace,
        'joint_config': joint_config,
        'robot_id_map': value('robot_id_map'),
        'control_mode': value('control_mode'),
        'motor_profiles_dir': value('motor_profiles_dir'),
        'motor_profile': value('motor_profile'),
    }

    actions = []

    # Robot model: measured joint states -> TF.
    if enabled('robot_state'):
        description = load_robot_description(value('urdf'), joint_config, namespace)

        actions.append(Node(
            package='robot_state_publisher',
            executable='robot_state_publisher',
            namespace=namespace,
            output='screen',
            parameters=[{
                'robot_description': ParameterValue(description, value_type=str),
                'use_sim_time': False,
            }],
            remappings=[('joint_states', 'rx/joint_states')],
        ))

    # Motor backend: direct input starts disabled; START remains explicit.
    if enabled('controllers'):
        actions.extend([
            include_launch(launch_dir / 'joint.launch.py', {
                **controller_config,
                'command_enabled': 'false',
            }),
            include_launch(launch_dir / 'go_to.launch.py', {
                **controller_config,
                'trajectory_config': value('trajectory_config'),
            }),
            include_launch(launch_dir / 'motors.launch.py', {
                **controller_config,
                'auto_start_motors': 'false',
            }),
        ])

    # Operator panel: client only, with no backend startup responsibilities.
    if enabled('panel'):
        actions.append(include_launch(launch_dir / 'panel.launch.py', {
            'namespace': namespace,
            'joint_config': joint_config,
        }))

    # Visualization.
    if enabled('rviz'):
        actions.append(Node(
            package='rviz2',
            executable='rviz2',
            namespace=namespace,
            output='screen',
            arguments=['-d', str(ROOT / 'ros2/rviz/miranda.rviz')],
        ))

    return actions


def generate_launch_description():
    robot_arguments = [
        DeclareLaunchArgument(
            'namespace',
            default_value='/advrf/miranda',
        ),
        DeclareLaunchArgument(
            'control_mode',
            default_value='position',
            choices=['position', 'impedance', 'velocity', 'torque', 'current'],
        ),
    ]

    config_arguments = [
        DeclareLaunchArgument(
            'joint_config',
            default_value=str(ROOT / 'ros2/config/joint_config.yaml'),
        ),
        DeclareLaunchArgument(
            'robot_id_map',
            default_value=str(ROOT / 'robot_id_map/miranda_id_map.yaml'),
        ),
        DeclareLaunchArgument(
            'trajectory_config',
            default_value='',
        ),
        DeclareLaunchArgument(
            'motor_profiles_dir',
            default_value=str(ROOT / 'robot_control/motor'),
        ),
        DeclareLaunchArgument(
            'motor_profile',
            default_value='',
        ),
        DeclareLaunchArgument(
            'urdf',
            default_value=str(ROOT / 'ros2/urdf/miranda.urdf'),
        ),
    ]

    component_arguments = [
        DeclareLaunchArgument(name, default_value='true', choices=['true', 'false'])
        for name in ('robot_state', 'controllers', 'panel', 'rviz')
    ]

    return LaunchDescription([
        *robot_arguments,
        *config_arguments,
        *component_arguments,
        OpaqueFunction(function=setup),
    ])
