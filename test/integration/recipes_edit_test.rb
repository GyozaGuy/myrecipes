require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: 'John', email: 'test@test.com', password: 'password',
                         password_confirmation: 'password')
    @recipe = Recipe.create!(name: 'Vegetable Saute',
                             description: 'Great vegetable saute, add vegetables and oil',
                             chef: @chef)
  end

  test 'reject invalid recipe update' do
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    patch recipe_path(@recipe), params: { recipe: { name: '', description: 'some description' } }
    assert_template 'recipes/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'successfully edit a recipe' do
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    recipe_name = 'updated recipe name'
    recipe_description = 'updated recipe description'
    patch recipe_path(@recipe), params: { recipe: { name: recipe_name,
                                                    description: recipe_description } }
    assert_redirected_to @recipe
    assert_not flash.empty?
    @recipe.reload
    assert_match recipe_name, @recipe.name
    assert_match recipe_description, @recipe.description
  end
end
