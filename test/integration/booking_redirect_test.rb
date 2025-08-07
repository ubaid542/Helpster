require "test_helper"

class BookingRedirectTest < ActionDispatch::IntegrationTest
  test "redirects to booking page after login" do
    # Create a service for testing
    service = services(:one) # Assuming you have fixtures
    
    # Try to access the booking page without being logged in
    get new_service_booking_path(service_id: service.id)
    
    # Should be redirected to login page
    assert_redirected_to new_user_session_path
    
    # Create a user and sign in
    user = users(:client) # Assuming you have a client user fixture
    post user_session_path, params: { user: { email: user.email, password: 'password' } }
    
    # Should be redirected back to the booking page
    assert_redirected_to new_service_booking_path(service_id: service.id)
  end
  
  test "stores location before redirecting to login" do
    service = services(:one)
    
    # Try to access booking page
    get new_service_booking_path(service_id: service.id)
    
    # Check that the location was stored in session
    assert_equal new_service_booking_path(service_id: service.id), session[:user_return_to]
  end
end