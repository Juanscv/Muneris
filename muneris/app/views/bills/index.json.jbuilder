json.array!(@bills) do |bill|
  json.extract! bill, :id, :consumption, :value, :date
  json.url bill_url(bill, format: :json)
end
