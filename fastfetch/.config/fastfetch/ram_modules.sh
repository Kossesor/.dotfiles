#!/bin/bash

## SETUP (at the end of sudoers
# sudo visudo
# USERNAME ALL=(ALL) NOPASSWD: /usr/sbin/dmidecode

sudo dmidecode -t memory | awk '
BEGIN {
    module_count = 0;
}
/Memory Device/ {
    in_device = 1;
    size = 0; type = ""; speed = "";
    next;
}
/^\s*$/ {
    if (in_device && size > 0 && type != "" && speed > 0) {
        sizes[size]++;
        types[type]++;
        speeds[speed]++;
        module_count++;
    }
    in_device = 0;
    next;
}
in_device {
    if ($1 == "Size:" && $2 ~ /^[0-9]+$/) size = int($2);
    if ($1 == "Type:" && $2 != "Unknown" && $2 != "Other") type = $2;
    if ($1 == "Speed:" && $2 ~ /^[0-9]+$/) speed = int($2);
}
END {
    size_summary = "";
    for (s in sizes) {
        if (size_summary != "") size_summary = size_summary " + ";
        size_summary = size_summary sizes[s] "x" s "GiB";
    }

    # Print most common type and speed
    max_type = ""; max_count = 0;
    for (t in types) if (types[t] > max_count) { max_type = t; max_count = types[t]; }

    max_speed = 0; max_count = 0;
    for (sp in speeds) if (speeds[sp] > max_count) { max_speed = sp; max_count = speeds[sp]; }

    print "[" max_type " " size_summary " @ " max_speed "MHz]";
}'
