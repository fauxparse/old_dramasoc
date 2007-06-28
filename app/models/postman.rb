class Postman < ActionMailer::Base
  def booking_request(booking)
    recipients  booking.show.booking_email
    from        booking.email || "bookings@dramasoc.org"
    subject     "Online booking for #{booking.show.name}"
    bcc         "fauxparse@gmail.com"
    
    body        :booking => booking
  end
  
  def booking_confirmation(booking)
    recipients  booking.email
    from        "Dramasoc <bookings@dramasoc.org>"
    subject     "Booking confirmation for #{booking.show}"
    bcc         "fauxparse@gmail.com"
    
    body        :booking => booking
  end
end
