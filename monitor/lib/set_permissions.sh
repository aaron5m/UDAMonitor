#!/usr/bin/env bash
# lib/set_permissions.sh

set_udamonitor_permissions() {
    local base_dir="$1"
    echo "Setting script permissions..."
    chmod +x "$base_dir/bin/"*.sh
    chmod +x "$base_dir/lib/"*.sh
    echo "Permissions set."
}
