# 1-Intro


1. [Instalar Terraform](#schema1)
2. [ipos de IaC y sus diferentes usos](#schema2)
3. [¿Qués es HCL?](#schema3)
4. [Nuestro primer código](#schema4)
5. [Multiple Providers y definicion de DRY](#schema5)



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

## 5. Multiple Providers y definicion de DRY

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

  <hr>

<a name="schemaref"></a>

REF: https://www.udemy.com/course/hashicorp-terraform/
