class Postman < ActionMailer::Base
  def booking_request(booking)
    recipients  booking.show.booking_email
    from        (booking.email || "bookings@dramasoc.org")
    subject     ((booking.email.blank? or booking.notify_me) ? "[ACTION REQUIRED]" : "") + "Online booking for #{booking.show.name}"
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
  
  def information_request(name, email, comments, add_me = false)
    recipients  "president@dramasoc.org"
    from        (email || "bookings@dramasoc.org")
    subject     "Please tell me more about Dramasoc"
    bcc         "fauxparse@gmail.com"
    
    body        :name => name, :email => email, :comments => comments
  end
end
