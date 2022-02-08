class Click < ApplicationRecord
  belongs_to :pagina


  def created_at_to_string
    created_at.to_date.to_s
  end

end
