@echo off
chcp 65001 >nul
cls

echo ╔════════════════════════════════════════════════════════╗
echo ║   CREACIÓN AUTOMÁTICA - Dashboard Ambiental           ║
echo ║              INFO1128 - Proyecto #3                    ║
echo ╚════════════════════════════════════════════════════════╝
echo.

REM Crear directorios
echo 📁 Creando estructura de directorios...
if not exist config mkdir config
if not exist logs mkdir logs
if not exist screenshots mkdir screenshots
if not exist docs mkdir docs
echo ✓ Directorios creados
echo.

REM Crear mqtt_publisher.py
echo 📝 Creando mqtt_publisher.py...
(
echo #!/usr/bin/env python3
echo """
echo mqtt_publisher.py - Publicador MQTT
echo Proyecto #3 Dashboard Ambiental - INFO1128
echo """
echo.
echo import json
echo import random
echo import time
echo import paho.mqtt.client as mqtt
echo from datetime import datetime
echo import sys
echo import os
echo.
echo # Configuración MQTT
echo MQTT_BROKER = "localhost"
echo MQTT_PORT = 1883
echo MQTT_TOPIC = "sensores"
echo MQTT_USERNAME = "publisher"
echo MQTT_PASSWORD = "pub123"
echo.
echo # Intervalo de envío
echo INTERVALO = 5
echo.
echo # Rangos de sensores
echo RANGOS = {
echo     'temperatura': ^(15.0, 35.0^),
echo     'humedad': ^(30.0, 90.0^),
echo     'presion': ^(950.0, 1050.0^),
echo     'calidad_aire': ^(0, 500^),
echo     'luminosidad': ^(0, 1000^),
echo     'co2': ^(400, 2000^)
echo }
echo.
echo def on_connect^(client, userdata, flags, rc^):
echo     if rc == 0:
echo         print^("✓ Conectado al Broker MQTT"^)
echo     else:
echo         print^(f"✗ Error de conexión. Código: {rc}"^)
echo         sys.exit^(1^)
echo.
echo def on_publish^(client, userdata, mid^):
echo     pass
echo.
echo def generar_datos_json^(^):
echo     return {
echo         "timestamp": datetime.now^(^).isoformat^(^),
echo         "temperatura": round^(random.uniform^(*RANGOS['temperatura']^), 2^),
echo         "humedad": round^(random.uniform^(*RANGOS['humedad']^), 2^),
echo         "presion": round^(random.uniform^(*RANGOS['presion']^), 2^),
echo         "calidad_aire": round^(random.uniform^(*RANGOS['calidad_aire']^), 2^),
echo         "luminosidad": round^(random.uniform^(*RANGOS['luminosidad']^), 2^),
echo         "co2": round^(random.uniform^(*RANGOS['co2']^), 2^)
echo     }
echo.
echo def main^(^):
echo     print^("╔════════════════════════════════════════════════════════╗"^)
echo     print^("║          MQTT PUBLISHER - Dashboard Ambiental          ║"^)
echo     print^("╚════════════════════════════════════════════════════════╝"^)
echo     
echo     client = mqtt.Client^(client_id="python_publisher"^)
echo     client.username_pw_set^(MQTT_USERNAME, MQTT_PASSWORD^)
echo     client.on_connect = on_connect
echo     client.on_publish = on_publish
echo     
echo     try:
echo         print^(f"Conectando a {MQTT_BROKER}:{MQTT_PORT}..."^)
echo         client.connect^(MQTT_BROKER, MQTT_PORT, 60^)
echo         client.loop_start^(^)
echo         
echo         print^("Presiona Ctrl+C para detener\n"^)
echo         
echo         contador = 0
echo         while True:
echo             contador += 1
echo             datos = generar_datos_json^(^)
echo             mensaje = json.dumps^(datos^)
echo             
echo             result = client.publish^(MQTT_TOPIC, mensaje, qos=1^)
echo             
echo             print^(f"\n📤 Envío #{contador} - {datos['timestamp']}"^)
echo             print^(f"  🌡️  Temperatura:  {datos['temperatura']:^>7.2f}°C"^)
echo             print^(f"  💧 Humedad:      {datos['humedad']:^>7.2f}%%"^)
echo             print^(f"  🔽 Presión:      {datos['presion']:^>7.2f} hPa"^)
echo             print^(f"  🏭 Cal. Aire:    {datos['calidad_aire']:^>7.2f} AQI"^)
echo             print^(f"  💡 Luminosidad:  {datos['luminosidad']:^>7.2f} lux"^)
echo             print^(f"  🌫️  CO2:          {datos['co2']:^>7.2f} ppm"^)
echo             print^(f"  ✓ Publicado en tópico '{MQTT_TOPIC}'"^)
echo             
echo             time.sleep^(INTERVALO^)
echo             
echo     except KeyboardInterrupt:
echo         print^("\n\nDeteniendo publicador..."^)
echo     except Exception as e:
echo         print^(f"Error: {e}"^)
echo     finally:
echo         client.loop_stop^(^)
echo         client.disconnect^(^)
echo         print^("Desconectado del broker\n"^)
echo.
echo if __name__ == "__main__":
echo     main^(^)
) > mqtt_publisher.py
echo ✓ mqtt_publisher.py creado
echo.

REM Crear mqtt_subscriber.py
echo 📝 Creando mqtt_subscriber.py...
(
echo #!/usr/bin/env python3
echo """
echo mqtt_subscriber.py - Suscriptor MQTT
echo Proyecto #3 Dashboard Ambiental - INFO1128
echo """
echo.
echo import json
echo import paho.mqtt.client as mqtt
echo import requests
echo import sys
echo.
echo # Configuración MQTT
echo MQTT_BROKER = "localhost"
echo MQTT_PORT = 1883
echo MQTT_TOPIC = "sensores"
echo MQTT_USERNAME = "subscriber"
echo MQTT_PASSWORD = "sub123"
echo.
echo # Configuración Node-RED
echo NODERED_URL = "http://localhost:1880/sensores-mqtt"
echo.
echo def on_connect^(client, userdata, flags, rc^):
echo     if rc == 0:
echo         print^("✓ Conectado al Broker MQTT"^)
echo         client.subscribe^(MQTT_TOPIC^)
echo         print^(f"✓ Suscrito al tópico: '{MQTT_TOPIC}'"^)
echo     else:
echo         print^(f"✗ Error de conexión. Código: {rc}"^)
echo.
echo def on_message^(client, userdata, msg^):
echo     try:
echo         datos = json.loads^(msg.payload.decode^(^)^)
echo         
echo         print^(f"\n📥 Mensaje recibido:"^)
echo         print^(f"  Timestamp:     {datos.get^('timestamp', 'N/A'^)}"^)
echo         print^(f"  Temperatura:   {datos.get^('temperatura', 'N/A'^)}°C"^)
echo         print^(f"  Humedad:       {datos.get^('humedad', 'N/A'^)}%%"^)
echo         print^(f"  Presión:       {datos.get^('presion', 'N/A'^)} hPa"^)
echo         print^(f"  Cal. Aire:     {datos.get^('calidad_aire', 'N/A'^)} AQI"^)
echo         print^(f"  Luminosidad:   {datos.get^('luminosidad', 'N/A'^)} lux"^)
echo         print^(f"  CO2:           {datos.get^('co2', 'N/A'^)} ppm"^)
echo         
echo         # Reenviar a Node-RED
echo         try:
echo             response = requests.post^(NODERED_URL, json=datos, timeout=3^)
echo             if response.status_code == 200:
echo                 print^("  ✓ Reenviado a Node-RED"^)
echo             else:
echo                 print^(f"  ⚠ Node-RED: {response.status_code}"^)
echo         except:
echo             print^("  ✗ Error al reenviar a Node-RED"^)
echo             
echo     except Exception as e:
echo         print^(f"Error: {e}"^)
echo.
echo def main^(^):
echo     print^("╔════════════════════════════════════════════════════════╗"^)
echo     print^("║         MQTT SUBSCRIBER - Dashboard Ambiental          ║"^)
echo     print^("╚════════════════════════════════════════════════════════╝"^)
echo     
echo     client = mqtt.Client^(client_id="python_subscriber"^)
echo     client.username_pw_set^(MQTT_USERNAME, MQTT_PASSWORD^)
echo     client.on_connect = on_connect
echo     client.on_message = on_message
echo     
echo     try:
echo         print^(f"Conectando a {MQTT_BROKER}:{MQTT_PORT}..."^)
echo         client.connect^(MQTT_BROKER, MQTT_PORT, 60^)
echo         
echo         print^("Presiona Ctrl+C para detener\n"^)
echo         client.loop_forever^(^)
echo         
echo     except KeyboardInterrupt:
echo         print^("\n\nDeteniendo suscriptor..."^)
echo     except Exception as e:
echo         print^(f"Error: {e}"^)
echo     finally:
echo         client.disconnect^(^)
echo         print^("Desconectado del broker\n"^)
echo.
echo if __name__ == "__main__":
echo     main^(^)
) > mqtt_subscriber.py
echo ✓ mqtt_subscriber.py creado
echo.

REM Crear requirements.txt
echo 📝 Creando requirements.txt...
(
echo paho-mqtt==1.6.1
echo requests==2.31.0
) > requirements.txt
echo ✓ requirements.txt creado
echo.

REM Crear README.md
echo 📝 Creando README.md...
(
echo # Dashboard Ambiental - INFO1128
echo ## Proyecto #3 Interfaces Gráficas
echo.
echo ### Descripción
echo Sistema de monitoreo ambiental en tiempo real con Python, Node-RED, Grafana y MQTT.
echo.
echo ### Archivos del Proyecto
echo - `JSON.py` - HTTP POST a Node-RED y Grafana
echo - `mqtt_publisher.py` - Publicador MQTT
echo - `mqtt_subscriber.py` - Suscriptor MQTT
echo.
echo ### Instalación
echo ```bash
echo pip install -r requirements.txt
echo ```
echo.
echo ### Ejecución
echo ```bash
echo # Terminal 1
echo python mqtt_publisher.py
echo.
echo # Terminal 2
echo python mqtt_subscriber.py
echo.
echo # Terminal 3
echo python JSON.py
echo ```
echo.
echo ### URLs
echo - Node-RED: http://localhost:1880
echo - Grafana: http://localhost:3000
) > README.md
echo ✓ README.md creado
echo.

REM Crear .gitignore
echo 📝 Creando .gitignore...
(
echo __pycache__/
echo *.pyc
echo *.log
echo logs/*.log
echo .vscode/
echo .idea/
echo *.swp
) > .gitignore
echo ✓ .gitignore creado
echo.

echo ╔════════════════════════════════════════════════════════╗
echo ║              ✅ PROYECTO CREADO EXITOSAMENTE           ║
echo ╚════════════════════════════════════════════════════════╝
echo.
echo Archivos creados:
echo   ✓ mqtt_publisher.py
echo   ✓ mqtt_subscriber.py
echo   ✓ requirements.txt
echo   ✓ README.md
echo   ✓ .gitignore
echo.
echo Directorios creados:
echo   ✓ config/
echo   ✓ logs/
echo   ✓ screenshots/
echo   ✓ docs/
echo.
echo Próximos pasos:
echo   1. Instalar dependencias: pip install -r requirements.txt
echo   2. Configurar Mosquitto
echo   3. Iniciar Node-RED: node-red
echo   4. Ejecutar los scripts Python
echo.
echo Para ejecutar:
echo   Terminal 1: python mqtt_publisher.py
echo   Terminal 2: python mqtt_subscriber.py
echo   Terminal 3: python JSON.py
echo.
pause