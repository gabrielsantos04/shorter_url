class Pagina < ApplicationRecord
  has_many :clicks
  before_create :generate_code

  validates :url, presence: true
  validates :url, format: { with: URI.regexp(%w(http https)), message: 'Url invalid' }

  def set_click(browser)
    Click.create(browser: browser.name, platform: browser.platform.name, pagina: self)
  end

  def clicks_by_day
    get_clicks(:created_at_to_string)
  end

  def clicks_by_browser
    get_clicks(:browser)
  end

  def clicks_by_platform
    get_clicks(:platform)
  end

  private

  def get_clicks(field)
    clicks.group_by(&field).map{|field, clicks| [field, clicks.size] }
  end

  def generate_code
    loop do
      self.code = ('A'..'Z').to_a.shuffle[0..4].join
      break unless Pagina.where(code: self.code).exists?
    end
  end
end
