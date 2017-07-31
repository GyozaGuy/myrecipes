require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.new(chefname: 'Chefguy', email: 'test@test.com', password: 'password',
                     password_confirmation: 'password')
  end

  test 'should be valid' do
    assert @chef.valid?
  end

  test 'chefname should be present' do
    @chef.chefname = ''
    assert_not @chef.valid?
  end

  test 'chefname should be less than 30 characters' do
    @chef.chefname = 'a' * 31
    assert_not @chef.valid?
  end

  test 'email should be present' do
    @chef.email = ''
    assert_not @chef.valid?
  end

  test 'email should be less than 255 characters' do
    @chef.email = 'a' * 245 + '@example.com'
    assert_not @chef.valid?
  end

  test 'should accept correct email address formats' do
    valid_emails = %w[test@test.com user@example.com UPPER@gmail.com
                      M.first@yahoo.ca john+smith@co.uk.org]
    valid_emails.each do |valid|
      @chef.email = valid
      assert @chef.valid?, "#{valid.inspect} should be valid"
    end
  end

  test 'should reject invalid email address formats' do
    invalid_emails = %w[test@example test@example,com test.name@gmail.
                        joe@bar+foo.com]
    invalid_emails.each do |invalid|
      @chef.email = invalid
      assert_not @chef.valid?, "#{invalid.inspect} should be invalid"
    end
  end

  test 'email should be unique and case insensitive' do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test 'email should be lowercase before being inserted into the database' do
    mixed_email = 'JohN@Example.com'
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end

  test 'password should be present' do
    @chef.password = @chef.password_confirmation = ''
    assert_not @chef.valid?
  end

  test 'password should be at least 5 characters' do
    @chef.password = @chef.password_confirmation = 'xxxx'
    assert_not @chef.valid?
  end
end
