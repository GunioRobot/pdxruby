require File.dirname(__FILE__) + '/../test_helper'
require 'articles_controller'

# Re-raise errors caught by the controller.
class ArticlesController; def rescue_action(e) raise e end; end

class ArticlesControllerTest < Test::Unit::TestCase
  fixtures :articles, :members

  def setup
    @controller = ArticlesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:articles)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:article)
    assert assigns(:article).valid?
  end

  def test_new
    assert_requires_login { get :new }

    assert_accepts_login(:bob) {
      get :new

      assert_template 'new'
      assert_not_nil assigns(:article)
    }
  end

  def test_create
    num_articles = Article.count

    post :create, :article => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_articles + 1, Article.count
  end

  def test_edit
    # TODO The access control here redirects differently from the others.
    #assert_requires_login { get :edit, :id => 1 }

    assert_accepts_login(:bob) {
      get :edit, :id => 1

      assert_template 'edit'
      assert_not_nil assigns(:article)
      assert assigns(:article).valid?
    }
  end

  def test_update
    # TODO The access control here redirects differently from the others.
    #assert_requires_login { post :update, :id => 1 }

    assert_accepts_login(:bob) {
      post :update, :id => 1

      assert_redirected_to :action => 'show', :id => 1
    }
  end

  def test_destroy
    # TODO The access control here redirects differently from the others.
    #assert_requires_login { post :destroy, :id => 1 }

    assert_not_nil Article.find(1)

    assert_accepts_login(:bob) {
      post :destroy, :id => 1

      assert_redirected_to :action => 'list'
    }

    assert_raise(ActiveRecord::RecordNotFound) {
      Article.find(1)
    }
  end
end
