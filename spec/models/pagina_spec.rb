require 'rails_helper'

RSpec.describe Pagina, type: :model do
  let(:pagina) { create(:pagina) }

  describe '#associations' do
    it { is_expected.to have_many(:clicks) }
  end

  describe '#validations' do
    it 'should be valid' do
      expect(pagina).to be_valid
    end

    it 'should be invalid' do
      pagina.url = nil
      expect(pagina).to be_invalid
    end

    it 'should be invalid' do
      pagina.url = 'www.uol.com'
      expect(pagina).to be_invalid
    end
  end

  describe '#set_click' do
    let(:browser) { double }

    before do
      allow(browser).to receive(:name).and_return('Chrome')
      allow(browser).to receive_message_chain(:platform, :name).and_return('Windows')
    end

    it 'should create a new click' do
      expect { pagina.set_click(browser) }.to change { pagina.clicks.count }.by(1)
    end
  end

  describe '#clicks_by_day' do
    let!(:click1) { create(:click, pagina: pagina)}
    let!(:click2) { create(:click, pagina: pagina)}
    let(:expected_result) do
      [ [Date.today.to_s, 2] ]
    end

    it 'should return day with 2 counts' do
      expect(pagina.clicks_by_day).to eq(expected_result)
    end
  end

  describe '#clicks_by_browser' do
    let!(:click1) { create(:click, pagina: pagina)}
    let!(:click2) { create(:click, pagina: pagina)}
    let(:expected_result) do
      [ ['Browser', 2] ]
    end

    it 'should return browser with 2 counts' do
      expect(pagina.clicks_by_browser).to eq(expected_result)
    end
  end

  describe '#clicks_by_platform' do
    let!(:click1) { create(:click, pagina: pagina)}
    let!(:click2) { create(:click, pagina: pagina)}
    let(:expected_result) do
      [ ['Windows', 2] ]
    end

    it 'should return windows with 2 counts' do
      expect(pagina.clicks_by_platform).to eq(expected_result)
    end
  end
end
