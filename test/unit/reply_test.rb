require 'test_helper'

class ReplyTest < ActiveSupport::TestCase
  def setup
    @user = create_user
    @topic = Topic.new :title => 'title', :content => 'content'
    @topic.user = @user
    @topic.save
  end

  def test_update_topic_replies_cache_field
    reply = Reply.new :content => 'content'
    reply.user = @user
    assert_difference "@topic.replies_count.to_i" do
      @topic.replies << reply
      assert reply.valid?
    end
    assert_equal @user, @topic.last_replied_by
    assert_equal reply.created_at, @topic.last_replied_at

    assert_difference "@topic.replies_count.to_i", -1 do
      reply.destroy
    end
    assert_nil @topic.last_replied_by
    assert_nil @topic.last_replied_at
    assert_nil @topic.replies_count
  end
end