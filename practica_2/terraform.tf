resource "local_file" "productos" {
  content = "Lista de productos para el mes proximo"
  filename = "productos-${random_string.sufijo.id}.txt" 
}

# resource "local_file" "clientes" {
#   content = "Lista de clientes"
#   filename = "clientes.txt" #path donde se guarda el archivo cread
# }


resource "random_string" "sufijo" {
  length           = 4
  special          = false
  upper = false
  numeric = false
}