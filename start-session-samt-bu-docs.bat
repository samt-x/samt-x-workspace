@echo off
set WORKDIR=S:\app-data\github\samt-x-repos\samt-bu-docs

start "Hugo Server" cmd /k "cd /d %WORKDIR% && hugo server"
start "Claude" cmd /k "cd /d %WORKDIR% && claude --dangerously-skip-permissions"
