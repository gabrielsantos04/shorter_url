FactoryBot.define do
  factory :pagina, class: "Pagina" do
    url { "http://example.com" }
    code  { "ABCDE" }
  end
end