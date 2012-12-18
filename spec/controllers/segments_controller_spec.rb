require File.dirname(__FILE__) + '/../spec_helper'

describe SegmentsController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Segment.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Segment.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Segment.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(segment_url(assigns[:segment]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Segment.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Segment.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Segment.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Segment.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Segment.first
    response.should redirect_to(segment_url(assigns[:segment]))
  end

  it "destroy action should destroy model and redirect to index action" do
    segment = Segment.first
    delete :destroy, :id => segment
    response.should redirect_to(segments_url)
    Segment.exists?(segment.id).should be_false
  end
end
