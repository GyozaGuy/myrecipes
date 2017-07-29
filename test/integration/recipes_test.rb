require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: 'John', email: 'test@test.com')
    @recipe1 = Recipe.create!(name: 'Vegetable Saute',
                              description: 'Great vegetable saute, add vegetables and oil',
                              chef: @chef)
    @recipe2 = @chef.recipes.build(name: 'Chicken saute', description: 'Great chicken dish')
    @recipe2.save
  end

  test 'should get recipes index' do
    get recipes_url
    assert_response :success
  end

  test 'should get recipes listing' do
    get recipes_path
    assert_template 'recipes/index'
    assert_match @recipe1.name, response.body
    assert_select 'a[href=?]', recipe_path(@recipe1), text: @recipe1.name
    assert_match @recipe2.name, response.body
    assert_select 'a[href=?]', recipe_path(@recipe2), text: @recipe2.name
  end

  test 'should get recipes show' do
    get recipe_path(@recipe1)
    assert_template 'recipes/show'
    assert_match @recipe1.name.capitalize, response.body
    assert_match @recipe1.description, response.body
    assert_match @chef.chefname, response.body
  end
end
