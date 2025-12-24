# Carga Minitest, el framework de pruebas incluido en Ruby
require "minitest/autorun"

# Carga la clase que vamos a probar
require_relative "../lib/properties_service"

# Cliente falso (test double) que simula el comportamiento de la API de EasyBroker
# Se usa para evitar llamadas HTTP reales durante las pruebas
class FakeEasyBrokerClient
  def initialize
    # Controla si ya se simuló una llamada previa
    @called = false
  end

  # Simula el método que el servicio espera del cliente real
  def get_properties(page:, limit: 20)
    # En la segunda llamada regresa un arreglo vacío
    # para simular que ya no hay más páginas
    return { "content" => [] } if @called

    # Marca que ya se realizó la primera llamada
    @called = true

    # Respuesta simulada con una propiedad de prueba
    {
      "content" => [
        { "title" => "Propiedad de prueba" }
      ]
    }
  end
end

# Pruebas unitarias para PropertiesService
class PropertiesServiceTest < Minitest::Test
  # Verifica que el servicio imprima correctamente los títulos de las propiedades
  def test_prints_property_titles
    # Se inyecta el cliente falso en lugar del cliente real
    service = PropertiesService.new(FakeEasyBrokerClient.new)

    # Captura la salida estándar y valida que el título esperado se imprima
    assert_output(/Propiedad de prueba/) do
      service.print_all_titles
    end
  end
end
