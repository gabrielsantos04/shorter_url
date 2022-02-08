require 'rails_helper'

RSpec.describe Click, type: :model do
  let(:pagina) { create :pagina }
  let(:click) { create :click, pagina: pagina}

  describe '#created_at_to_string' do
    it 'Must return created_at like string' do
      expect(click.created_at_to_string).to eq(Date.today.to_s)
    end
  end
end
