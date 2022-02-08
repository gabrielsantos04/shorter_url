FactoryBot.define do
  factory :click, class: "Click" do
    pagina
    browser { "Browser" }
    platform  { "Windows" }
  end
end