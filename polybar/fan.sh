#!/bin/bash

echo "  `sensors | grep cpu_fan | awk '{print $2}'` RPM"
