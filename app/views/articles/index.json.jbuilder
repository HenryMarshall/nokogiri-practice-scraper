json.array!(@articles) do |article|
  json.extract! article, :id, :title, :author, :lead, :category
  json.url article_url(article, format: :json)
end
