Para instalar Intel Quartus para poder programar una FPGA tenemos que descargar el programa, la versión de Ubuntu la podemos conseguir del siguiente enlace:

https://www.intel.com/content/www/us/en/software-kit/795187/intel-quartus-prime-lite-edition-design-software-version-23-1-for-linux.html

![[Quartus Instalacion 1.png]]

llegaremos a esta pagina, si bajamos un poquito encontraremos un botón azul donde podemos descargar Quartus :

![[Quartus Instalacion 2.png]]

Nos debería quedar un archivo así:

![[Quartus Instalacion 3.png]]
Damos clic derecho y nos vamos a propiedades

![[Digital/Recursos/Quartus Instalacion 4.png]]
Seleccionamos permisos, y marcamos la casilla de "permitir ejecutar el archivo como un programa"
![[Digital/Recursos/Quartus Instalacion 5.png]]
Volvemos a dar clic derecho sobre el archivo y seleccionamos "Ejecutar como un programa"

![[Digital/Recursos/Quartus Instalacion 4.png]]
Marcamos todas las casillas en la selección blanca y cliqueamos el boton de download, el programa instalara los componentes y instalara automáticamente.

![[Quartus Instalacion 6.png]]

Abrimos una terminal ( Un atajo rapido es CTRL + ALT + T ) y escribimos el siguiente comando

```bash
sudo nano .bashrc
```

y nos debería mostrar la consola de esta manera

![[Quartus Instalacion 7.png]]
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