require 'rails_helper'

RSpec.describe 'Home', type: :system do
  describe 'トップページの検証' do
    it 'Home#top という文字列が表示される' do
      visit '/'

      expect(page).to have_content('Home#top')
    end
  end

  describe 'ナビゲーションバーの検証' do
    context '未ログインの場合' do
      before { visit '/' }

      it 'ユーザー登録リンクを表示する' do
        expect(page).to have_link('ユーザー登録', href: '/users/sign_up')
      end

      it 'ログインリンクを表示する' do
        expect(page).to have_link('ログイン', href: '/users/sign_in')
      end

      it 'ログアウトリンクは表示しない' do
        expect(page).not_to have_content('ログアウト')
      end
    end

    context 'ログイン済みの場合' do
      before do
        user = create(:user)
        sign_in user
        visit '/'
      end

      it 'ユーザー登録リンクは表示しない' do
        expect(page).not_to have_content('ユーザー登録')
      end

      it 'ログインリンクは表示しない' do
        expect(page).not_to have_content('ログイン')
      end

      it 'ログアウトリンクを表示する' do
        expect(page).to have_content('ログアウト')
      end

      it 'ログアウトリンクが機能する' do
        click_button 'ログアウト'

        expect(page).to have_link('ユーザー登録', href: '/users/sign_up')
        expect(page).to have_link('ログイン', href: '/users/sign_in')
        expect(page).not_to have_content('ログアウト')
      end
    end
  end
end
