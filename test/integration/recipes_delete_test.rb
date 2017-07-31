require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: 'John', email: 'test@test.com', password: 'password',
                         password_confirmation: 'password')
    @recipe = Recipe.create!(name: 'Vegetable Saute',
                             description: 'Great vegetable saute, add vegetables and oil',
                             chef: @chef)
  end

  test 'successfully deletes a recipe' do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_select 'a[href=?]', recipe_path(@recipe), text: 'Delete this recipe'
    assert_difference 'Recipe.count', -1 do
      delete recipe_path(@recipe)
    end
    assert_redirected_to recipes_path
    assert_not flash.empty?
  end
end
