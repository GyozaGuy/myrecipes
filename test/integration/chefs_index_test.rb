require 'test_helper'

class ChefsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @chef1 = Chef.create!(chefname: 'John', email: 'test@test.com', password: 'password',
                          password_confirmation: 'password')
    @chef2 = Chef.create!(chefname: 'Jack', email: '12345@test.com', password: 'password',
                          password_confirmation: 'password')
  end

  test 'should get chefs index' do
    get chefs_url
    assert_response :success
  end

  test 'should get chefs listing' do
    get chefs_path
    assert_template 'chefs/index'
    assert_match @chef1.chefname, response.body
    assert_select 'a[href=?]', chef_path(@chef1), text: @chef1.chefname
    assert_match @chef2.chefname, response.body
    assert_select 'a[href=?]', chef_path(@chef2), text: @chef2.chefname
  end
end
