Inside `warthog_ws`, make a `src` directory and clone these repositories below.
```bash
git clone https://github.com/warthog-cpr/warthog.git
git clone https://github.com/warthog-cpr/warthog_simulator.git
git clone https://github.com/warthog-cpr/warthog_desktop.git
rosdep install --from-paths src --ignore-src --rosdistro=noetic -y
```

Launch Gazebo.
```bash
roslaunch warthog_gazebo warthog_world.launch
```