# Carga el cliente encargado de comunicarse con la API de EasyBroker
require_relative "lib/easybroker_client"

# Carga el servicio que contiene la lógica de negocio
require_relative "lib/properties_service"

# Crea una instancia del cliente usando la API Key desde la variable de entorno
client = EasyBrokerClient.new

# Inyecta el cliente en el servicio (inyección de dependencias)
service = PropertiesService.new(client)

# Ejecuta el caso de uso: imprimir todos los títulos de las propiedades
service.print_all_titles
