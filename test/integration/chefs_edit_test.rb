require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: 'John', email: 'test@test.com', password: 'password',
                         password_confirmation: 'password')
  end

  test 'reject an invalid edit' do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: '', email: '' } }
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'accept valid edit' do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    name = 'TestChef'
    email = 'tset@tset.com'
    patch chef_path(@chef), params: { chef: { chefname: name, email: email } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match name, @chef.chefname
    assert_match email, @chef.email
  end
end
