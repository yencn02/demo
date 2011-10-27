require 'spec_helper'

describe AcutrackRequest do
  describe "Instance Method" do

    before :each do
      @account = Account.new
    end
  end

  describe "Class Methods" do

    describe "#get_tracking_number" do
      before :each do
        @xmlstr = mock("xml")
        @doc = mock("xml document")
        REXML::Document.should_receive(:new).with(@xmlstr).and_return @doc
      end

      it "correct XML format" do
        approval_code = mock("approval_code")
        approval_code_element = [mock("element", :text => approval_code)]
        @doc.should_receive(:get_elements).with(AcutrackRequest::TRACKING_PATH[:approval_code]).and_return approval_code_element
        dealer_id = mock("dealer_id")
        dealer_id_element = [mock("element", :text => dealer_id)]
        @doc.should_receive(:get_elements).with(AcutrackRequest::TRACKING_PATH[:dealer_id]).and_return dealer_id_element
        tracking_number = mock("tracking_number")
        tracking_number_element = [mock("element", :text => tracking_number)]
        @doc.should_receive(:get_elements).with(AcutrackRequest::TRACKING_PATH[:tracking_number]).and_return tracking_number_element
        AcutrackRequest.get_tracking_number(@xmlstr).should == {
          :approval_code => approval_code,
          :dealer_id => dealer_id,
          :tracking_number => tracking_number
        }
      end

      it "incorrect XML format" do
        @doc.should_receive(:get_elements).with(AcutrackRequest::TRACKING_PATH[:approval_code]).and_return nil
        AcutrackRequest.get_tracking_number(@xmlstr).should == {}
      end
    end

    describe "#build_shipping_response_xml" do
      it "should response xml" do
        [true, false]
        status = [true, false][rand(2)]
        tracking_info = {:approval_code => mock("approval_code")}
        hash = {
          "ShippingConfirmationResponse" => {
            "Orders" => {
              "Order" => {
                "ApprovalCode" => tracking_info[:approval_code],
                "Status" => AcutrackRequest::SHIPPING_RESPONSE[:status][status.to_s],
                "Message" => AcutrackRequest::SHIPPING_RESPONSE[:message][status.to_s]
              }
            }
          }
        }
        expected_result = hash.to_soap_xml.gsub("<ShippingConfirmationResponse>", "<ShippingConfirmationResponse xmlns=\"#{AcutrackRequest::XMLNS}\">")
        AcutrackRequest.build_shipping_response_xml(tracking_info, status).should == expected_result
      end
    end

    describe "#build_order_xml" do
      it "should return xml" do
        order_hash = mock("a hash")
        request = {"Orders" => [{"Order" => order_hash}]}
        body = AcutrackRequest::BODY.clone
        body["Request"]["RequestDocument"] = request
        expected_result = body.to_soap_xml.gsub("<RequestDocument>", "<RequestDocument LiveTransaction=\"#{LIVE_TRANSACTION}\">")
        AcutrackRequest.build_order_xml(order_hash).should == expected_result
      end
    end

    describe "#post_data" do
      before :each do
        @xml = mock("xml")
        params = {"xmlStrPO" => @xml}
        url = mock("URL", :path => mock("path"), :host => mock("host"), :port => mock("port"))
        URI.should_receive(:parse).with(ORDER_CONFIRM_URL).and_return url
        @req = mock("request")
        Net::HTTP::Post.should_receive(:new).with(url.path).and_return @req
        @req.should_receive(:form_data=).with(params)
        @con = mock("connection")
        Net::HTTP.should_receive(:new).with(url.host, url.port).and_return @con
        @con.should_receive(:use_ssl=).with(true)
      end
      it "happy case" do
        res = mock("response", :body => mock("body"))
        @con.should_receive(:request).with(@req).and_return res
        AcutrackRequest.post_data(@xml).should == res.body
      end

      it "unhappy case" do
        @con.should_receive(:request).with(@req).and_return nil
        AcutrackRequest.post_data(@xml).should == nil
      end
    end

    describe "#get_response_messages" do
      before :each do
        @response = mock("response")
      end

      describe "#happy case" do
        before :each do
          doc = mock("xml document")
          REXML::Document.should_receive(:new).with(@response).and_return doc
          code = mock("message code")
          code_element = [mock("element", :text => code)]
          doc.should_receive(:get_elements).with(AcutrackRequest::MESSAGE_CODE_PATH).and_return code_element
          message = mock("message")
          message_element = [mock("element", :text => message)]
          doc.should_receive(:get_elements).with(AcutrackRequest::MESSAGE_PATH).and_return message_element
          @message = {
            :code => code_element.first.text,
            :message => message_element.first.text
          }
        end

        it "#should receive order number" do
          order_number = mock("OrderNumber")
          @message[:message].should_receive(:match).with(/\(.*.\)/).and_return order_number
          order_number.should_receive(:to_s).and_return order_number
          order_number.should_receive(:gsub).with(/\W/, "").and_return order_number
          @message[:order_number] = order_number
          AcutrackRequest.get_response_messages(@response).should == @message
        end

        it "should not receive order number" do
          @message[:message].should_receive(:match).with(/\(.*.\)/).and_return nil
          AcutrackRequest.get_response_messages(@response).should == @message
        end
      end
      it "#unhappy case" do
        REXML::Document.should_receive(:new).with(@response).and_return nil
        AcutrackRequest.get_response_messages(@response).should == {}
      end
    end
    
  end
end