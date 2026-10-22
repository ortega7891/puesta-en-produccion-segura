# Puesta en Producción Segura

Repositorio de prácticas realizadas en el módulo de **Puesta en Producción Segura** del Máster FP en Ciberseguridad.

## Vagrant

Creación y aprovisionamiento automatizado de máquinas virtuales Ubuntu mediante **Vagrant y VirtualBox**.

Las máquinas se configuran mediante un `Vagrantfile`, definiendo recursos como CPU, memoria, red, hostname, redirección de puertos e instalación de paquetes.

## Terraform

Despliegue automatizado de máquinas virtuales en **Proxmox VE mediante Terraform**.

La infraestructura utiliza una plantilla Ubuntu con Cloud-Init y permite automatizar la creación y configuración inicial de las máquinas virtuales.

Las credenciales utilizadas para acceder a la API de Proxmox se almacenan localmente y no se incluyen en el repositorio.

## Ansible

Configuración automatizada de las máquinas creadas mediante Terraform utilizando **Ansible**.

El playbook realiza, entre otras, las siguientes tareas:

- Creación de usuarios.
- Eliminación e instalación de paquetes.
- Instalación y activación de Nginx.
- Creación de directorios y configuración de permisos.
- Copia de archivos desde el nodo controlador a los servidores administrados.

## Estructura

```text
.
├── ansible/
│   ├── hosts.ini
│   ├── playbook.yml
│   └── ejemplo.html
├── terraform1/
│   ├── main.tf
│   ├── .terraform.lock.hcl
│   └── terraform.tfvars.example
├── vagrant/
│   └── Vagrantfile
├── .gitignore
└── README.md
```

## Tecnologías utilizadas

Vagrant · VirtualBox · Terraform · Proxmox VE · Ansible · Linux · SSH
