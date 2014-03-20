require 'spec_helper'

describe MembersController do

  it "renders dashboard page" do
    @request.env["devise.mapping"] = Devise.mappings[:member]
    member = create(:member)
    sign_in member
    get :dashboard, member.attributes
    expect(response).to render_template :dashboard
  end

end
