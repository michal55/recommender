module Test
  def user user_id
    keywords = User.find(user_id).keywords
    test_user = TestActivity.where(user_id: user_id).order("RANDOM()").first

  end
end