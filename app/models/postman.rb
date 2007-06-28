class Postman < ActionMailer::Base
  def booking_request(booking)
    
  end
  
  def booking_confirmation(booking)
    recipients  booking.email
    from        "Dramasoc <bookings@dramasoc.org>"
    subject     "Booking confirmation for #{booking.show}"
    bcc         "fauxparse@gmail.com"
    
    body        :booking => booking
  end
end
