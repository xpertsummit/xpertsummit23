# Xpert Summit 2023
# NetDevOps, protección avanzada API y disponibilidad global
## Objetivo del laboratorio
El objetivo de este laboritorio es dar nociones sobre como desplegar una infraestructura relativamente compleja de hub y spoke en AWS. Además de dar idea de cómo poder operar un firewall Fortigate a través de su API. Durante el laboratio te familizaras con el entorno Terraform y como lanzar y customizar los despligues. 

Además, configurarás una nueva aplicación dentro del servicio de protección WAAP FortiWEB Cloud y realizarás pruebas de RedTeam contra la aplicación y verás como protegerla mediante Machine Learning.  

Por último, configuraras nuestro servicio de Global Service Load Balancing (GSLB) mediante DNS, FortiGSLB, para que los usuarios de la aplicación accedan a la misma siempre a su región más cercana. 

El formato del laboratorio consiste en 4 entrenamiento diferenciados y para poder realizarlos encontrarás todos los detalles en la siguiente URL, donde deberás introducir el token facilitado.

http://labserver.xpertsummit-es.com

## Indice de laboratorios a completar
* **T1_day0_IaC_vpc_fgt_server**: despliegue del entorno AWS
* T2_dayN_fgt_terraform: actualiación de configuraicón del Fortigate mediante Terraform
* T3_dayN_fortiweb: creación de una nueva aplicación y protección avanzada API
* T4_dayN_fortigslb: añadiremos la aplicación a un servicio de balanceo global DNS

## Resumen puesta en marcha

En este laboratorio se desplegarán los siguientes recursos:
- Para el rango CIDR se usará el proporcionado a cada participante.
- 1 VPC con 4 subnets: Management, Public, Private y Bastion
- Los Security Groups (SG) que se asociarán a cada una de las interfaces.
- 1 x fortigate con los interfaces necesarios en cada subnet, sus SG asociados y la configuración SDWAN necesaria.
- 1 x servidor docker con una aplicación API de testeo.

## Diagrama del laboratorio

![architecture overview](./images/image0.png)


# LAB
## Pasos a seguir:

## 1. Conexión al entorno de desarrollo Cloud9
Desde el [portal formación](http://xpertsummit22.jvigueras-fortinet-site.com) podeis encontrar el acceso a vuestro entorno Cloud9.

1.1 Obtener los datos de cada usuario:
- Desde el portal de formación introducir el email de registro al curso.
- Apareceran los datos asociados para usar durante el laboratorio.
- Acceder a la URL del portal Cloud9 que aparece en vuestros datos con el: `user` y `password`.

![Student data](./images/image1-1-1.png)

- Ejemplo:
  - URL acceso: https://region.console.../cloud9/ide/c93257xxxxxxxxx
  - accountid: xxxxxx
  - User: xs22-eu-west-1-user-1
  - Password: xxxxx

![Portal de acceso AWS](./images/image1-1-2.png)

![Portal de acceso AWS](./images/image1-1-3.png)


## 2. Clonar repositorio desde GitHub
- Abrir una nueva consola terminal o usar la actual
- Desde el terminal ejecutar el siguiente comando: 
```
git clone https://github.com/jmvigueras/xpertsummit22.git
```
- ... o desde el botón de Git que se puede encontrar e introduciendo la URL anterior

![Clone git repository](./images/image2-1.png)

![Clone git repository](./images/image2-2.png)


## 3.  Acceder a la carpeta T1_day0_deploy-vpc
- Desde el terminal 
```
cd xpertsummit22/T1_day0_deploy-vpc
```
- Desde el navegador de ficheros de la parte izquierda desdplegando la carpeta corrspondiente al T1

![Open text editor](./images/image3-1.png)


## 4. **IMPORTANTE** Actualizar las variables necesarias para este primer laboratorio
- Esta será la única vez que será necesario actualizar estas variables.
- Se debe actualizar de forma con los datos de cada participante para poder completar el lab
- Los datos se deben de obtinen desde el [portal formación](http://xpertsummit22.jvigueras-fortinet-site.com) 
- Hacer doble click en el fichero **UPDATE-vars.tf** desde el explorador de ficheros.
- Actualizar las siguientes variables con los datos de cada participante.
```sh
// IMPORTANT: UPDATE Owner with your AWS IAM user name
variable "tags" {
  description = "Attribute for tag Enviroment"
  type = map(any)
  default     = {
    Owner   = "xs22-eu-west-1-user-1"   //update with your assigned user for access AWS console
    Name    = "user-1"                  //update with your assigned user name
    Project = "xs22"                    
  }
}
// Region and Availability Zone where deploy VPC and Subnets
variable "region" {
  type = map(any)
  default = {
    "region"     = "eu-west-1"   //update with your assigned region
    "region_az1" = "eu-west-1a"  //update with your assigned AZ
  }
}
// CIDR range to use for your VCP: 10.1.x.x group 1 - 10.1.1.0/24 user-1
variable "vpc-spoke_cidr"{
  type    = string
  default = "10.1.1.0/24"   //update with your assigned cidr
}
```
(Recuerda guardar el fichero con los cambios realizados)

Nota: los rangos cidr están repartidos para cada participante y no se solpan, para lo que se ha seguido la siguiente nomenclatura:

 - 10.1.x.x asignado a la region west-1
 - 10.2.x.x asignado a la region west-2
 - ...
 - 10.1.0.0/24 asignado al user 0 en la region west-1
 - 10.2.1.0/24 asignado al user 1 en la region west-2
 - ...

## 5. **IMPORTANTE** - Actualizar las credenciales de acceso programático que usuará Terraform para el despliegue
- Hacer doble click en el fichero **terraform.tfvars.example** desde el explorador de ficheros.
- Actualizar las variables con los datos proporcionados en el [portal formación](http://xpertsummit22.jvigueras-fortinet-site.com) 
```
access_key          = "<AWS Access Key>"
secret_key          = "<AWS Secret Key>"
externalid_token    = "<ExternalID token>"
```
- Las variables deben quedar configuradas con el siguiente patrón: access_key="AZXSxxxxxx"
- Cambiar el nombre al fichero `terraform.tfvars.example` a `terraform.tfvars`

(Recuerda guardar el fichero con los cambios realizados)

## 6. **Despligue** 

* Inicialización de providers y modulos:
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
* Comprobar que se van a desplegar los recursos esperados en el plan.

![Terraform output](./images/image6-0.png)

* Confirmar despligue, type `yes`.

![Terraform output](./images/image6-1.png)

* Si todo funciona correctamente se generará una salida con el resumen del plan de despligue y las variables de output configuradas:

![Terraform output](./images/image6-2.png)


## Laboratorio completado
Pasar a lab 2: [T2_day0_deploy-server](https://github.com/jmvigueras/xpertsummit22/tree/main/T2_day0_deploy-server)


## Support
This a personal repository with goal of testing and demo Fortinet solutions on the Cloud. No support is provided and must be used by your own responsability. Cloud Providers will charge for this deployments, please take it in count before proceed.

## License
Based on Fortinet repositories with original [License](https://github.com/fortinet/fortigate-terraform-deploy/blob/master/LICENSE) © Fortinet Technologies. All rights reserved.


