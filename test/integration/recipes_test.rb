require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: 'John', email: 'test@test.com', password: 'password',
                         password_confirmation: 'password')
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
    sign_in_as(@chef, 'password')
    get recipe_path(@recipe1)
    assert_template 'recipes/show'
    assert_match @recipe1.name.capitalize, response.body
    assert_match @recipe1.description, response.body
    assert_match @chef.chefname, response.body
    assert_select 'a[href=?]', edit_recipe_path(@recipe1), text: 'Edit this recipe'
    assert_select 'a[href=?]', recipe_path(@recipe1), text: 'Delete this recipe'
    assert_select 'a[href=?]', recipes_path, text: 'Return to all recipes'
  end

  test 'create new valid recipe' do
    sign_in_as(@chef, 'password')
    get new_recipe_path
    assert_template 'recipes/new'
    recipe_name = 'chicken saute'
    recipe_description = 'add chicken, add vegetables, cook for 20 minutes, service delicious meal'
    assert_difference 'Recipe.count', 1 do
      post recipes_path, params: { recipe: { name: recipe_name, description: recipe_description } }
    end
    follow_redirect!
    assert_match recipe_name.capitalize, response.body
    assert_match recipe_description, response.body
  end

  test 'reject invalid recipe submission' do
    sign_in_as(@chef, 'password')
    get new_recipe_path
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do
      post recipes_path, params: { recipe: { name: '', description: '' } }
    end
    assert_template 'recipes/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
