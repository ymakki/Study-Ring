require 'rails_helper'

describe '[STEP3] 仕上げのテスト' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:study) { create(:study, image: nil, title:'hoge', user: user) }
  let!(:other_study) { create(:study, image: nil, title:'hogehoge', user: other_user) }

  describe 'サクセスメッセージのテスト' do
    subject { page }

    it 'ユーザ新規登録成功時' do
      visit new_user_registration_path
      fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
      fill_in 'user[email]', with: Faker::Internet.email
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button '新規登録'
      expect(page).to have_selector('.alert', text: '登録しました')
    end
    it 'ユーザログイン成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      expect(page).to have_selector('.alert', text: 'ログインしました')
    end
    it 'ユーザログアウト成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      logout_link = find_all('a')[8].text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
      expect(page).to have_selector('.alert', text: 'ログアウトしました')
    end
    it 'ユーザのプロフィール情報更新成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      visit edit_user_path(user)
      click_button '保存'
      expect(page).to have_selector('.alert', text: '更新しました')
    end
    it '新規教材の登録成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      visit new_study_path
      fill_in 'study[title]', with: Faker::Lorem.characters(number: 5)
      click_button '保存'
      expect(page).to have_selector('.alert', text: '保存しました')
    end
  end

  describe '処理失敗時のテスト' do
    context 'ユーザ新規登録失敗' do
      before do
        visit new_user_registration_path
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''
      end

      it '新規登録されない' do
        expect { click_button '新規登録' }.not_to change(User.all, :count)
      end
      it '新規登録画面を表示しており、フォームの内容が正しい' do
        click_button '新規登録'
        expect(page).to have_selector('h2', text: '新規会員登録')
        expect(page).to have_field 'user[name]'
        expect(page).to have_field 'user[email]'
        expect(page).to have_field 'user[password]'
        expect(page).to have_field 'user[password_confirmation]'
      end
      it 'バリデーションエラーが表示される' do
        click_button '新規登録'
        expect(page).to have_selector('.alert', text: 'メールアドレスを入力してください')
        expect(page).to have_selector('.alert', text: 'パスワードを入力してください')
        expect(page).to have_selector('.alert', text: '名前を入力してください')
      end
    end

    context 'ユーザのプロフィール情報編集失敗' do
      before do
        @user_old_name = user.name
        @name = ""
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit edit_user_path(user)
        fill_in 'user[name]', with: @name
        click_button '保存'
      end

      it '更新されない' do
        expect(user.reload.name).to eq @user_old_name
      end
      it 'ユーザ編集画面を表示しており、フォームの内容が正しい' do
        expect(page).to have_field 'user[name]', with: @name
      end
      it 'バリデーションエラーが表示される' do
        expect(page).to have_selector('.alert', text: '名前を入力してください')
      end
    end

    context '投稿データの新規投稿失敗' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit new_study_path
        @study = ''
        fill_in 'study[title]', with: @study
        click_button '保存'
      end

      it '投稿が保存されない' do
        expect { click_button '保存' }.not_to change(Study.all, :count)
      end
      it '投稿一覧画面を表示している' do
        expect(current_path).to eq '/studies'
        expect(page).to have_selector('h2', text: '教材を追加')
      end
      it '新規投稿フォームの内容が正しい' do
        expect(find_field('study[title]').text).to be_blank
      end
      it 'バリデーションエラーが表示される' do
        expect(page).to have_selector('.alert', text: '教材名を入力してください')
      end
    end

    context '投稿データの更新失敗' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit edit_study_path(study)
        @study_old_title = study.title
        fill_in 'study[title]', with: ''
        click_button '保存'
      end

      it '投稿が更新されない' do
        expect(study.reload.title).to eq @study_old_title
      end
      it '投稿編集画面を表示しており、フォームの内容が正しい' do
        expect(current_path).to eq '/studies/' + study.id.to_s
        expect(find_field('study[title]').text).to be_blank
      end
      it 'エラーメッセージが表示される' do
        expect(page).to have_selector('.alert', text: '教材名を入力してください')
      end
    end
  end

  describe 'ログインしていない場合のアクセス制限のテスト: アクセスできず、ログイン画面に遷移する' do
    subject { current_path }

    it 'ユーザ詳細画面' do
      visit user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it 'ユーザ編集画面' do
      visit edit_user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it '教材一覧画面' do
      visit studies_path
      is_expected.to eq '/users/sign_in'
    end
    it '教材詳細画面' do
      visit study_path(study)
      is_expected.to eq '/users/sign_in'
    end
    it '教材編集画面' do
      visit edit_study_path(study)
      is_expected.to eq '/users/sign_in'
    end
  end

  describe '他人の画面のテスト' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    describe '他人の投稿詳細画面のテスト' do
      before do
        visit study_path(other_study)
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/studies/' + other_study.id.to_s
        end
        it '教材のタイトルが表示される' do
          expect(page).to have_selector('h2', text: other_study.title)
        end
        it '教材の画像が表示される' do
          expect(page).to have_css('img.study-image')
        end
        it '投稿のtitleが表示される' do
          expect(page).to have_selector('td', text: other_study.title)
        end
        it 'レビューを書くリンクが表示される' do
          expect(page).to have_link 'レビューを書く', href: new_study_study_review_path(other_study)
        end
        it '本棚に登録リンクが表示される' do
          expect(page).to have_link '本棚に登録', href: study_copy_path(other_study)
        end
      end
    end

    context '他人の教材編集画面' do
      let!(:another_user) { create(:user) }
      it '遷移できず、教材一覧画面にリダイレクトされる' do
        second_user_study = FactoryBot.create(:study, user: user)
        sign_in another_user
        visit edit_study_path(second_user_study)
        expect(current_path).to eq '/studies'
      end
    end

    describe '他人のユーザ詳細画面のテスト' do
      before do
        visit user_path(other_user)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users/' + other_user.id.to_s
        end
        it '別ユーザーの画像が表示される' do
          expect(page).to have_css("img[src*='profile_image.jpeg']")
        end
        it '別ユーザーの名前が表示される' do
          expect(page).to have_css('.user-name', text: other_user.name)
        end
      end
    end

    context '他人のユーザ情報編集画面' do
      it '遷移できず、自分のユーザ詳細画面にリダイレクトされる' do
        visit edit_user_path(other_user)
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end

  describe 'アイコンのテスト' do
    context 'トップ画面' do
      subject { page }

      before do
        visit root_path
      end

      it 'アイコンが表示される' do
        expect(page).to have_css('img.logo-image')
      end
    end

    context 'ヘッダー: ログインしていない場合' do
      subject { page }

      before do
        visit root_path
      end

      it '新規登録リンクのアイコンが表示される' do
        is_expected.to have_selector('i.fa-solid.fa-plus')
      end
      it 'ログインリンクのアイコンが表示される' do
        is_expected.to have_selector('i.fa-solid.fa-arrow-right-to-bracket')
      end
      it 'ゲストログインリンクのアイコンが表示される' do
        is_expected.to have_selector('i.fa-solid.fa-circle-user')
      end
    end

    context 'ヘッダー: ログインしている場合' do
      subject { page }

      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ユーザー詳細リンクのアイコンが表示される' do
        user_link = find_all('a')[1]
        expect(user_link).to have_css('img.user-image')
        expect(user_link).to have_content(user.name)
      end
      it 'タイムラインリンクのアイコンが表示される' do
        is_expected.to have_selector('i.fa-solid.fa-list')
      end
      it '記録するリンクのアイコンが表示される' do
        is_expected.to have_selector('i.fa-regular.fa-pen-to-square')
      end
      it '通知リンクのアイコンが表示される' do
        is_expected.to have_selector('i.fa-solid.fa-bell')
      end
      it 'メッセージリンクのアイコンが表示される' do
        is_expected.to have_selector('i.fa-regular.fa-comments')
      end
      it 'ユーザーを探すのアイコンが表示される' do
        is_expected.to have_selector('i.fa-solid.fa-magnifying-glass')
      end
      it '教材を探すのアイコンが表示される' do
        is_expected.to have_selector('i.fa-solid.fa-magnifying-glass')
      end
      it 'ログアウトを探すのアイコンが表示される' do
        is_expected.to have_selector('i.fa-solid.fa-arrow-right-from-bracket')
      end
      it '退会するを探すのアイコンが表示される' do
        is_expected.to have_selector('i.fa-solid.fa-user-slash')
      end
    end
  end
end