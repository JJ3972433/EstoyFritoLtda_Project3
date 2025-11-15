import numpy as np
import json

dUMA = {
    'te' : float(np.random.normal(20, 2, 1)),     # Temperatura
    'hr' : float(np.random.normal(70, 2, 1)),     # Humedad aire
    'pa' : float(np.random.normal(900, 10, 1)),   # Presión atmosférica

    'p01': float(np.random.normal(20, 2, 1)),     # MP 1.0 ug/m3
    'p25': float(np.random.normal(30, 2, 1)),     # MP 2.5 ug/m3
    'p10': float(np.random.normal(30, 2, 1)),     # MP 10 ug/m3

    'h03': float(np.random.normal(1000, 10, 1)),  # Histograma MP 0.3 um
    'h05': float(np.random.normal(1000, 10, 1)),  # Histograma MP 0.5 um
    'h01': float(np.random.normal(1000, 10, 1)),  # Histograma MP 1.0 um
    'h25': float(np.random.normal(1000, 10, 1)),  # Histograma MP 2.5 um
    'h50': float(np.random.normal(1000, 10, 1)),  # Histograma MP 5.0 um
    'h10': float(np.random.normal(1000, 10, 1)),  # Histograma MP 10 um
}

json_output = json.dumps(dUMA, indent=4)
print(json_output)
