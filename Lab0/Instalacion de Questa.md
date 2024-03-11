# GUIA DE INSTALACION DE QUESTA

Para descargar el software de Questa, debemos ingresar al siguiente [link](https://www.intel.com/content/www/us/en/software-kit/776289/questa-intel-fpgas-pro-edition-software-version-23-1.html) 
el cual nos redireccionara a la paguina oficial de Intel donde encontraremos este software. En esta pagina debemos seleccionar la version de Questa que deseamos descargas, asi como el sistema operativo sobre el cual queremos instalarlo 

![alt text](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Lab0/Recursos/Questa%201.png)


![alt text](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Lab0/Recursos/Questa%202.png)

Despues de descargar ambas partes accedemos a la terminal, esto mediante el atajo *Ctrl* + *Alt* + *T*. Desde la terminal accedemos a la carpeta donde quedo guardado los documentos descargados, esto se puede realizar colocando *cd + Nombre de la carpeta* 
o desde el explorador de archivos ubicandonos en la carpeta y darle en *abrir desde terminal*
![alt text](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Lab0/Recursos/Questa%203.png)

Ahora, en la terminal digitamos 
```
   chmod +x QuestaSetup-23.1.0.115-linux.run
```
despues de este comando, colocamos 
```
   ./QuestaSetup-23.1.0.115-linuxrun
```
Apartir de este comando se abrirá el menu de instalacion en el cual se debe continuar ante cada ventana emerguente que vaya apareciendo 
**Nota:** debes verificar que en la carpeta donde se descargo los instaladores, esté la parte 1 y 2 de Questa 
![alt text](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Lab0/Recursos/Questa%204.png)
![alt text](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Lab0/Recursos/Questa%205.png)
![alt text](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Lab0/Recursos/Questa%206.png)
![alt text](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Lab0/Recursos/Questa%208.png)

Una vez instalado el software, se debe activar la licencia, para ello, acedemos al siguiente [link](https://licensing.intel.com/psg/s/?language=en_US) y darle en *Enroll for Intel® FPGA Self Service Licensing
Center (SSLC)* en este lado nos registramos y esperamos a que al correo nos llegue la confirmacion del registro. 
![alt text](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Lab0/Recursos/Questa%209.png)
Ahora volvelmos a acceder al [link](https://licensing.intel.com/psg/s/?language=en_US) y damos click en *Already enrolled ? - Sign In here *, nos logeamos y seguimos los pasos que dicen, donde desde el celular debemos descargar una aplicacion *Microdsoft Authenticator* y escanear un codigo QR. 
![alt text](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Lab0/Recursos/Questa%2010.png)

Luego aceptamos los terminos y continuamos con el registro, de aqui nos redirige a la pagina principal de intel donde debemos dar click en *Sing up for Evaluation or No-Cost License* para luego seleccionar *Questa*-Intel® FPGA Starter* y dar en *next* 
![alt text](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Lab0/Recursos/Questa%2012.png)
![alt text](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Lab0/Recursos/Questa%2013.png)

aqui se desplegará un menu en el cual debemos llenar la informacion de la siguiente manera 
![alt text](https://github.com/DanielCastro-02/Electronica-Digital-G2-E1/blob/main/Lab0/Recursos/Questa%2014.png)

donde una vez llenado los datos, al correo registadro llegara un documento **.dat** que contiene la licencia de Questa la cual debemos activar abriendo Quartus y siguiendo las instrucciones *tools/License* setup donde nos permitira cargar el archivo de la licencia
