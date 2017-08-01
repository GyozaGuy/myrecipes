require 'test_helper'

class ChefsDeleteTest < ActionDispatch::IntegrationTest
  test 'should delete chef' do
    chef = Chef.create!(chefname: 'John', email: 'test@test.com', password: 'password',
                        password_confirmation: 'password')
    sign_in_as(chef, 'password')
    get chefs_path
    assert_template 'chefs/index'
    assert_difference 'Chef.count', -1 do
      delete chef_path(chef)
    end
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end
end
