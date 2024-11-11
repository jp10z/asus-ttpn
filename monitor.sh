#!/bin/bash

# Ruta del archivo a monitorear
file_path="/sys/devices/platform/asus-nb-wmi/throttle_thermal_policy"

# Timeout en milisegundos para las notificaciones
timeout=200

# Monitorea el archivo con inotifywait, esperando cambios (modify)
inotifywait -m -e modify "$file_path" | while read -r directorio evento archivo_modificado
do
    # Verificar el contenido del archivo
    value=$(cat "$file_path")
    
    # Dependiendo del valor, lanzar una notificación
    case "$value" in
        0)
            notify-send -t $timeout "Balanceado"
            ;;
        1)
            notify-send -t $timeout "Full"
            ;;
        2)
            notify-send -t $timeout "Silencio"
            ;;
        *)
            notify-send -t $timeout "Perfil con Valor desconocido: $value."
            ;;
    esac
done