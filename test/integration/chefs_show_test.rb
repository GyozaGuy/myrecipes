require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: 'John', email: 'test@test.com', password: 'password',
                         password_confirmation: 'password')
    @recipe1 = Recipe.create!(name: 'Vegetable Saute',
                              description: 'Great vegetable saute, add vegetables and oil',
                              chef: @chef)
    @recipe2 = @chef.recipes.build(name: 'Chicken saute', description: 'Great chicken dish')
    @recipe2.save
  end

  test 'should get chefs show' do
    get chef_path(@chef)
    assert_template 'chefs/show'
    assert_select 'a[href=?]', recipe_path(@recipe1), text: @recipe1.name
    assert_select 'a[href=?]', recipe_path(@recipe2), text: @recipe2.name
    assert_match @recipe1.description, response.body
    assert_match @recipe2.description, response.body
    assert_match @chef.chefname, response.body
  end
end
