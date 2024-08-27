class LogSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :created_at
end
