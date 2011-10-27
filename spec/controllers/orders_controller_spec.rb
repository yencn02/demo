require 'spec_helper'

describe OrdersController do
  
  describe "#receive_shipping_confirmation" do
    it "should render xml" do
      params_xmlStrShipping = mock("params[:xmlStrShipping]")

      tracking_info = mock("tracking_info")
      AcutrackRequest.should_receive(:get_tracking_number).with(params_xmlStrShipping).and_return(tracking_info)
      success = [true, false][rand(2)]
      Order.should_receive(:update_tracking_number).with(tracking_info).and_return success
      res_xml = mock("res_xml")
      AcutrackRequest.should_receive(:build_shipping_response_xml).with(tracking_info, success).and_return res_xml

      post :receive_shipping_confirmation, :xmlStrShipping => params_xmlStrShipping
      response.content_type.should == "application/xml"
    end
  end

  describe "#test_shipping_confirm" do
    it "should render successfully" do
      xml =<<eox
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
      get :test_shipping_confirm
      response.should render_template("test_shipping_confirm")
      assigns(:xml).should == xml
    end
  end
end
