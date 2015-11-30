json.array!(@records) do |record|
  json.extract! record, :id, :iv, :token, :file_name, :size, :creation, :repositories_id
  json.url record_url(record, format: :json)
end
