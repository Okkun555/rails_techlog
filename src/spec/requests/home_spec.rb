require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /' do
    it 'HTTPステータス200を返却' do
      get '/'
      expect(response).to have_http_status(200)
    end
  end
end
