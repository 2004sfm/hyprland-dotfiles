# ==============================================================================
# UWSM Launch Logic
# ==============================================================================
# The traditional launch script:
#
#   if uwsm check may-start && uwsm select; then
#       exec uwsm start default
#   fi
#
# ...is NOT needed here anymore.
#
# This system uses TLMD (Terminal Login Manager Daemon) which natively
# handles the entire UWSM check, compositor selection, and launch process
# at the systemd level, right after authentication and before the shell loads.
#
# This keeps our shell profiles perfectly clean and avoids hacky launch scripts!
#
# Get TLMD here: https://github.com/2004sfm/tlmd
