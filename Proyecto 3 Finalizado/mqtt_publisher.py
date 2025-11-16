#!/usr/bin/env python3
"""
mqtt_publisher.py - Publicador MQTT
Proyecto #3 Dashboard Ambiental - INFO1128
"""

import json
import random
import time
import paho.mqtt.client as mqtt
from datetime import datetime
import sys

# Configuración MQTT
MQTT_BROKER = "localhost"
MQTT_PORT = 1883
MQTT_TOPIC = "sensores"
MQTT_USERNAME = "publisher"
MQTT_PASSWORD = "pub123"

# Intervalo de envío (segundos)
INTERVALO = 5

# Rangos de sensores
RANGOS = {
    'temperatura': (15.0, 35.0),
    'humedad': (30.0, 90.0),
    'presion': (950.0, 1050.0),
    'calidad_aire': (0, 500),
    'luminosidad': (0, 1000),
    'co2': (400, 2000)
}

def on_connect(client, userdata, flags, rc):
    """Callback cuando se conecta al broker"""
    if rc == 0:
        print("✓ Conectado al Broker MQTT")
    else:
        print(f"✗ Error de conexión. Código: {rc}")
        sys.exit(1)

def on_publish(client, userdata, mid):
    """Callback cuando se publica un mensaje"""
    pass

def generar_datos_json():
    """Genera datos aleatorios de sensores"""
    return {
        "timestamp": datetime.now().isoformat(),
        "temperatura": round(random.uniform(*RANGOS['temperatura']), 2),
        "humedad": round(random.uniform(*RANGOS['humedad']), 2),
        "presion": round(random.uniform(*RANGOS['presion']), 2),
        "calidad_aire": round(random.uniform(*RANGOS['calidad_aire']), 2),
        "luminosidad": round(random.uniform(*RANGOS['luminosidad']), 2),
        "co2": round(random.uniform(*RANGOS['co2']), 2)
    }

def main():
    """Función principal"""
    print("╔════════════════════════════════════════════════════════╗")
    print("║          MQTT PUBLISHER - Dashboard Ambiental          ║")
    print("╚════════════════════════════════════════════════════════╝")
    print()
    
    client = mqtt.Client(client_id="python_publisher")
    client.username_pw_set(MQTT_USERNAME, MQTT_PASSWORD)
    client.on_connect = on_connect
    client.on_publish = on_publish
    
    try:
        print(f"Conectando a {MQTT_BROKER}:{MQTT_PORT}...")
        client.connect(MQTT_BROKER, MQTT_PORT, 60)
        client.loop_start()
        
        print("Presiona Ctrl+C para detener\n")
        
        contador = 0
        while True:
            contador += 1
            datos = generar_datos_json()
            mensaje = json.dumps(datos)
            
            result = client.publish(MQTT_TOPIC, mensaje, qos=1)
            
            print(f"\n📤 Envío #{contador} - {datos['timestamp']}")
            print(f"  🌡️  Temperatura:  {datos['temperatura']:>7.2f}°C")
            print(f"  💧 Humedad:      {datos['humedad']:>7.2f}%")
            print(f"  🔽 Presión:      {datos['presion']:>7.2f} hPa")
            print(f"  🏭 Cal. Aire:    {datos['calidad_aire']:>7.2f} AQI")
            print(f"  💡 Luminosidad:  {datos['luminosidad']:>7.2f} lux")
            print(f"  🌫️  CO2:          {datos['co2']:>7.2f} ppm")
            print(f"  ✓ Publicado en tópico '{MQTT_TOPIC}'")
            
            time.sleep(INTERVALO)
            
    except KeyboardInterrupt:
        print("\n\nDeteniendo publicador...")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        client.loop_stop()
        client.disconnect()
        print("Desconectado del broker\n")

if __name__ == "__main__":
    main()