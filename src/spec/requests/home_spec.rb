require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'Get /' do
    it 'HTTPステータス 200を返却' do
      get '/'
      expect(response).to have_http_status(200)
    end
  end
end
