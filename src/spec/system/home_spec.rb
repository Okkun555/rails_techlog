require 'rails_helper'

RSpec.describe 'Home', type: :system do
  describe 'トップページの検証' do
    it 'Home#top という文字列が表示される' do
      visit '/'

      expect(page).to have_content('Home#top')
    end
  end
end
