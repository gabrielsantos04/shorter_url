class ClickSerializer
  include JSONAPI::Serializer
  attributes :platform, :browser, :pagina_id, :created_at
end
