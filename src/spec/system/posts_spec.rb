require 'rails_helper'

describe 'Post', type: :system do
  before do
    @user = create(:user)
    @post = create(:post, title: 'RSpec学習完了', content: 'System Specを作成した', user_id: @user.id)
  end

  let(:title) { 'テストタイトル' }
  let(:content) { 'テスト本文' }

  describe 'ログ投稿機能の検証' do
    subject do
      fill_in 'post_title', with: title
      fill_in 'post_content', with: content
      click_button 'ログを記録'
    end

    context 'ログインしていない場合' do
      before { visit '/posts/new' }
      it 'ログインページにリダイレクトする' do
        expect(current_path).to eq('/users/sign_in')
      end
    end

    context 'ログインしている場合' do
      before do
        sign_in @user
        visit '/posts/new'
      end

      it 'ログインページへリダイレクトしない' do
        expect(current_path).not_to eq('/users/sign_in')
      end

      context 'パラメータが正常な場合' do
        it 'Postを作成できる' do
          expect { subject }.to change(Post, :count).by(1)
          expect(current_path).to eq('/posts')
        end
      end

      context 'パラメータが異常な場合' do
        let(:title) { nil }

        it 'Postを作成できない' do
          expect { subject }.not_to change(Post, :count)
        end

        it '入力していた内容は維持される' do
          subject
          expect(page).to have_field('post_content', with: content)
        end
      end
    end
  end

  describe 'ログ詳細機能の検証' do
    before { visit "/posts/#{@post.id}" }

    it 'Postの詳細が表示される' do
      expect(page).to have_content('RSpec学習完了')
      expect(page).to have_content(@user.nickname)
    end
  end
end
