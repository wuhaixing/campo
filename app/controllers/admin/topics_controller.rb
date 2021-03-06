class Admin::TopicsController < Admin::BaseController
  def index
    @topics = Topic.desc(:created_at).paginate :per_page => 20, :page => params[:page]
    user_ids = @topics.map{|topic| topic.user_id}.flatten.compact.uniq
    @user_hash = User.create_user_hash(user_ids)
  end

  def show
    @topic = Topic.find params[:id]
  end

  def destroy
    @topic = Topic.find params[:id]
    @topic.destroy
    redirect_to :action => :index
  end

  def close
    @topic = Topic.find params[:id]
    @topic.close!
    redirect_to :action => :show, :id => @topic.id
  end

  def open
    @topic = Topic.find params[:id]
    @topic.open!
    redirect_to :action => :show, :id => @topic.id
  end
end
