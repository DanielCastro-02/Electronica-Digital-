# GUIA DE INSTALACION DE QUARTUS

Para instalar Intel Quartus para poder programar una FPGA tenemos que descargar el programa, la versión de Ubuntu la podemos conseguir del siguiente enlace:

https://www.intel.com/content/www/us/en/software-kit/795187/intel-quartus-prime-lite-edition-design-software-version-23-1-for-linux.html


![alt text](https://github.com/DanielCastro-02/Electronica-Digital-/blob/main/Recursos/Quartus%20Instalacion%201.png?raw=true)


llegaremos a esta pagina, si bajamos un poquito encontraremos un botón azul donde podemos descargar Quartus :

![alt text](https://github.com/DanielCastro-02/Electronica-Digital-/blob/main/Recursos/Quartus%20Instalacion%202.png?raw=true)

Nos debería quedar un archivo así:

![alt text](https://github.com/DanielCastro-02/Electronica-Digital-/blob/main/Recursos/Quartus%20Instalacion%203.png?raw=true)

Damos clic derecho y nos vamos a propiedades

![alt text](https://github.com/DanielCastro-02/Electronica-Digital-/blob/main/Recursos/Quartus%20Instalacion%204.png?raw=true)

Seleccionamos permisos, y marcamos la casilla de "permitir ejecutar el archivo como un programa"

![alt text](https://github.com/DanielCastro-02/Electronica-Digital-/blob/main/Recursos/Quartus%20Instalacion%205.png?raw=true)

Volvemos a dar clic derecho sobre el archivo y seleccionamos "Ejecutar como un programa"
![alt text](https://github.com/DanielCastro-02/Electronica-Digital-/blob/main/Recursos/Quartus%20Instalacion%204.png?raw=true)


Marcamos todas las casillas en la selección blanca y cliqueamos el boton de download, el programa instalara los componentes y instalara automáticamente.

![alt text](https://github.com/DanielCastro-02/Electronica-Digital-/blob/main/Recursos/Quartus%20Instalacion%206.png?raw=true)

Abrimos una terminal ( Un atajo rapido es CTRL + ALT + T ) y escribimos el siguiente comando

```bash
sudo nano .bashrc
```

y nos debería mostrar la consola de esta manera

![alt text](https://github.com/DanielCastro-02/Electronica-Digital-/blob/main/Recursos/Quartus%20Instalacion%207.png?raw=true)

nos vamos a la ultima parte de la consola y comentamos la linea que dice

```
export QSYS_ROOTDIR="/home/santiago/intelFPGA_lite/23.1std/quartus/sopc_builder/bin"

```
con un  # quedaría

```
#export QSYS_ROOTDIR="/home/santiago/intelFPGA_lite/23.1std/quartus/sopc_builder/bin"

```

abajo pegamos y cambiamos de la primera linea 

```
export ALTERAPATH="/home/user*/intelFPGA_lite/23.1std/"
export QUARTUS_ROOTDIR=${ALTERAPATH}/quartus
export QUARTUS_ROOTDIR_OVERRIDE="$QUARTUS_ROOTDIR"
export PATH=$PATH:${ALTERAPATH}/quartus/sopc_builder/bin
export PATH=$PATH:${ALTERAPATH}/nios2eds/bin
export PATH=$PATH:${QSYS_ROOTDIR}
```
y cambiamos de la primera linea el (user*) por el nombre de nuestro usuario de linux, por ejemplo en mi caso seria:

```
export ALTERAPATH="/home/user*/intelFPGA_lite/23.1std/"

por

export ALTERAPATH="/home/santiago/intelFPGA_lite/23.1std/"

```

Hacemos CTRL + O y enter para guardar y luego CTRL + C

ejecutamos el siguiente comando 
```
sudo ln -s $QUARTUS_ROOTDIR/bin/quartus /bin/quartus
```
y si escribimos 
```
quartus
```
en la terminal debería abrirnos quartus, en el caso de que no abra ejecutamos
```
rm bin/quartus
```
y volvemos a ejecutar
```
sudo ln -s $QUARTUS_ROOTDIR/bin/quartus /bin/quartus
```
y ahora si nos deberia abrir Quartus con el comando
```
quartus
```
