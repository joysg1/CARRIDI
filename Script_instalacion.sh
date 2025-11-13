#!/bin/bash

# Script para descargar e instalar cariddi desde GitHub
# https://github.com/edoardottt/cariddi

set -e  # Salir en caso de error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Instalador de cariddi ===${NC}"

# Verificar si Go está instalado
if ! command -v go &> /dev/null; then
    echo -e "${RED}Error: Go no está instalado${NC}"
    echo "Por favor instala Go primero: https://golang.org/dl/"
    exit 1
fi

echo -e "${GREEN}Go está instalado${NC}"

# Crear directorio temporal
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo -e "${YELLOW}Descargando cariddi...${NC}"

# Clonar el repositorio
if git clone https://github.com/edoardottt/cariddi.git 2>/dev/null; then
    echo -e "${GREEN}Repositorio clonado exitosamente${NC}"
else
    echo -e "${RED}Error al clonar el repositorio${NC}"
    exit 1
fi

cd cariddi

echo -e "${YELLOW}Compilando cariddi...${NC}"

# Compilar el proyecto
if go build -o cariddi 2>/dev/null; then
    echo -e "${GREEN}Compilación exitosa${NC}"
else
    echo -e "${RED}Error en la compilación${NC}"
    exit 1
fi

# Mover el binario a un directorio en el PATH
INSTALL_DIR="/usr/local/bin"
if [ -w "$INSTALL_DIR" ]; then
    sudo mv cariddi "$INSTALL_DIR/"
    echo -e "${GREEN}cariddi instalado en $INSTALL_DIR${NC}"
else
    # Si no tenemos permisos, instalar en directorio local
    LOCAL_BIN="$HOME/.local/bin"
    mkdir -p "$LOCAL_BIN"
    mv cariddi "$LOCAL_BIN/"
    echo -e "${GREEN}cariddi instalado en $LOCAL_BIN${NC}"
    echo -e "${YELLOW}Asegúrate de que $LOCAL_BIN está en tu PATH${NC}"
fi

# Limpiar directorio temporal
cd /
rm -rf "$TEMP_DIR"

echo -e "${GREEN}¡Instalación completada!${NC}"
echo ""
echo -e "${YELLOW}Uso básico:${NC}"
echo "  cariddi -h                         # Mostrar ayuda"
echo "  cariddi -u https://ejemplo.com     # Escanear un dominio"
echo "  cariddi -l dominios.txt            # Escanear desde lista"
echo ""
echo -e "${GREEN}¡Listo! Puedes usar cariddi desde cualquier directorio.${NC}"
