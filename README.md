# ASUS TTPN

ASUS Throttle thermal policy notifier

Script personal que mientras esté en ejecución monitorea los cambios del perfil de energía/ventiladores de mi Notebook. Si detecta cambios lanza una notificación indicando el perfil actual.

Esto sólo lo he probado con mi Notebook ASUS TUF FX505DY, por lo que desconozco si será compatible con otros modelos.

## Dependencias

|Paquete|Descripción|
|-|-|
|inotify-tools|Sirve para monitorear los cambios de archivos especificos|
|libnotify-bin|Se usa para lanzar las notificaciones|

```bash
sudo pacman -S inotify-tools libnotify
```

## Clonación y configuración

Clonar repositorio

```bash
git clone https://github.com/jp10z/asus-ttpn
```

Agregar permiso de ejecución al script

```bash
chmod +x ./asus-ttpn/monitor.sh
```

Crear un servicio para que se ejecute al iniciar el sistema y en segundo plano

```bash
sudo vim /etc/systemd/system/asus-ttpn.service
```

Configuración del servicio (contenido del archivo anterior), hay que definir lo siguiente:

- ExecStart: La ruta del script monitor.sh
- User: El usuario actual (no root)
- Environment: Modificar PID (1000) del usuario en caso de ser otro en ambas configuraciones

```
[Unit]
Description=ASUS TTPN
After=network.target

[Service]
ExecStart=/path/to/asus-ttpn/monitor.sh
Restart=always
User=username
Environment=DISPLAY=:0
Environment=XAUTHORITY=/run/user/1000/.Xauthority
Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=asus-ttpn

[Install]
WantedBy=multi-user.target
```

Recargar systemd

```bash
sudo systemctl daemon-reload
```

Habilitar servicio

```bash
sudo systemctl enable asus-ttpn.service
```

Iniciar servicio

```bash
sudo systemctl start asus-ttpn.service
```

# Configuraciones adicionales

Adicionalmente, se puede modificar el tiempo en que la notificación permanecerá visible, para ello dentro del script `monitor.sh` modifique el valor de la variable `timeout` por el tiempo en milisegundos que se desea.