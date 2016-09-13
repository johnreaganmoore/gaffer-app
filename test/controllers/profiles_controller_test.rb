require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profile = profiles(:one)
  end

  test "should get index" do
    get profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_profile_url
    assert_response :success
  end

  test "should create profile" do
    assert_difference('Profile.count') do
      post profiles_url, params: { profile: { date_of_birth: @profile.date_of_birth, email: @profile.email, email_verified: @profile.email_verified, first_name: @profile.first_name, last_name: @profile.last_name, person_id: @profile.person_id, phone: @profile.phone, phone_verified: @profile.phone_verified } }
    end

    assert_redirected_to profile_url(Profile.last)
  end

  test "should show profile" do
    get profile_url(@profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_profile_url(@profile)
    assert_response :success
  end

  test "should update profile" do
    patch profile_url(@profile), params: { profile: { date_of_birth: @profile.date_of_birth, email: @profile.email, email_verified: @profile.email_verified, first_name: @profile.first_name, last_name: @profile.last_name, person_id: @profile.person_id, phone: @profile.phone, phone_verified: @profile.phone_verified } }
    assert_redirected_to profile_url(@profile)
  end

  test "should destroy profile" do
    assert_difference('Profile.count', -1) do
      delete profile_url(@profile)
    end

    assert_redirected_to profiles_url
  end
end
