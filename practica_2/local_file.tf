resource "local_file" "productos-1" {
  content = "Lista de productos para el mes proximo"
  filename = "productos-${random_string.sufijo-1.id}.txt" 
}
resource "local_file" "productos-2" {
  content = "Lista de productos para el mes proximo"
  filename = "productos-${random_string.sufijo-2.id}.txt" 
}
resource "local_file" "productos-3" {
  content = "Lista de productos para el mes proximo"
  filename = "productos-${random_string.sufijo-3.id}.txt" 
}
resource "local_file" "productos-4" {
  content = "Lista de productos para el mes proximo"
  filename = "productos-${random_string.sufijo-4.id}.txt" 
}
resource "local_file" "productos-5" {
  content = "Lista de productos para el mes proximo"
  filename = "productos-${random_string.sufijo-5.id}.txt" 
}


# resource "local_file" "clientes" {
#   content = "Lista de clientes"
#   filename = "clientes.txt" #path donde se guarda el archivo cread
# }

