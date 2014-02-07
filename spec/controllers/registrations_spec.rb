require 'spec_helper'

describe Devise::RegistrationsController do

  context "Member created successfully" do

    it "with valid credentials" do

      @request.env["devise.mapping"] = Devise.mappings[:member]
      @request.env["warden"] = warden

      post :create, :member => FactoryGirl.attributes_for(:member)

      member = build(:member)
      # check if member created in database
      expect(Member.find_by(email: member.email)).not_to be nil

    end

  end

  context "Member creation failed" do

    it "with duplicate credentials" do

      member = create(:member)

      @request.env["devise.mapping"] = Devise.mappings[:member]
      @request.env["warden"] = warden

      post :create, :member => attributes_for(:member)
      expect(Member.where(email: member.email).count).to eq 1
      # expect(post :create, :member => FactoryGirl.attributes_for(:member)).not_to change(Member.count)
    end

  end

end
