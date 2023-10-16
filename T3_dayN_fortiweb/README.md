# Xpert Summit 2023
# NetDevOps, protección avanzada API y disponibilidad global
## Objetivo del laboratorio
El objetivo de este laboratorio es dar nociones sobre cómo desplegar una infraestructura relativamente compleja de hub y spoke en AWS. Además de dar idea de cómo poder operar un firewall Fortigate a través de su API. Durante el laboratorio te familizarás con el entorno Terraform y cómo lanzar y customizar los despliegues.

Además, configurarás una nueva aplicación dentro del servicio de protección WAAP FortiWEB Cloud y realizarás pruebas de RedTeam contra la aplicación y verás como protegerla mediante Machine Learning.  

Por último, configurarás nuestro servicio de Global Service Load Balancing (GSLB) mediante DNS, FortiGSLB, para que los usuarios de la aplicación accedan a la misma siempre a su región más cercana. 

El formato del laboratorio consiste en 4 entrenamientos diferenciados y para poder realizarlos encontrarás todos los detalles en la siguiente URL, donde deberás introducir el token facilitado.

http://xs23.xpertsummit-es.com

## Indice de laboratorios a completar
* T1_day0_IaC_vpc_fgt_server: despliegue del entorno AWS
* T2_dayN_fgt_terraform: actualización de configuración del Fortigate mediante Terraform
* **T3_dayN_fortiweb**: creación de una nueva aplicación y protección avanzada API
* T4_dayN_fortigslb: añadiremos la aplicación a un servicio de balanceo global DNS

## Lab T3. Resumen puesta en marcha

En este laboratorio realizaremos lo siguiente:
- **IMPORTANTE** se debe haber completado con éxito el laboratorio T2
- Creación de una nueva aplicación protegida mediante FortiWEB cloud que tenga como servidor de origen el nuevo servicio publicado en nuestro fortigate mediante VIP y por tanto, al servidor final del laboratorio. (Completar [T2_dayN_fgt_terraform](./T2_dayN_fgt_terraform) sino se ha realizado ya)
- Lanzaremos pruebas de carga contra FortiWEB para que aprenda los patrones de tráfico de la aplicación y pueda aplicar protección avanzada no basada en firmas, mediante ML.
- Ejercicios de RedTeam para probar la eficacia de la protección.

## Diagrama del laboratorio

![architecture overview](./images/image0.png)

# LAB
## Pasos a seguir:

## 1. Conexión al servicio de FortiWEB Cloud
- En el portal de laboratorio, se ha asigando a cada participante una credencial de FortiCloud.

![image1-1.png](images/image1-1.png)

- Con esas credenciales acceder al servicio SaaS de FortiGSLB en la url [FortiWEB Cloud](http://www.fortiweb-cloud.com/)

![image1-2.png](images/image1-2.png)


## 2. Creación de una nueva aplicación
- La creación de una nueva aplicación en FortiWEB Cloud es bastante sencilla. En este laboratorio realizaremos el alta via GUI en el portal, pero se puede automatizar realizando peticiones a la API del servicio. [FortiWEB Cloud API reference](http://www.fortiweb-cloud.com/apidoc/api.html)
- En el menú de la izquierda seleccionaremos `Global > Applications`

![image2-1.png](images/image2-1.png)

- Dentro de la sección aplicaciones, clicaremos en `ADD APPLICATION` para arrancar el wizard de alta. 

![image2-2.png](images/image2-2.png)

- Wizard step 1: Nombre de applicación y dominio
    * Web Application Name: `Owner`-app (Owner asignado para el laboratorio)
    * Domain Name: `Owner`.xpertsummit-es.com

![image2-3.png](images/image2-3.png)

- Wizard step 2: Protocolo, puertos e IP origen del servidor
    * services allowed: HTTP
    * IP Address or FQDN: (IP pública de servicio Fortigate, en el lab T2 hemos creado una VIP para publicar el servicio)
    * Port: 80
    * Test Server: (comprobar conexión al servidor usando HTTP)

Nota: puedes obtener la IP pública de servicio del Fortigate en las salidas de Terraform del lab T1 y T2 o desde la propia consola de AWS

![image2-4.png](images/image2-4.png)

- Wizard step 3: CDN
    * services allowed: (NO habilitaremos servicios de CDN)

![image2-5.png](images/image2-5.png)

- Wizard step 4: Habilitar modo bloqueo y template
    * Enable Block mode: ON (habilitamos la protección)
    * Template: `xpertsummit23` (selecionamos este template en el desplegable)

![image2-6.png](images/image2-6.png)

- Completado: 
    * El resultado es un nuevo FQDN de nuestra applicación para acceder a través de FortiWEB Cloud y poder actualizar nuestros servidores DNS.
    * Desde el nuevo fqdn podremos acceder a nuestra aplicación a través de FortiWEB Cloud.

Nota: copiar en el nuevo FQDN para utilizar en el punto 4.

![image2-7.png](images/image2-7.png)

- En el menú general de aplicaciones podremos ver cómo FortiWEB Cloud de forma automática ha desplegado una instancia de FortiWEB en el Datacenter más cercano a la aplicación. 

![image2-8.png](images/image2-8.png)

FortiWEB Cloud despliega instancias cercanas a la aplicación de manera automática, siendo los principales Datacenters AWS, Azure, GCP y OCI. 

## 4. Creación de nuevo CNAME
Para que resulte más sencillo acceder a la nueva aplicación a través de FortiWEB Cloud, vamos a añadir un nuevo CNAME en el DNS, que resuelva al FQDN proporciando por FortiWEB Cloud para nuestra aplicación. 

En el punto 3 anterior step 4, obteniamos el FQDN de la aplicación, sino lo has llegado a copiar, puedes consultarlo entrando a la aplicación y en el menú de la izquierda `Network > Endpoint`

![image4-1.png](images/image4-1.png)

- Para la creación del nuevo CNAME accederemos via CLI a la carpeta de scripts del laboratorio: 
```sh
cd T3_dayN_fortiweb 
cd scripts
```
- Añadir permisos de ejecución al script:
```sh
chmod +x dns_student_cname.sh
```
- Ejecutar el script y proporcionar los siguientes parámetros cuando los solicite (Token de laboratorio y FortiWEB FQDN):
```sh
./dns_student_cname.sh
Introduce el token del laboratorio: <lab_token>
Introduce el FQDN de FortiWEB Cloud: <FQDN_fortiwebcloud_applicacion>
```
- Si todo funciona correctamente, se creará una nueva entrada de tipo de CNAME para acceder a la aplicación.

Nueva URL de acceso: http://{Owner}.xpertsummit-es.com

## 5. Training the ML model
El template de seguridad aplicado, lleva activado la protección de APIs mediante Machine Learning. Para que el modelo pueda aprender el patron de tráfico de la aplicación, vamos a forzar cierto tráfico mediante un par de script. Para revisar el template podeis hacerlo desde el menú de la izquierda `GLOBAL > templates`

![image5-1.png](images/image5-1.png)

Seleccionar el template `xpertsummit23` y revisar los profile de seguridad aplicados en el menú de la izquierda, en este caso el que aplica a este punto es el de `API PROTECTION > ML Based API Protection`

5.1 Lanzar los scripts de entrenamiento y aprendizaje

- Acceder via CLI a la carpeta de scripts del laboratorio: 
```sh
cd scripts
```
- Añadir permisos de ejecución a los scripts a ejecutar: 
```sh
chmod +x fwb_training_get.sh
chmod +x fwb_training_post.sh
```
- Ejecutar los scripts (para que funcione correctamente debe estar completado el paso 4)
```sh
./fwb_training_get.sh
```
![image5-1-1.png](images/image5-1-1.png)

```sh
./fwb_training_post.sh
```
![image5-1-2.png](images/image5-1-2.png)

5.2 Comprobación de los patrones aprendidos

- Iremos a la sección API colection de la aplicación, en el menú de la izquierda `API PROTECTION > ML Based API Protection`

![image5-2-1.png](images/image5-2-1.png)

- Cuando haya pasado un tiempo entre 5-10 minutos, desde que se hayan lanzado los scripts de entrenamiento, se presentarán los patrones de tráfico aprendidos por el modelo. 

![image5-2-2.png](images/image5-2-2.png)

- Se puede consultar el esquema API aprendido, incluso lo podemos descargar si fuera necesario, cambiando la vista a `API View` en la parte de la derecha. 

![image5-2-3.png](images/image5-2-3.png)

5.3 Aplicar bloqueo en las llamadas que no cumplan con el esquema

Por defecto, el esquema aprendido deja la protección en standby, de forma que las peticiones que no cumplan con dicho esquema, no son bloqueadas ni alertadas. Podemos cambiar este comportamiento en `Schema Protection`.

- Dentro de `API Collection`, donde aparecen los modelos aprendidos de API Paths, podemos dar a editar el comportamiento de protección, dandole al boton de editar que aparece a la derecha en la columna Action. 

![image5-3-1.png](images/image5-3-1.png)

- Dentro de la customización del API Path aprendido, entre otras cosas podemos modificar el comportamiento de protección, seleccionandolo en el desplegable de arriba a la derecha. 

![image5-3-2.png](images/image5-3-2.png)

## 6. ReadTeam
En este apartado vamos a comprobar, como de forma automática, FortiWEB Cloud puede proteger las llamadas a la API, en función a lo aprendido en los patrones de tráfico y al esquema Swagger que ha definido. 

**Nota: si el servicio todavía no ha publicado los esquemas de la API aprendidos con el entrenamiento, puedes pasar directamente al [Lab T4](http://github.com/xpertsummit/xpertsummit23/tree/main/T4_dayN_fortigslb) y luego volver a este punto**

En el punto 5.3, se ha modificado el comportamiento de protección frente a llamadas que no cumplan con el esquema. Comprobar este punto para esperar un comportamiento u otro en los siguientes test.

6.1 Query Parameter Violation

```sh
curl -v -X 'GET' 'http://{Owner}.xpertsummit-es.com/api/pet/findByStatus?' -H 'Accept: application/json' -H 'Content-Type: application/json'
```

    "status" JSON parameter is missing in the JSON request and is blocked by FortiWeb-Cloud. The expected result is a Request query validation failed status.


6.2 URL Query Parameter Long

    "status" URL query parameter is too long. The expected result, JSON parameter length violation.

```sh
curl -v -X 'GET' 'http://{Owner}.xpertsummit-es.com/api/pet/findByStatus?status=ABCDEFGHIJKL' -H 'Accept: application/json' -H 'Content-Type: application/json'
```

6.3 URL Query Parameter Short

    "status" URL query parameter is too short. The expected result is a parameter violation.

```sh
curl -v -X 'GET' 'http://{Owner}.xpertsummit-es.com/api/pet/findByStatus?status=A' -H 'Accept: application/json' -H 'Content-Type: application/json'
```

6.4 Cross Site Script in URL

    "status" URL query parameter will carry a Command Injection attack. The expected result is a known signature violation.
```sh
curl -v -X 'GET' 'http://{Owner}.xpertsummit-es.com/api/pet/findByStatus?status=<script>alert(123)</script>'  -H 'Accept: application/json' -H 'Content-Type: application/json'
```

6.5 Cross Site Script in Body

    "status" JSON body will carry an XSS attack. The expected result, the attack is being blocked by Machine Learning.

```sh
curl -v -X 'POST' 'http://{Owner}.xpertsummit-es.com/api/pet' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{"id": 111, "category": {"id": 111, "name": "Camel"}, "name": "FortiCamel", "photoUrls": ["WillUpdateLater"], "tags": [ {"id": 111, "name": "FortiCamel"}], "status": "<script>alert(123)</script>"}'
```

6.6 Zero Day Attacks

    We will now use some sample Zero Day Attacks.

    Cross Site Script in the Body

```sh
curl -v -X 'POST' 'http://{Owner}.xpertsummit-es.com/api/pet' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{"id": 111, "category": {"id": 111, "name": "Camel"}, "name": "javascript:qxss(X160135492Y1_1Z);", "photoUrls": ["WillUpdateLater"], "tags": [ {"id": 111, "name": "FortiCamel"}], "status": "available”}'
```

## Laboratorio completado

Pasar a lab 4: [T4_dayN_fortigslb](http://github.com/xpertsummit/xpertsummit23/tree/main/T4_dayN_fortigslb)

## Support
This a personal repository with goal of testing and demo Fortinet solutions on the Cloud. No support is provided and must be used by your own responsability. Cloud Providers will charge for this deployments, please take it in count before proceed.

## License
Based on Fortinet repositories with original [License](http://github.com/fortinet/fortigate-terraform-deploy/blob/master/LICENSE) © Fortinet Technologies. All rights reserved.


