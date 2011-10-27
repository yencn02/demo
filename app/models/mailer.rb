class Mailer < ActionMailer::Base
  helper :application

  def notify_order_number(order, credit_card)
    if order.buyer.respond_to?(:email)
      recipient = order.buyer
    else
      recipient = order.buyer.user
    end
    @subject    = 'Order Number from VIRTUALACTIVE'
    @body["recipient"] = recipient
    @body["order"] = order
    @body["credit_card"] = credit_card
    @recipients = recipient.email
    @from       = NOTIFY_EMAIL
    @sent_on    = Time.now
    @headers    = {}
  end

  def notify_tracking_number(order)
    if order.buyer.respond_to?(:email)
      recipient = order.buyer
    else
      recipient = order.buyer.user
    end
    @subject    = 'Tracking Number from VIRTUALACTIVE'
    @body["recipient"] = recipient
    @body["order"] = order
    @recipients = recipient.email
    @from       = NOTIFY_EMAIL
    @sent_on    = Time.now
    @headers    = {}
  end

  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          NOTIFY_EMAIL
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

end
