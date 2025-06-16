#!/bin/bash

read -p 'Número do container: ' ID
read -sp 'Informe sua senha: ' SENHA
echo ""
read -p 'Caminho completo do CSV (ex: /home/usuario/PLANILHAO.csv): ' CAMINHO

mysql -u"CONTAINER0$ID" -p"$SENHA" -h "192.168.102.100" "BD0$ID" --local-infile=1 <<EOF

LOAD DATA LOCAL INFILE '$CAMINHO'
INTO TABLE aulas_raw
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

EOF
