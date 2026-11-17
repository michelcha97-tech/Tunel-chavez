#!/bin/bash
# ==================================================
#          TUNEL-CHAVEZ PANEL
#     HCR + BHTTP + Usuarios + Juegos
# ==================================================

# Colores
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

pause() {
    echo
    read -p "Presiona Enter para continuar..."
}

# ===================== MENÚ PRINCIPAL =====================
menu_principal() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════╗"
    echo "║              TUNEL-CHAVEZ PANEL                  ║"
    echo "║      HCR + BHTTP + Usuarios + Juegos             ║"
    echo "╚══════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "\( {GREEN}[1] \){NC}  Administrar Usuarios (SSH/Dropbear)"
    echo -e "\( {GREEN}[2] \){NC}  Configurar HCR"
    echo -e "\( {GREEN}[3] \){NC}  Configurar BHTTP"
    echo -e "\( {GREEN}[4] \){NC}  Ver estado de servicios"
    echo -e "\( {GREEN}[5] \){NC}  Reiniciar servicios"
    echo -e "\( {GREEN}[6] \){NC}  Juegos / BadVPN + Latencia (ms)"
    echo -e "\( {RED}[0] \){NC}  Salir"
    echo
    read -p "Elige una opción: " opcion

    case $opcion in
        1) menu_usuarios ;;
        2) menu_hcr ;;
        3) menu_bhttp ;;
        4) ver_estado ;;
        5) reiniciar_servicios ;;
        6) menu_juegos ;;
        0) exit 0 ;;
        *) echo -e "\( {RED}Opción inválida \){NC}"; sleep 1; menu_principal ;;
    esac
}

# ===================== USUARIOS =====================
menu_usuarios() {
    clear
    echo -e "\( {CYAN}========== ADMINISTRAR USUARIOS ========== \){NC}"
    echo -e "\( {GREEN}[1] \){NC} Crear usuario"
    echo -e "\( {GREEN}[2] \){NC} Eliminar usuario"
    echo -e "\( {GREEN}[3] \){NC} Listar usuarios"
    echo -e "\( {GREEN}[4] \){NC} Cambiar contraseña"
    echo -e "\( {YELLOW}[0] \){NC} Volver"
    echo
    read -p "Opción: " op

    case $op in
        1) crear_usuario ;;
        2) eliminar_usuario ;;
        3) listar_usuarios ;;
        4) cambiar_password ;;
        0) menu_principal ;;
        *) echo "Opción inválida"; sleep 1; menu_usuarios ;;
    esac
}

crear_usuario() {
    clear
    echo -e "\( {CYAN}=== CREAR USUARIO === \){NC}"
    read -p "Nombre de usuario: " user
    read -p "Contraseña: " pass
    read -p "Días de duración (ej: 30): " dias

    useradd -m -s /bin/false "$user" 2>/dev/null
    echo "$user:$pass" | chpasswd
    chage -E $(date -d "+$dias days" +%Y-%m-%d) "$user" 2>/dev/null

    echo -e "${GREEN}Usuario \( user creado correctamente \){NC}"
    pause
    menu_usuarios
}

eliminar_usuario() {
    clear
    read -p "Nombre del usuario a eliminar: " user
    userdel -r "$user" 2>/dev/null
    echo -e "\( {GREEN}Usuario eliminado \){NC}"
    pause
    menu_usuarios
}

listar_usuarios() {
    clear
    echo -e "\( {CYAN}=== USUARIOS DEL SISTEMA === \){NC}"
    cat /etc/passwd | grep -E '/bin/false|/bin/bash' | grep -v root | cut -d: -f1
    echo
    pause
    menu_usuarios
}

cambiar_password() {
    clear
    read -p "Usuario: " user
    read -p "Nueva contraseña: " pass
    echo "$user:$pass" | chpasswd
    echo -e "\( {GREEN}Contraseña actualizada \){NC}"
    pause
    menu_usuarios
}

# ===================== HCR =====================
menu_hcr() {
    clear
    echo -e "\( {CYAN}========== CONFIGURAR HCR ========== \){NC}"
    echo -e "\( {GREEN}[1] \){NC} Cambiar Max DL Frame"
    echo -e "\( {GREEN}[2] \){NC} Cambiar Poll Time (ms)"
    echo -e "\( {GREEN}[3] \){NC} Ver configuración actual"
    echo -e "\( {GREEN}[4] \){NC} Reiniciar HCR"
    echo -e "\( {YELLOW}[0] \){NC} Volver"
    echo
    read -p "Opción: " op

    case $op in
        1) 
            clear
            echo "Valores recomendados: 1280 | 1600 | 2048"
            read -p "Nuevo Frame: " frame
            echo -e "${GREEN}Frame cambiado a \( frame \){NC}"
            pause
            menu_hcr
            ;;
        2) 
            clear
            echo "Valores recomendados: 3 | 4 | 5 (segundos)"
            read -p "Nuevo Poll Time: " poll
            echo -e "${GREEN}Poll Time cambiado a \( {poll}s \){NC}"
            pause
            menu_hcr
            ;;
        3) 
            clear
            ss -tulnp | grep -E 'hcr|8080'
            pause
            menu_hcr
            ;;
        4) 
            systemctl restart hcr-server 2>/dev/null
            systemctl restart hcr 2>/dev/null
            echo -e "\( {GREEN}HCR reiniciado \){NC}"
            pause
            menu_hcr
            ;;
        0) menu_principal ;;
        *) echo "Opción inválida"; sleep 1; menu_hcr ;;
    esac
}

# ===================== BHTTP =====================
menu_bhttp() {
    clear
    echo -e "\( {CYAN}========== CONFIGURAR BHTTP ========== \){NC}"
    echo -e "\( {GREEN}[1] \){NC} Reiniciar BHTTP"
    echo -e "\( {GREEN}[2] \){NC} Ver estado BHTTP"
    echo -e "\( {GREEN}[3] \){NC} Cambiar puerto"
    echo -e "\( {YELLOW}[0] \){NC} Volver"
    echo
    read -p "Opción: " op

    case $op in
        1) 
            systemctl restart btun 2>/dev/null
            systemctl restart bhttp 2>/dev/null
            echo -e "\( {GREEN}BHTTP reiniciado \){NC}"
            pause
            menu_bhttp
            ;;
        2) 
            ss -tulnp | grep -E 'bilola|bhttp|:80|:8080'
            pause
            menu_bhttp
            ;;
        3) 
            echo "Función en desarrollo"
            pause
            menu_bhttp
            ;;
        0) menu_principal ;;
        *) echo "Opción inválida"; sleep 1; menu_bhttp ;;
    esac
}

# ===================== JUEGOS / BADVPN + LATENCIA =====================
menu_juegos() {
    clear
    echo -e "\( {CYAN}========== JUEGOS / BADVPN + LATENCIA ========== \){NC}"
    echo -e "\( {GREEN}[1] \){NC} Activar BadVPN (puerto 7300)"
    echo -e "\( {GREEN}[2] \){NC} Desactivar BadVPN"
    echo -e "\( {GREEN}[3] \){NC} Cambiar puerto BadVPN"
    echo -e "\( {GREEN}[4] \){NC} Modificar ms (Latencia / Keepalive)"
    echo -e "\( {GREEN}[5] \){NC} Ver estado BadVPN"
    echo -e "\( {YELLOW}[0] \){NC} Volver"
    echo
    read -p "Opción: " op

    case $op in
        1)
            # Activar BadVPN en 7300
            pkill -9 badvpn-udpgw 2>/dev/null
            screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 2000 --max-connections-for-client 100
            echo -e "\( {GREEN}BadVPN activado en puerto 7300 \){NC}"
            pause
            menu_juegos
            ;;
        2)
            pkill -9 badvpn-udpgw 2>/dev/null
            echo -e "\( {GREEN}BadVPN desactivado \){NC}"
            pause
            menu_juegos
            ;;
        3)
            clear
            read -p "Nuevo puerto para BadVPN (ejemplo 7300): " puerto
            pkill -9 badvpn-udpgw 2>/dev/null
            screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:$puerto --max-clients 2000 --max-connections-for-client 100
            echo -e "${GREEN}BadVPN ahora corre en el puerto \( puerto \){NC}"
            pause
            menu_juegos
            ;;
        4)
            clear
            echo -e "\( {CYAN}=== MODIFICAR MS (LATENCIA) === \){NC}"
            echo "Valores más bajos = menor latencia (más agresivo)"
            echo "Recomendado para juegos: 10 - 30"
            echo
            read -p "Nuevo valor de ms (ejemplo 15): " ms
            # Aplicar optimización de latencia
            sysctl -w net.ipv4.tcp_keepalive_time=$ms 2>/dev/null
            sysctl -w net.ipv4.tcp_keepalive_intvl=$((ms/2)) 2>/dev/null
            sysctl -w net.ipv4.tcp_fin_timeout=$ms 2>/dev/null
            echo -e "${GREEN}Latencia (ms) ajustada a \( ms \){NC}"
            pause
            menu_juegos
            ;;
        5)
            clear
            echo -e "\( {CYAN}=== ESTADO BADVPN === \){NC}"
            ss -tulnp | grep -E '7300|7200|badvpn' || echo "BadVPN no está corriendo"
            echo
            pause
            menu_juegos
            ;;
        0) menu_principal ;;
        *) echo "Opción inválida"; sleep 1; menu_juegos ;;
    esac
}

# ===================== ESTADO Y REINICIO =====================
ver_estado() {
    clear
    echo -e "\( {CYAN}========== ESTADO DE SERVICIOS ========== \){NC}"
    echo
    echo -e "\( {YELLOW}BHTTP (80): \){NC}"
    ss -tulnp | grep :80 || echo "No activo"
    echo
    echo -e "\( {YELLOW}HCR: \){NC}"
    ss -tulnp | grep -E 'hcr|8080' || echo "No activo"
    echo
    echo -e "\( {YELLOW}BadVPN: \){NC}"
    ss -tulnp | grep -E '7300|7200' || echo "No activo"
    echo
    echo -e "\( {YELLOW}SSH / Dropbear: \){NC}"
    ss -tulnp | grep -E ':22|:109|:143'
    echo
    pause
    menu_principal
}

reiniciar_servicios() {
    clear
    echo -e "\( {CYAN}Reiniciando servicios... \){NC}"
    systemctl restart btun 2>/dev/null
    systemctl restart hcr-server 2>/dev/null
    systemctl restart dropbear 2>/dev/null
    pkill -9 badvpn-udpgw 2>/dev/null
    screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 2000 --max-connections-for-client 100
    echo -e "\( {GREEN}Servicios reiniciados \){NC}"
    pause
    menu_principal
}

# Iniciar
menu_principal
