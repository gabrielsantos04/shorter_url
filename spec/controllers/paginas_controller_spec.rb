require 'rails_helper'

RSpec.describe PaginasController do
  describe '#index' do
    let!(:pagina1) { create :pagina }
    let!(:pagina2) { create :pagina }
    let!(:pagina3) { create :pagina }

    subject { get :index }

    it 'should assigns paginas' do
      subject

      expect(assigns(:paginas)).to_not be_nil
    end

    it 'render index template' do
      expect(subject).to render_template("index")
    end
  end

  describe '#show' do
    let(:pagina) { create :pagina }
    it 'must render show template' do
      get :show, params: { id: pagina.id }

      expect(response).to render_template('show')
    end
  end

  describe '#create' do
    context 'when has correct params' do
      it 'creates the url' do
        post :create, params: { pagina: { url: 'http://uol.com' } }

        expect(response).to redirect_to(pagina_url(assigns(:pagina)))
      end
    end

    context 'when has incorrect params' do
      it 'redirect to index withoud save' do
        post :create, params: { pagina: { url: 'uol.com' } }

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '#visit' do
    let(:pagina) { create :pagina, code: 'TESTE' }
    let(:browser) { double }
    let(:click) { create :click }

    context 'when has correct short_url' do
      before do
        allow(Browser).to receive(:new).and_return(browser)
        allow(Pagina).to receive(:find_by).and_return(pagina)
        allow(pagina).to receive(:set_click).and_return(click)
      end

      it 'redirect to url and save click' do
        get :visit, params: { short_url: 'TESTE' }

        expect(response).to redirect_to(pagina.url)
      end
    end

    context 'when has incorrect short_url' do
      it 'redirect to 404 page' do
        get :visit, params: { short_url: 'INCORRECT' }

        expect(response).to redirect_to('/404.html')
      end
    end
  end

  describe '#jasonapi' do
    context 'when has no one url created' do
      let(:expected_result) do
        {
          data: [ ]
        }
      end

      before do
        Click.destroy_all
        Pagina.destroy_all
      end

      it 'should return empty data' do
        get :jsonapi

        expect(response.body).to eq(expected_result.to_json)
      end
    end

    context 'when has some data created' do
      before do
        Click.destroy_all
        Pagina.destroy_all
      end
      let!(:pagina) { create :pagina }
      let!(:click) { create :click, pagina: pagina}
      let(:expected_result) do
        {
          data: [
            {
              id: "#{pagina.id}",
              type: "pagina",
              attributes: {
                url: pagina.url,
                code: pagina.code,
                id: pagina.id,
                created_at: pagina.created_at,
                clicks: 1
              },
              relationships: {
                clicks: {
                  data: [
                    {
                      id: "#{click.id}",
                      type: "click"
                    }
                  ]
                }
              }
            }
          ]
        }
      end

      it 'return data' do
        get :jsonapi

        expect(response.body).to eq(expected_result.to_json)
      end
    end
  end

end
