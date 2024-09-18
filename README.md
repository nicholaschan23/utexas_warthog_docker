Add this line at the end of `warthog_ws/src/clearpath/warthog/warthog_description/urdf/warthog.urdf.xacro` before `<robot>`. This adds the lidars to the URDF model.
<xacro:include filename="$(find utexas_warthog_simulator)/urdf/ouster.urdf.xacro" />

Launch the simulation with the alias:
```bash
runsim
```

