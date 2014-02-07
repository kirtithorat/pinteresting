require 'spec_helper'

describe MembersController do

  it "renders dashboard page" do
    @request.env["devise.mapping"] = Devise.mappings[:member]
    sign_in create(:member)
    get :dashboard
    expect(response).to render_template :dashboard
  end

end
