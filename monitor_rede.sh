#!/bin/bash

# Caminho para o arquivo de log
LOG_FILE="/home/jude/Documents/CODES/MeusBashs/speedtest_log.csv"

# Verifica se o arquivo existe e cria o cabeçalho se necessário
if [ ! -f "$LOG_FILE" ]; then
    echo "data,hora,server_id,sponsor,name,timestamp,distance,ping,download,upload,share,ip,ping_ms,download_MBs,upload_MBs" > "$LOG_FILE"
fi

# Captura data e hora
DATA=$(date +%Y-%m-%d)
HORA=$(date +%H:%M:%S)

# Roda o speedtest e extrai apenas as colunas necessárias (Ping, Download, Upload)
# O speedtest-cli --csv retorna: ID,Sponsor,ServerName,Timestamp,Distance,Ping,Download,Upload...
RESULTADO_RAW=$(speedtest-cli --csv --bytes --secure)

# Extrair valores usando o 'cut' (Colunas 6, 7 e 8)
PING_RAW=$(echo $RESULTADO_RAW | cut -d',' -f6)
DOWN_RAW=$(echo $RESULTADO_RAW | cut -d',' -f7)
UP_RAW=$(echo $RESULTADO_RAW | cut -d',' -f8)

# Conversões:
# Download/Upload: bits para MB (divide por 8.000.000)
# Ping: geralmente já vem em ms, mas garantimos 2 casas decimais
PING=$(echo "scale=2; $PING_RAW / 1" | bc)
DOWNLOAD=$(echo "scale=2; $DOWN_RAW / 1000000" | bc)
UPLOAD=$(echo "scale=2; $UP_RAW / 1000000" | bc)

# Salva no arquivo
echo "$DATA,$HORA,$RESULTADO_RAW,$PING,$DOWNLOAD,$UPLOAD" >> "$LOG_FILE"