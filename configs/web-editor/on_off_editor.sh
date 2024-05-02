#!/bin/bash

echo "Realizando el switching del panel de control web (on/off)"

pid_editor_process=$(pgrep -f "/opt/AP-soft/configs/web-editor/editor.py")
if [[ $pid_editor_process != "" ]]
then
        echo "El editor está encendido. Lo matamos!"
        /usr/bin/kill -9 $pid_editor_process
else
        echo "El editor está apagado. Lo levantamos!"
        nohup /usr/bin/python3 /opt/AP-soft/configs/web-editor/editor.py &
fi
