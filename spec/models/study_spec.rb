require 'rails_helper'

RSpec.describe 'Studyモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { study.valid? }

    let(:user) { create(:user) }
    let!(:study) { build(:study, user_id: user.id) }

    context 'titleカラム' do
      it '空欄でないこと' do
        study.title = ''
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Study.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
end