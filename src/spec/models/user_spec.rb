require 'rails_helper'

RSpec.describe User, type: :model do
  let(:nickname) { 'テスト太郎' }
  let(:email) { 'test@example.com' }
  let(:password) { '12345678' }
  let(:user) { User.new(nickname: nickname, email: email, password: password, password_confirmation: password) }

  describe '.first' do
    before do
      @user = create(:user, nickname: nickname, email: email)
      @post = create(:post, title: 'タイトル', content: '本文', user_id: @user.id)
    end

    subject { described_class.first }

    it '事前に作成した通りのUserを返す' do
      expect(subject.nickname).to eq('テスト太郎')
      expect(subject.email).to eq('test@example.com')
    end

    it '紐づくPostの情報を取得できる' do
      expect(subject.posts.size).to eq(1)
      expect(subject.posts.first.title).to eq('タイトル')
      expect(subject.posts.first.content).to eq('本文')
      expect(subject.posts.first.user_id).to eq(@user.id)
    end
  end

  describe 'validation' do
    describe 'nickname属性' do
      describe '文字数制限の検証' do
        context 'nicknameが20文字以下の場合' do
          let(:nickname) { 'a' * 20 }

          it 'Userオブジェクトは有効である' do
            expect(user.valid?).to be(true)
          end
        end

        context 'nickanmeが20文字を超える場合' do
          let(:nickname) { 'a' * 21 }

          it 'Userオブジェクトは無効である' do
            expect(user.valid?).to be(false)
            expect(user.errors[:nickname]).to include('is too long (maximum is 20 characters)')
          end
        end
      end

      describe 'nickname存在性の検証' do
        context 'nicknameが空欄の場合' do
          let(:nickname) { '' }

          it 'Userオブジェクトは無効である' do
            expect(user.valid?).to be(false)
            expect(user.errors[:nickname]).to include("can't be blank")
          end
        end
      end
    end
  end
end
