#!/usr/bin/env fish
#
function hw_stats
  echo "Fan speeds. Min and Max"
  cat /sys/devices/platform/applesmc.768/fan*_min
  cat /sys/devices/platform/applesmc.768/fan*_max

  echo "Temperature"
  cat /sys/devices/platform/coretemp.*/hwmon/hwmon*/temp*_max
end
