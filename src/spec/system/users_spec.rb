require 'rails_helper'

RSpec.describe 'Users', type: :system do
  # ユーザー情報の入力用変数
  let(:email) { 'test@example.com' }
  let(:nickname) { 'テスト太郎' }
  let(:password) { 'password' }
  let(:password_confirmation) { password }

  describe 'ユーザー登録機能の検証' do
    before { visit '/users/sign_up' }

    subject do
      fill_in 'user_nickname', with: nickname
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: password_confirmation
      click_button 'ユーザー登録'
    end

    context '正常系' do
      it 'ユーザーを作成できる' do
        expect { subject }.to change(User, :count).by(1)
        expect(current_path).to eq('/')
      end
    end

    context '異常系' do
      context 'nicknameが空の場合' do
        let(:nickname) { '' }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content("Nickname can't be blank")
        end
      end

      context 'nicknameが20文字を超える場合' do
        let(:nickname) { 'a' * 21 }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content('Nickname is too long (maximum is 20 character')
        end
      end

      context 'emailが空の場合' do
        let(:email) { '' }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content("Email can't be blank")
        end
      end

      context 'passwordが空の場合' do
        let(:password) { '' }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content("Password can't be blank")
        end
      end

      context 'passwordが6文字未満の場合' do
        let(:password) { 'a' * 5 }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content('Password is too short (minimum is 6 characters')
        end
      end

      context 'passwordが128文字を超える場合' do
        let(:password) { 'a' * 129 }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content('Password is too long (maximum is 128 characters)')
        end
      end

      context 'passwordとpassword_confirmationが一致しない場合' do
        let(:password_confirmation) { "#{password}hoge" }
        it 'ユーザーを作成せず、エラーメッセージを表示する' do
          expect { subject }.not_to change(User, :count)
          expect(page).to have_content("Password confirmation doesn't match Password")
        end
      end
    end
  end

  describe 'ログイン機能の検証' do
    before do
      create(:user, nickname: nickname, email: email, password: password, password_confirmation: password)

      visit '/users/sign_in'
      fill_in 'user_email', with: email
      fill_in 'user_password', with: 'password'
      click_button 'ログイン'
    end

    context '正常系' do
      it 'ログインに成功し、トップページにリダイレクトする' do
        expect(current_path).to eq('/')
      end

      it 'ログイン成功時にフラッシュメッセージを表示する' do
        expect(page).to have_content('Signed in successfully')
      end
    end

    context '異常系' do
      let(:password) { 'NGpassword' }
      it 'ログインに失敗し、ページ遷移しない' do
        expect(current_path).to eq('/users/sign_in')
      end

      it 'ログイン失敗時のフラッシュメッセージを表示する' do
        expect(page).to have_content('Invalid Email or password')
      end
    end
  end
end
