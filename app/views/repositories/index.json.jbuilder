json.array!(@repositories) do |repository|
  json.extract! repository, :id, :iv, :title, :master_key, :pass, :token, :description, :created, :deletion
  json.url repository_url(repository, format: :json)
end
