#!/bin/bash

# coverage_check.sh
# Script para verificar y mostrar la cobertura de pruebas

# Configuración
COVERAGE_THRESHOLD=80  # Porcentaje mínimo de cobertura aceptable
LCOV_FILE="../coverage/lcov_filtered.info"

# Verificar si el archivo de cobertura existe
if [ ! -f "$LCOV_FILE" ]; then
  echo "❌ Error: Archivo de cobertura no encontrado: $LCOV_FILE"
  exit 1
fi

# Generar informe HTML
echo "📊 Generando informe de cobertura..."
genhtml "$LCOV_FILE" -o ../coverage/html

# Obtener porcentaje de cobertura
COVERAGE_PERCENTAGE=$(lcov --summary "$LCOV_FILE" 2>/dev/null | grep lines | awk '{print $2}' | sed 's/%//')

echo "----------------------------------------"
echo "📈 Cobertura de pruebas: $COVERAGE_PERCENTAGE%"
echo "🔰 Mínimo requerido: $COVERAGE_THRESHOLD%"
echo "----------------------------------------"

# Verificar si se alcanza el mínimo requerido
if (( $(echo "$COVERAGE_PERCENTAGE < $COVERAGE_THRESHOLD" | bc -l) )); then
  echo "❌ La cobertura de pruebas ($COVERAGE_PERCENTAGE%) es menor que el mínimo requerido ($COVERAGE_THRESHOLD%)"
  exit 1
else
  echo "✅ Cobertura de pruebas satisfactoria ($COVERAGE_PERCENTAGE%)"
fi

# Abrir informe en navegador (opcional)
if which xdg-open > /dev/null; then
  xdg-open ../coverage/html/index.html
elif which open > /dev/null; then
  open ../coverage/html/index.html
fi

exit 0