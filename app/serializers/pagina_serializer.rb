class PaginaSerializer
  include JSONAPI::Serializer

  attributes :url, :code, :id, :created_at
  attribute :clicks do |obj|
    obj.clicks.count
  end
  has_many :clicks
end
