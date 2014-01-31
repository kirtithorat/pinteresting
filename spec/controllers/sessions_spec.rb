require 'spec_helper'

include Warden::Test::Helpers
include Devise::TestHelpers
Warden.test_mode!

describe Devise::SessionsController do

  context "Authenticate Member" do

    # controller can be replaced with subject (implicit in this case)

    it "when success : valid username and password given" do

      # If you create a record in database outside an example(it block) then,
      # that record would be stored in test database permanently and
      # wouldn't be rolled back
      create(:member)
      #expect(member.firstname).to eq "John"

      @request.env["devise.mapping"] = Devise.mappings[:member]
      @request.env["warden"] = warden

      post :create, :member => FactoryGirl.attributes_for(:member)
      expect(controller.member_signed_in?).to be true
      expect(controller.current_member.email).to eq "john@gmail.com"
      expect(session["warden.user.member.key"][0].first).not_to be nil

    end


    it "when failure : invalid username and password given" do

      # member doesn't exist in database
      @request.env["devise.mapping"] = Devise.mappings[:member]
      @request.env["warden"] = warden


      begin
        post :create, :member => FactoryGirl.attributes_for(:member)
      rescue Exception => e
        expect(e.message).to eq "uncaught throw :warden"
      end

    end

  end

end

=begin

    # For future reference, figure out how to authenticate a member(warden.authenticate!)
    # controller.allow_params_authentication!
    # expect(controller.authenticate_member!(:scope => newmember, :force => true)).not_to be nil
    # sign_in mymember
    
    it "authenticate member" do

      create(:member)
      @request.env["devise.mapping"] = Devise.mappings[:member]
      @request.env["warden"] = warden

      controller.allow_params_authentication!
      controller.resource  = FactoryGirl.attributes_for(:member)
      expect(controller.authenticate_member!(:scope => :member, :force => true)).not_to be nil

    end


=end
