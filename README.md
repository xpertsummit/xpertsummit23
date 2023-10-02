# Xpert Summit 2023
# NetDevOps, protección avanzada API y disponibilidad global
## Objetivo del laboratorio
El objetivo de este laboritorio es dar nociones sobre como desplegar una infraestructura relativamente compleja de hub y spoke en AWS. Además de dar idea de cómo poder operar un firewall Fortigate a través de su API. Durante el laboratio te familizaras con el entorno Terraform y como lanzar y customizar los despligues. 

Además, configurarás una nueva aplicación dentro del servicio de protección WAAP FortiWEB Cloud y realizarás pruebas de RedTeam contra la aplicación y verás como protegerla mediante Machine Learning.  

Por último, configuraras nuestro servicio de Global Service Load Balancing (GSLB) mediante DNS, FortiGSLB, para que los usuarios de la aplicación accedan a la misma siempre a su región más cercana. 

El formato del laboratorio consiste en 4 entrenamiento diferenciados y para poder realizarlos encontrarás todos los detalles en la siguiente URL, donde deberás introducir el token facilitado.

http://labserver.xpertsummit-es.com

## Indice de laboratorios a completar
* T1_day0_IaC_vpc_fgt_server: despliegue del entorno AWS
* T2_dayN_fgt_terraform: actualiación de configuraicón del Fortigate mediante Terraform
* T3_dayN_fortiweb: creación de una nueva aplicación y protección avanzada API
* T4_dayN_fortigslb: añadiremos la aplicación a un servicio de balanceo global DNS

## Deployment Overview

## T1: [T1_day0_IaC_vpc_fgt_server](./T1_day0_IaC_vpc_fgt_server)
En este laboratorio se desplegarán los siguientes recursos:
- Para el rango CIDR se usará el proporcionado a cada participante.
- 1 VPC con 4 subnets: Management, Public, Private y Bastion
- Los Security Groups (SG) que se asociarán a cada una de las interfaces.
- 1 x fortigate con los interfaces necesarios en cada subnet, sus SG asociados y la configuración SDWAN necesaria.
- 1 x servidor docker con una aplicación API de testeo.

**IMPORTANTE** Si todo ha ido bien aparecerás en la Leader Board

## T2: [T2_dayN_fgt_terraform](./T2_dayN_fgt_terraform)
En este laboratorio realizaremos lo siguiente:
- **IMPORTANTE** se debe haber completado con éxito el laboratorio: T1
- Las variables necesarias para poder realizar el despliegue de la IaC se recogen del anterior laboratorio.
- Los datos necesarios para poder desplegar la configuración en el equipo se cargan de manera automática.
- La idea del laboratorio es que se apliquen los cambios de configuración necesarios, via Terraform FortiOS provider, contra el Fortigate desplegado en el laboratorio anterior para crear una nueva VIP contra el servidor. 

## T3: [T3_dayN_fortiweb](./T3_dayN_fortiweb)

En este laboratorio realizaremos lo siguiente:
- **IMPORTANTE** se debe haber completado con éxito el laboratorio T2
- Creación de una nueva aplicación protegida mediante FortiWEB cloud que tenga como servidor de origen el nuevo servicio publicado en nuestro fortigate mediante VIP y por tanto, al servidor final del laboratorio. (Completar [T2_dayN_fgt_terraform](./T2_dayN_fgt_terraform) sino se ha realizado ya)
- Lanzaremos pruebas de carga contra FortiWEB para que aprenda los patrones de tráfico de la aplicación y pueda aplicar protección avanzada no basada en firmas, mediante ML.
- Ejercicios de RedTeam para probar la eficacia de la protección.

## T4: [T4_dayN_fortigslb](./T4_dayN_fortigslb)

En este entrenamiento realizaremos lo siguiente:
- **IMPORTANTE** se debe haber completado con éxito el laboratorio: T2
- Añadir nuestro servidor al servicio GSLB ya configurado en FortiGLB.
- Comprobación que el servicio añade a la resolución DNS de la aplicación nuestra IP.



## Diagram solution

![architecture overview](images/image0.png)


# LAB
## Pasos a seguir:

## 1. Conexión al entorno de desarrollo Cloud9
- (Revisar detalle de pasos en laboratorio T1)

## 2. Clonar repositorio Git
- (Revisar detalle de pasos en laboratorio T1)

## 3.  Acceder a la carpeta del laboratorio correspondiente
- Abrir un nuevo terminal y entrar en la carpeta del laboratorio
```
cd T1_day0_IaC_vpc_fgt_server\terraform
```
- Desde el navegador de ficheros de la parte izquierda desplegando la carpeta correspondiente

## 4. **IMPORTANTE** Seguir las indicaciones del laboratorio T1
- Las variables necesarias para este laboratorio se completan en el laboratorio T1
- Las credendiales y resto de variables se importan desde el laboratorio T1 al resto
- Cambiar el nombre al fichero `terraform.tfvars.example` a `terraform.tfvars`

## 7. **Despligue** 
- (Seguir las indicaciones de cada laboratorio)

## 8. Comandos Terraform para despliegue

## Inicialización de providers y modulos:
  ```sh
  $ terraform init
  ```
* Crear un plan de despliegue y 
  ```sh
  $ terraform plan
  ```
* Comprobación que toda la configuración es correcta y no hay fallos.
* Desplegar el plan.
  ```sh
  $ terraform apply
  ```
* Confirmar despligue, type `yes`.


La salida incluye todo el detalle del despligue:
```sh
Outputs:
```


## Support
This a personal repository with goal of testing and demo Fortinet solutions on the Cloud. No support is provided and must be used by your own responsability. Cloud Providers will charge for this deployments, please take it in count before proceed.

## License
Based on Fortinet repositories with original [License](https://github.com/fortinet/fortigate-terraform-deploy/blob/master/LICENSE) © Fortinet Technologies. All rights reserved.


