# Servicio encargado de procesar las propiedades obtenidas desde EasyBroker
# Su responsabilidad es únicamente la lógica de negocio, no el acceso a la API
class PropertiesService
  # Recibe un cliente (inyección de dependencias)
  # Esto permite cambiar el cliente real por uno falso en pruebas unitarias
  def initialize(client)
    @client = client
  end

  # Obtiene todas las propiedades de forma paginada
  # e imprime el título de cada una en consola
  def print_all_titles
    page = 1

    loop do
      # Solicita las propiedades de la página actual
      response = @client.get_properties(page: page)

      # Extrae la lista de propiedades o usa un arreglo vacío si no existe
      properties = response["content"] || []

      # Termina el ciclo cuando ya no hay más propiedades
      break if properties.empty?

      # Imprime el título de cada propiedad
      properties.each do |property|
        puts property["title"]
      end

      # Avanza a la siguiente página
      page += 1
    end
  end
end
