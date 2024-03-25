require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it '新規登録リンクが表示される' do
        sign_up_link = find_all('a')[1]
        link_text = sign_up_link.text.strip
        icon_class = sign_up_link.find('i')[:class]

        expected_text = '新規登録'
        expected_path = new_user_registration_path

        expect(link_text).to eq(expected_text)
        expect(icon_class).to include(expected_icon_class)
        expect(sign_up_link[:href]).to eq(expected_path)
      end
      it 'ログインリンクが表示される' do
        log_in_link = find_all('a')[2]
        link_text = log_in_link.text.strip
        icon_class = log_in_link.find('i')[:class]

        expected_text = 'ログイン'
        expected_path = new_user_session_path

        expect(link_text).to eq(expected_text)
        expect(icon_class).to include(expected_icon_class)
        expect(log_in_link[:href]).to eq(expected_path)
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '新規会員登録と表示される' do
        expect(page).to have_selector('h2', text: '新規会員登録')
      end
      it '名前フォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'メールフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'パスワード（確認用）フォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/users/' + User.last.id.to_s
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it 'ログインと表示される' do
        expect(page).to have_selector('h2', text: 'ログイン')
      end
      it 'メールフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
      it '名前フォームは表示されない' do
        expect(page).not_to have_field 'user[name]'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    context 'ヘッダーの表示を確認' do
      it 'ユーザーアイコンリンクが表示される' do
        user_link = find_all('a')[1]
        expect(user_link).to have_css('img.user-image')
        expect(user_link).to have_content(user.name)
      end
      it 'タイムラインリンクが表示される' do
        timeline_link = find_all('a')[2].text
        expect(timeline_link).to match('タイムライン')
      end
      it '記録するリンクが表示される' do
        study_link = find_all('a')[3].text
        expect(study_link).to match('記録する')
      end
      it '通知リンクが表示される' do
        notification_link = find_all('a')[4].text
        expect(notification_link).to match('通知')
      end
      it '通知リンクが表示される' do
        message_link = find_all('a')[5].text
        expect(message_link).to match('メッセージ')
      end
      it 'ユーザーを探すリンクが表示される' do
        search_link = find_all('a')[6].text
        expect(search_link).to match('ユーザーを探す')
      end
      it '教材を探すリンクが表示される' do
        search_link = find_all('a')[7].text
        expect(search_link).to match('教材を探す')
      end
      it 'ログアウトリンクが表示される' do
        log_out_link = find_all('a')[8].text
        expect(log_out_link).to match('ログアウト')
      end
      it '退会するリンクが表示される' do
        unsubscribe_link = find_all('a')[9].text
        expect(unsubscribe_link).to match('退会する')
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      logout_link = find_all('a')[8].text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it 'ログアウト後のリダイレクト先が、ログイン画面になっている' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end
end