#!/usr/bin/env bash
# Launch ROS-side model, motor controllers, panel and optional RViz.
launcher_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)" || exit 1
source "$launcher_dir/env.sh" || exit 1
exec ros2 launch "$launcher_dir/miranda.launch.py" "$@"
