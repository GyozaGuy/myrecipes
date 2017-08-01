require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef1 = Chef.create!(chefname: 'John', email: 'test@test.com', password: 'password',
                          password_confirmation: 'password')
    @chef2 = Chef.create!(chefname: 'John', email: 'test2@test.com', password: 'password',
                          password_confirmation: 'password')
    @admin_user = Chef.create!(chefname: 'John', email: 'test3@test.com', password: 'password',
                               password_confirmation: 'password', admin: true)
  end

  test 'reject an invalid edit' do
    sign_in_as(@chef1, 'password')
    get edit_chef_path(@chef1)
    assert_template 'chefs/edit'
    patch chef_path(@chef1), params: { chef: { chefname: '', email: '' } }
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'accept valid edit' do
    sign_in_as(@chef1, 'password')
    get edit_chef_path(@chef1)
    assert_template 'chefs/edit'
    name = 'TestChef'
    email = 'tset@tset.com'
    patch chef_path(@chef1), params: { chef: { chefname: name, email: email } }
    assert_redirected_to @chef1
    assert_not flash.empty?
    @chef1.reload
    assert_match name, @chef1.chefname
    assert_match email, @chef1.email
  end

  test 'accept edit attempt by admin user' do
    sign_in_as(@admin_user, 'password')
    get edit_chef_path(@chef1)
    assert_template 'chefs/edit'
    name = 'TestChef'
    email = 'tset@tset.com'
    patch chef_path(@chef1), params: { chef: { chefname: name, email: email } }
    assert_redirected_to @chef1
    assert_not flash.empty?
    @chef1.reload
    assert_match name, @chef1.chefname
    assert_match email, @chef1.email
  end

  test 'redirect edit attempt by another non-admin user' do
    sign_in_as(@chef2, 'password')
    name = 'TestChefOfStuff'
    email = 'tset@tsettset.com'
    patch chef_path(@chef1), params: { chef: { chefname: name, email: email } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef1.reload
    assert_match 'John', @chef1.chefname
    assert_match 'test@test.com', @chef1.email
  end
end
