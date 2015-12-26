require 'rails_helper'

RSpec.describe Admin::TopController, 'ログイン後' do

  let(:administrator) { create(:administrator) }

  before do
    session[:administrator_id] = administrator.id
    session[:last_access_time] = 1.second.ago
  end

  describe '#index' do
    it '通常はstaff/top/dashboardを表示' do
      get :index
      expect(response).to render_template('admin/top/dashboard')
    end

    it '停止フラグがセットされたら強制的にログアウト' do
      administrator.update_column(:suspended, true)
      get :index
      expect(session[:administrator_id]).to be_nil
      expect(response).to redirect_to(admin_root_url)
    end

    it 'セッションタイムアウト' do
      session[:last_access_time] = Admin::Base::TIMEOUT.ago.advance(seconds: -1)
      get :index
      expect(session[:administrator_id]).to be_nil
      expect(response).to redirect_to(admin_login_url)
    end
  end

end
