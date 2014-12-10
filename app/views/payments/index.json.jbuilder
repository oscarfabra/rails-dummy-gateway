json.array!(@payments) do |payment|
  json.extract! payment, :id, :number, :month, :year, :first_name, :last_name, :verification_value
  json.url payment_url(payment, format: :json)
end
