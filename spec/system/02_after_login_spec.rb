require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let!(:user) { create(:user) }
  let!(:study) { create(:study, image: nil, title:'hoge', user: user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it 'アイコンを押すと、トップ画面に遷移する' do
        home_link = find_all('a')[0].text
        home_link = home_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link home_link
        is_expected.to eq '/'
      end
      it 'ユーザーアイコンを押すと、自分のユーザ詳細画面に遷移する' do
        user_link = find_all('a')[1].text
        user_link = user_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link user_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it 'タイムラインを押すと、タイムライン画面に遷移する' do
        timeline_link = find_all('a')[2].text
        timeline_link = timeline_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link timeline_link
        is_expected.to eq '/timelines'
      end
      it '記録するを押すと、教材一覧画面に遷移する' do
        study_link = find_all('a')[3].text
        study_link = study_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link study_link
        is_expected.to eq '/studies'
      end
      it '通知を押すと、通知一覧画面に遷移する' do
        notification_link = find_all('a')[4].text
        notification_link = notification_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link notification_link
        is_expected.to eq '/notifications'
      end
      it 'メッセージを押すと、チャットルーム画面に遷移する' do
        room_link = find_all('a')[5].text
        room_link = room_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link room_link
        is_expected.to eq '/rooms'
      end
      it 'ユーザーを探すを押すと、ユーザー検索画面に遷移する' do
        search_user_link = find_all('a')[6].text
        search_user_link = search_user_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link search_user_link
        is_expected.to eq '/search'
      end
      it '教材を探すを押すと、教材検索画面に遷移する' do
        search_study_link = find_all('a')[7].text
        search_study_link = search_study_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link search_study_link
        is_expected.to eq '/search'
      end
      it '退会を押すと、退会画面に遷移する' do
        unsubscribe_link = find_all('a')[9].text
        unsubscribe_link = unsubscribe_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link unsubscribe_link
        is_expected.to eq  '/users/' + user.id.to_s + '/unsubscribe'
      end
    end

    describe '教材一覧画面のテスト' do
      before do
        visit studies_path
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/studies'
        end
        it '「記録する」と表示されている' do
          expect(page).to have_selector('h2', text: '記録する')
        end
        it '教材の並び替えリンクが表示されている' do
          expect(page).to have_link '勉強中', href: sort_path(sort_type: 'now')
          expect(page).to have_link 'スタンバイ', href: sort_path(sort_type: 'stay')
          expect(page).to have_link '完了済み', href: sort_path(sort_type: 'finish')
        end
        it 'カテゴリの整理リンクが表示されている' do
          expect(page).to have_link 'カテゴリの整理', href: user_tags_path(user)
        end
        it "教材画像のリンクが表示されている" do
          within(".aspect-ratio-box.icon.align-self-end") do
            expect(page).to have_css("img.img-fluid.study-image")
          end
        end
        it "教材タイトルでリンクが表示されている" do
          expect(page).to have_link study.title, href: new_study_record_path(study_id: study.id)
        end
        it "編集リンクが表示されている" do
          expect(page).to have_link '編集', href: edit_study_path(study)
        end
        it "詳細リンクが表示されている" do
          expect(page).to have_link '詳細', href: study_path(study)
        end
        it "削除リンクが表示されている" do
          expect(page).to have_link '削除', href: study_path(study)
        end
        it '新しい教材を登録リンクが表示されている' do
          expect(page).to have_link '+ 新しい教材を登録', href: new_study_path
        end
      end

      context '編集リンクのテスト' do
        it '編集画面に遷移する' do
          click_link '編集'
          expect(current_path).to eq edit_study_path(study)
        end
      end

      context '削除リンクのテスト' do
        before do
          click_link '削除'
        end
        it '正しく削除される' do
          expect(Study.where(id: study.id).count).to eq 0
        end
        it 'リダイレクト先が、教材一覧画面になっている' do
          expect(current_path).to eq '/studies'
        end
      end
    end

    describe '教材の登録画面のテスト' do
      before do
        visit new_study_path
        fill_in 'study[title]', with: Faker::Lorem.characters(number: 5)
      end

      context '投稿成功のテスト' do
        it '新しい教材が正しく保存される' do
          expect { click_button '保存' }.to change(user.studies, :count).by(1)
        end
        it 'リダイレクト先が、教材の一覧画面になっている' do
          click_button '保存'
          expect(current_path).to eq '/studies'
        end
      end
    end

    describe '自分の投稿詳細画面のテスト' do
      before do
        visit study_path(study)
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/studies/' + study.id.to_s
        end
        it '教材のtitleが表示される' do
          expect(page).to have_selector('h2', text: study.title)
        end
        it '教材の画像が表示されていること' do
          expect(page).to have_css('img.study-image')
        end
        it '教材のtitleが表示される' do
          expect(page).to have_selector('td', text: study.title)
        end
        it 'レビューを書くリンクが表示される' do
          expect(page).to have_link 'レビューを書く', href: new_study_study_review_path(study)
        end
        it '本棚に登録リンクが表示される' do
          expect(page).to have_link '本棚に登録', href: study_copy_path(study)
        end
      end
    end

    describe '自分の投稿編集画面のテスト' do
      before do
        visit edit_study_path(study)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/studies/' + study.id.to_s + '/edit'
        end
        it '教材を編集と表示される' do
          expect(page).to have_selector('h2', text: '教材を編集')
        end
        it 'title編集フォームが表示される' do
          expect(page).to have_field 'study[title]', with: study.title
        end
        it '保存ボタンが表示される' do
          expect(page).to have_button '保存'
        end
      end

      context '編集成功のテスト' do
        before do
          @study_old_title = study.title
          fill_in 'study[title]', with: Faker::Lorem.characters(number: 4)
          click_button '保存'
        end

        it 'titleが正しく更新される' do
          expect(study.reload.title).not_to eq @study_old_title
        end
        it 'リダイレクト先が、教材一覧画面になっている' do
          expect(current_path).to eq '/studies'
        end
      end
    end

    describe 'ユーザー詳細画面のテスト' do
      before do
        visit user_path(user)
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users/' + user.id.to_s
        end
        it '自分の画像が表示される' do
          expect(page).to have_css("img[src*='profile_image.jpeg']")
        end
        it '自分の名前が表示される' do
          expect(page).to have_css('.user-name', text: user.name)
        end
        it '自分のプロフィール編集リンクが表示される' do
          expect(page).to have_link 'プロフィールを編集', href: edit_user_path(user)
        end
      end
    end

    describe '自分のユーザ情報編集画面のテスト' do
      before do
        visit edit_user_path(user)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
        end
        it '名前編集フォームに自分の名前が表示される' do
          expect(page).to have_field 'user[name]', with: user.name
        end
        it '画像編集フォームが表示される' do
          expect(page).to have_field 'user[profile_image]'
        end
        it '自己紹介編集フォームが表示される' do
          expect(page).to have_field 'user[introduction]', with: user.introduction
        end
        it '保存ボタンが表示される' do
          expect(page).to have_button '保存'
        end
      end

      context '更新成功のテスト' do
        before do
          @user_old_name = user.name
          @user_old_intrpduction = user.introduction
          fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
          fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 19)
          expect(user.profile_image).to be_attached
          click_button '保存'
          save_page
        end

        it 'nameが正しく更新される' do
          expect(user.reload.name).not_to eq @user_old_name
        end
        it 'introductionが正しく更新される' do
          expect(user.reload.introduction).not_to eq @user_old_intrpduction
        end
        it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
          expect(current_path).to eq '/users/' + user.id.to_s
        end
      end
    end
  end
end