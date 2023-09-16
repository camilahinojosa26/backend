# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  author     :integer          not null
#  body       :text
#  public     :boolean          default(TRUE)
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trip_id    :integer
#
# Indexes
#
#  index_posts_on_author   (author)
#  index_posts_on_trip_id  (trip_id)
#
require "test_helper"

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
