class OrdersController < ApplicationController
  self.allow_forgery_protection = false
  
  def receive_shipping_confirmation
    tracking_info = AcutrackRequest.get_tracking_number(request.raw_post)
    success = Order.update_tracking_number(tracking_info)
    res_xml = AcutrackRequest.build_shipping_response_xml(tracking_info, success)
    render :xml => res_xml
  end

  def test_shipping_confirm
    @xml =<<-eox
    <ShippingConfirmation xmlns="urn:acutrack:shippingConfirmation">
      <Orders>
        <Order>
          <ApprovalCode>1285666319</ApprovalCode>
          <TrackingNumber>XXXXXXXX</TrackingNumber>
          <DealerID>DI102J</DealerID>
        </Order>
      </Orders>
    </ShippingConfirmation>
    eox
  end

end
