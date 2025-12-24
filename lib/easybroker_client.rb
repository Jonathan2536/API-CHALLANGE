# Librería estándar para hacer solicitudes HTTP
require "net/http"

# Librería para convertir respuestas JSON a hashes de Ruby
require "json"

# Librería para manejar y construir URLs de forma segura
require "uri"

# Cliente encargado de comunicarse con la API de EasyBroker
class EasyBrokerClient
  # URL base del ambiente de pruebas de EasyBroker
  BASE_URL = "https://api.stagingeb.com/v1"

  # Inicializa el cliente con la API key
  # Por defecto toma la clave desde la variable de entorno EASYBROKER_API_KEY
  def initialize(api_key = ENV["EASYBROKER_API_KEY"])
    # Validación básica para asegurar que la API key exista
    raise "API key no configurada" if api_key.nil? || api_key.empty?

    @api_key = api_key
  end

  # Obtiene las propiedades desde la API
  # Soporta paginación mediante los parámetros page y limit
  def get_properties(page:, limit: 20)
    # Construye la URL completa del endpoint /properties
    uri = URI("#{BASE_URL}/properties")

    # Agrega los parámetros de consulta a la URL
    uri.query = URI.encode_www_form(page: page, limit: limit)

    # Crea la solicitud HTTP tipo GET
    request = Net::HTTP::Get.new(uri)

    # Agrega el encabezado de autorización requerido por EasyBroker
    request["X-Authorization"] = @api_key

    # Indica que la respuesta será en formato JSON
    request["Content-Type"] = "application/json"

    # Ejecuta la solicitud HTTPS
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    # Convierte la respuesta JSON a un hash de Ruby
    JSON.parse(response.body)
  end
end
