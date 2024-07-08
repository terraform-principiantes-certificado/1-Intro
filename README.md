# 1-Intro


1. [Instalar Terraform](#schema1)
2. [ipos de IaC y sus diferentes usos](#schema2)
3. [¿Qués es HCL?](#schema3)
4. [Nuestro primer código](#schema4)
5. [Multiple Providers y definicion de DRY (Don't Repeat Yourself)](#schema5)
6. [Despliegue en AWS](#schema6)
7. [Como guardar y usar un plan](#schema7)
8. [Terraform FMT & Terraform Validate](#schema8)
9. [Restringir las versiones (Constraints) de Terraform & Providers](#schema9)



[REF](#schemaref)

<hr>

<a name="schema1"></a>

## 1. Instalar Terraform

https://developer.hashicorp.com/

https://developer.hashicorp.com/terraform/install

Verificar si esta terraform instalado
```bash
terraform --version
```

<hr>

<a name="schema2"></a>

## 2. Tipos de IaC y sus diferentes usos 

- Ansible y Puppet
  - Su finalidad es intalar y gestionar software
  - Nos permite mantener un estándar en nuestros servidores
  - Podemos tener un control de versiones de nuestros despligues
- IaC orientado a Servidores (Templates) (Docker, pscker, vagrant)
  - Nos permite tener pre-instalado el software y las dependencias necesarias
  - Funciona tanto como para VM como para Contenedores
  - Infraestructura Inmutable
- IaC para aprovisionamiento (Terraform Y AWS CloudFormation)
  - Infraestructura como codigo DECLARATIVO
  - Aprovisionar recursos INMUTABLES  en nuestra infraestructura
  - Toda clase de recuros como instancias, bases de datos, buckets, vpc, etc....
  - Podemos deplyar infraestructura en multiples providers (Terraform)


  <hr>

<a name="schema3"></a>

## 3. ¿Qués es HCL?

HCL - Hashicorp Configuration Language - Declarativo

![HCL](./img/hcl.png)

Donde buscar los recursos que necesitamos para deployar: https://registry.terraform.io/


`local_file`: https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file


  <hr>

<a name="schema4"></a>

## 4. Nuestro primer código

[Código](./practica_1/terraform.tf)

### **Ejecutar el código**
```
resource "local_file" "productos" {
  content = "Lista de productos"
  filename = "productos.txt" #path donde se guarda el archivo cread
}
```

- Inicializar:

  ```bash
  terraform init
  ```
- Generar un plan en base a nuestro código
  ```bash
  terraform plan
  ```

![Plan](./img/plan.png)

- Ejecutar
  ```bash
  terraform apply 
  ```
  Nos ejecuta el código creando primero un plan y luego preguntando si queremos hacerlo.
  ![Apply](./img/apply.png)

  Nos ha creado una archivo txt, [productos.txt](./practica_1/productos.txt)
  Con la frase que le pusimo en el recurso.

  ### **Cambios en el archivo txt.**

  No podemos cambiar el texto que tiene el archivo `productos.txt` modificando ese archivo tenemos que cambiar el código.


- Generar un plan en base a nuestro código
```bash
terraform plan
```

![Plan](./img/plan_2.png)

- Ejecutar
```bash
terraform apply 
```

### **No queremos este código**

```bash
terraform destroy
```
![Destroy](./img/destroy.png)


  <hr>

<a name="schema5"></a>

## 5. Multiple Providers y definicion de DRY (Don't Repeat Yourself)

1. Creamos carpeta de practica_2 y añadimos al código otro bloques de recursos
![Plan](./img/p2_plan.png)

2. Nuevo provider `Random`: https://registry.terraform.io/providers/hashicorp/random/latest

    Vamos a usar este: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
    
    ```
    resource "local_file" "productos" {
      content = "Lista de productos para el mes proximo"
      filename = "productos.txt" #path donde se guarda el archivo cread
    }

    resource "random_string" "sufijo" {
      length           = 4
      special          = false
      upper = false
      numeric = false
    }
    ```
    Si hacemos `terraform plan` nos da este error

    ```bash
    Error: Inconsistent dependency lock file
    │ 
    │ The following dependency selections recorded in the lock file are inconsistent with the current configuration:
    │   - provider registry.terraform.io/hashicorp/random: required by this configuration but no version is selected
    │ 
    │ To update the locked dependency selections to match a changed configuration, run:
    │   terraform init -upgrade

    ```
    Porque pasa esto, porque estamos trabajando con un nuevo provider y no hemos ejecutado `terraform init` para que terraform tenga en conocimiento los nuevos providers

    Una vez hecho el `terraform apply` nos genera esto, el archivo `productos-rjjj.txt` que es lo que queríamos. El archivo producto son un sufijo.

    ```bash
    productos-rjjj.txt  terraform.tf  terraform.tfstate  terraform.tfstate.backup
    ```
3. `terraform show`

    Con este comando podemos ver los recursos que terraform ha creado
    ![Show](./img/p2_show.png)

4. Dividir el código en dos archivos `local_file.tf`y `random.tf`. Cuando hacemos `terraform.apply` nos dice que todo sigue igual porque para terraform funciona indistintamente si los providers estan todos es un mismo archivo o en distintos. 
5. Probamos a tener 5 archivos. Modificamos el archivo `local_file.tf` y hacemos `terraform.apply` 
    ```
    resource "local_file" "productos" {
      content = "Lista de productos para el mes proximo"
      filename = "productos-${random_string.sufijo.id}.txt" 
    }
    resource "local_file" "productos" {
      content = "Lista de productos para el mes proximo"
      filename = "productos-${random_string.sufijo.id}.txt" 
    }
    resource "local_file" "productos" {
      content = "Lista de productos para el mes proximo"
      filename = "productos-${random_string.sufijo.id}.txt" 
    }
    resource "local_file" "productos" {
      content = "Lista de productos para el mes proximo"
      filename = "productos-${random_string.sufijo.id}.txt" 
    }
    resource "local_file" "productos" {
      content = "Lista de productos para el mes proximo"
      filename = "productos-${random_string.sufijo.id}.txt" 
    }
    ``` 
    Error por duplicidad del recurso `local_file`
    ```bash
    Error: Duplicate resource "local_file" configuration
    ```
    Hacemos cambio en el codigo
    ```
    resource "local_file" "productos-1" {
    content = "Lista de productos para el mes proximo"
    filename = "productos-${random_string.sufijo.id}.txt" 
    }
    resource "local_file" "productos-2" {
      content = "Lista de productos para el mes proximo"
      filename = "productos-${random_string.sufijo.id}.txt" 
    }
    resource "local_file" "productos-3" {
      content = "Lista de productos para el mes proximo"
      filename = "productos-${random_string.sufijo.id}.txt" 
    }
    resource "local_file" "productos-4" {
      content = "Lista de productos para el mes proximo"
      filename = "productos-${random_string.sufijo.id}.txt" 
    }
    resource "local_file" "productos-5" {
      content = "Lista de productos para el mes proximo"
      filename = "productos-${random_string.sufijo.id}.txt" 
    }
    ```
      Al hacer `terraform apply` solo nos ha creado un solo archivo `productos-cfqg.txt`. Porque estamos referenciando  un recurso `random_string` de cual solo tenemos uno. Solo tenemos un recurso y lo estamos usando en 5 archivo por lo tanto los 5 archivos se llaman igual y por eso solo vemos una.
      ```bash
      local_file.tf  productos-cfqg.txt  random.tf  terraform.tfstate  terraform.tfstate.backup
      ```
      Para poder ver 5 archivos hay que modificar el archivo `random.tf`
      ```
      resource "random_string" "sufijo-1" {
      length           = 4
      special          = false
      upper = false
      numeric = false
      }
      resource "random_string" "sufijo-2" {
        length           = 4
        special          = false
        upper = false
        numeric = false
      }
      resource "random_string" "sufijo-3" {
        length           = 4
        special          = false
        upper = false
        numeric = false
      }
      resource "random_string" "sufijo-4" {
        length           = 4
        special          = false
        upper = false
        numeric = false
      }
      resource "random_string" "sufijo-5" {
        length           = 4
        special          = false
        upper = false
        numeric = false
      }
      ```
      Y actualizar las referencias en el  archivo `local_file.tf`
      Ahora si tenemos los 5 archivos pero esta no es buena práctica. Porque estamos repitiendo mucho código.

6. Probando a no repetir código. Vamos a usar una clausula especial`count`. Con los cambio necesarios tenemos los 5 archivos creados correctamente.
    ![Show](./img/p2_show_2.png)
  


  <hr>

<a name="schema6"></a>

## 6. Despliegue en AWS

### **Crear un bucket S3**
Documentación:

https://registry.terraform.io/providers/hashicorp/aws/latest/docs
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

```python
resource "aws_s3_bucket" "proveedores" {
  bucket = "proveedores_regional_patri"
}
```
1. `terraform init`
2. `terraform plan`
3. `terraform apply`

![S3](./img/s3_aws.png)

4. `terraform destroy`

### **Crear bucket S3 para crear buckets únicos usando el recurso random_string**

Vamos a crear dos buckets:

```python
resource "aws_s3_bucket" "proveedores" {
  count = 2
  bucket = "proveedores-${random_string.sufijo[count.index].id}"
}


resource "random_string" "sufijo" {
  count  = 2 
  length = 8
  special = false
  upper = false
  numeric = false
}
```
1. `terraform init`, porque hemos añadido un recurso nuevo a nuestro documento, `random_string`
2. `terraform plan`
3. `terraform apply`

![S3](./img/s3_aws_2.png)


### **Añadir `tags` al bucket**
```python
resource "aws_s3_bucket" "proveedores" {
  count = 2
  bucket = "proveedores-${random_string.sufijo[count.index].id}"
   tags = {
    Owner       = "Patri"
    Environment = "Dev"
    Office = "proveedores"
  }
}


resource "random_string" "sufijo" {
  count  = 2 
  length = 8
  special = false
  upper = false
  numeric = false
}
```
1. `terraform plan`
2. `terraform apply`


![Tags](./img/tags.png)



3. `terraform destroy`


  <hr>

<a name="schema7"></a>


## 7. Como guardar y usar un plan

Para tener una copia del plan, aunque alguien modifique a posteriori los recursos de nuestro archivo.


1. `terraform plan -out s3.plan`
2. `terraform apply "s3.plan"`
3. `terraform destroy`

  <hr>

<a name="schema8"></a>

## 8. Terraform FMT & Terraform Validate

### **`terraform ftm`**
1. `terraform fmt`: formatea el archivo tf. Te formate todos los archivos `.tf` que tengas en la carpeta en la que estas ejecutandose el comando.

2. `terraform fmt terraform.tf`: Solo formatea ese archivo `terraform.tf`

### **`terraform validate`**
1. `terraform validate` : valida que la sintaxis que tenemos en nuestros archivos sean los correctos. Valida todos los archivos de la carpeta.
También podemos hacer `terraform plan`y nos diría si tenemos algo no correcto, pero con la diferencia que tendríamos que esperar que se genere todo el plan para que nos dira los fallos, en cambio el validate es mucho más rápido porque no genera el plan. 


  <hr>
  
<a name="schema9"></a>


## 9. Restringir las versiones (Constraints) de Terraform & Providers

![Restringir](./img/restringir.png)

[DOC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

Ejemplo:

```python
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
```




  <hr>

<a name="schemaref"></a>

REF: https://www.udemy.com/course/hashicorp-terraform/
