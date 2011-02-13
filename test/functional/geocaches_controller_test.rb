require 'test_helper'

class GeocachesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:geocaches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create geocache" do
    assert_difference('Geocache.count') do
      post :create, :geocache => { }
    end

    assert_redirected_to geocache_path(assigns(:geocache))
  end

  test "should show geocache" do
    get :show, :id => geocaches(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => geocaches(:one).to_param
    assert_response :success
  end

  test "should update geocache" do
    put :update, :id => geocaches(:one).to_param, :geocache => { }
    assert_redirected_to geocache_path(assigns(:geocache))
  end

  test "should destroy geocache" do
    assert_difference('Geocache.count', -1) do
      delete :destroy, :id => geocaches(:one).to_param
    end

    assert_redirected_to geocaches_path
  end
end
