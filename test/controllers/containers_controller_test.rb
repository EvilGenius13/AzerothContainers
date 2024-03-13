require "test_helper"
require 'mocha/minitest'

class ContainersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @container = containers(:one)
  end

  test "index action should handle Docker errors" do
    Docker::Container.stubs(:all).raises(Docker::Error::DockerError.new("Mocked error"))
  
    get containers_url
    assert_response :success
    assert_match "Failed to connect to Docker daemon Mocked error", @response.body
  end
  
  test "should get index" do
    get containers_url
    assert_response :success
  end

  test "should get new" do
    get new_container_url
    assert_response :success
  end

  test "should create container" do
    assert_difference("Container.count") do
      post containers_url, params: { container: { name: @container.name, status: @container.status } }
    end

    assert_redirected_to container_url(Container.last)
  end

  test "should show container" do
    get container_url(@container)
    assert_response :success
  end

  test "should get edit" do
    get edit_container_url(@container)
    assert_response :success
  end

  test "should update container" do
    patch container_url(@container), params: { container: { name: @container.name, status: @container.status } }
    assert_redirected_to container_url(@container)
  end

  test "should destroy container" do
    assert_difference("Container.count", -1) do
      delete container_url(@container)
    end

    assert_redirected_to containers_url
  end
end
